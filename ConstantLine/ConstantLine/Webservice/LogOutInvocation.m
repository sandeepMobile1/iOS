//
//  LogOutInvocation.m
//  SmackTalk360
//
//  Created by octal i-phone2 on 7/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LogOutInvocation.h"
#import "Config.h"

@implementation LogOutInvocation

@synthesize userId,deviceToken;

-(void)invoke {
	NSString *a= @"logout";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
	
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
    [bodyD setObject:self.userId forKey:@"user_id"];
    NSLog(@"%@",bodyD);
    
	return [bodyD JSONRepresentation];
    
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];
    
    [self.delegate LogOutInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate LogOutInvocationDidFinish:self
                                             withResults:Nil
                                            withMessages:Nil
                                               withError:[NSError errorWithDomain:@"UserId"
                                                                             code:[[self response] statusCode]
                                                                         userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}


@end

