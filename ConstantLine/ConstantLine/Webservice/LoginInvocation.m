//
//  LoginInvocation.m
//  SnagFu
//
//  Created by octal i-phone2 on 7/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LoginInvocation.h"
#import "JSON.h"
#import "Config.h"
#import "AppDelegate.h"
#import "sqlite3.h"
#import "CommonFunction.h"

@implementation LoginInvocation

@synthesize email, password,userName,displayName,UserImage,rerg;

-(void)invoke {
	NSString *a= @"login";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
	
	[bodyD setObject:self.email forKey:@"username"];   
	[bodyD setObject:self.password forKey:@"password"];
    
    if (gDeviceToken==nil || gDeviceToken==(NSString*)[NSNull null] || [gDeviceToken isEqualToString:@""]) {
        
        NSString *rootPathToken = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPathToken = [rootPathToken stringByAppendingPathComponent:@"plistDeviceTokenData.plist"];
        NSMutableDictionary *plist_dictToken = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPathToken];
        
        gDeviceToken=[plist_dictToken valueForKey:@"device_token"];
        
    }
    
    if (gDeviceToken==nil || gDeviceToken==(NSString*)[NSNull null]) {
        
        gDeviceToken=@"";
        
    }
    
 	[bodyD setObject:gDeviceToken forKey:@"device_token"];
	
    NSLog(@"Response Body-------> %@",bodyD);
    
	return [bodyD JSONRepresentation];
    
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);

	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
    NSLog(@"%@",resultsd);
    
	NSError* error = Nil;
    
    if ([resultsd count]>0) {
        
        self.rerg = [resultsd objectForKey:@"response"];
        
        if ([self.rerg objectForKey:@"error"]==nil || [self.rerg objectForKey:@"error"]==(NSString*)[NSNull null]) {
           
            gUserId=[self.rerg objectForKey:@"user_id"];
            self.userName=[self.rerg objectForKey:@"user_name"];
            displayName=[self.rerg objectForKey:@"display_name"];
            self.UserImage=[self.rerg objectForKey:@"user_image"];
            
            [AppDelegate sharedAppDelegate].email=[self.rerg objectForKey:@"email"];
            [AppDelegate sharedAppDelegate].password=[self.rerg objectForKey:@"password"];
            
            
            NSString *totalCount=[self.rerg objectForKey:@"totalCount"];
            NSString *chatCount=[self.rerg objectForKey:@"chatCount"];
            NSString *contactCount=[self.rerg objectForKey:@"contactCount"];
            NSString *groupCount=[self.rerg objectForKey:@"groupCount"];
            
            [AppDelegate sharedAppDelegate].totalNotificationCount=[totalCount intValue];
            [AppDelegate sharedAppDelegate].chatNotificationCount=[chatCount intValue];
            [AppDelegate sharedAppDelegate].contactNotificationCount=[contactCount intValue];
            [AppDelegate sharedAppDelegate].groupChatNotificationCount=[groupCount intValue];
            
            gUserName=self.userName;
            gUserImage=self.UserImage;
            
            if (gUserImage==nil || gUserImage==(NSString*)[NSNull null] || [gUserImage isEqualToString:@""])
            {
                
            }
            else
            {
                NSString *userImage=[NSString stringWithFormat:@"%@%@",gThumbImageUrl,gUserImage];
                NSURL *url=[NSURL URLWithString:userImage];
                gUserImageData=[[NSData dataWithContentsOfURL:url] retain];
                
                NSLog(@"%@",userImage);
                NSLog(@"%d",gUserImageData.length);
            }
            
            
            NSLog(@"handleHttpOK---> 1");
            if (![gUserId isEqualToString:@""])
            {
                NSLog(@"handleHttpOK---> 2");
                [self performSelectorInBackground:@selector(checkUserDetailOnLocalDB:) withObject:gUserId];
            }
            NSLog(@"handleHttpOK---> 3");

        }
        
        [self.delegate loginInvocationDidFinish:self withResults:[self.rerg objectForKey:@"success"] withMessages:[self.rerg objectForKey:@"error"] withError:error];

    }
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate loginInvocationDidFinish:self 
                                withResults:Nil
                               withMessages:Nil
                                  withError:[NSError errorWithDomain:@"UserId" 
                                                                code:[[self response] statusCode]
                                                            userInfo:[NSDictionary dictionaryWithObject:@"Failed to login. Please try again later" forKey:@"message"]]];
	return YES;
}

#pragma Mark-------------
#pragma mark sqlite methods

-(void)checkUserDetailOnLocalDB:(NSString *)userId
{
    NSLog(@"checkUserDetailOnLocalDB 111");
    NSString *uId=@"";
      NSString *sqlStatement =[NSString stringWithFormat:@"SELECT UserId FROM tbl_user where UserId='%@'",userId];
        
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK) 
		{
			while (sqlite3_step(compiledStatement)==SQLITE_ROW)
			{
				uId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				NSLog(@"%@",uId);
			}
			
		}
		sqlite3_finalize(compiledStatement);
		
    NSLog(@"checkUserDetailOnLocalDB 112");
    
    if ([uId isEqualToString:@""]) {
        
        [self saveUserDetailOnLocalDB];
    }
    else
    {
        [self updateUserDetailOnLocalDB];
    }
    
}

-(void)saveUserDetailOnLocalDB
{
    NSString *ServerImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,self.UserImage];

       
        const char *sqlStatement = "Insert into tbl_user (UserId,UserName,UserImage,DisplayName,EmailId,PhoneNo,Gender,Dob,Rating,Unpaid_revenue) values(?,?,?,?,?,?,?,?,?,?)";
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            
            sqlite3_bind_text( compiledStatement, 1, [gUserId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [self.userName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [ServerImageName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 4, [self.displayName  UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 6, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text( compiledStatement, 7, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 8, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text( compiledStatement, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 10, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        } else {
            
            NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            
        }
        sqlite3_finalize(compiledStatement);
        
        
}
-(void)updateUserDetailOnLocalDB
{
    NSString *ServerImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,self.UserImage];

    
    NSString *sqlStatement1=[NSString stringWithFormat:@"update tbl_user set UserId = '%@',UserName = '%@',UserImage='%@' where UserId= '%@'",gUserId,self.userName,ServerImageName,gUserId];
    
    NSLog(@"%@",sqlStatement1);
    
    const char *sqlStatement=[sqlStatement1 UTF8String];
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        int success = sqlite3_step(compiledStatement);
        
        if (success == SQLITE_ERROR) {
            
            NSLog(@"updateUserDetailOnLocalDB error");
            
            
        }
        else
        {
            
            NSLog(@"updateUserDetailOnLocalDB success");
        }
        
        
    }
    
    sqlite3_finalize(compiledStatement);
}

@end

