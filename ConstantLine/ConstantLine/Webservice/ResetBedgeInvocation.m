//
//  ResetBedgeInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ResetBedgeInvocation.h"
#import "JSON.h"
#import "Config.h"
#import "AppDelegate.h"

@implementation ResetBedgeInvocation

@synthesize userId;


-(void)invoke {
	NSString *a= @"unsetBedge";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
	
    [bodyD setObject:self.userId forKey:@"user_id"];
	
    NSLog(@"Response Body-------> %@",bodyD);
    
	return [bodyD JSONRepresentation];
    
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    
    NSLog(@"handleHttpOK");
    
    NSLog(@"handleHttpOK---> %@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
                                                    encoding:NSUTF8StringEncoding] autorelease]JSONValue];
	NSError* error = Nil;
	
	NSDictionary *rerg = [resultsd objectForKey:@"response"];
   
    NSString *totalCount=[rerg objectForKey:@"totalCount"];
    NSString *chatCount=[rerg objectForKey:@"chatCount"];
    NSString *contactCount=[rerg objectForKey:@"contactCount"];
    NSString *groupCount=[rerg objectForKey:@"groupCount"];

    
    NSLog(@"%@",totalCount);
     
    [AppDelegate sharedAppDelegate].totalNotificationCount=[totalCount intValue];
    [AppDelegate sharedAppDelegate].chatNotificationCount=[chatCount intValue];
    [AppDelegate sharedAppDelegate].contactNotificationCount=[contactCount intValue];
    [AppDelegate sharedAppDelegate].groupChatNotificationCount=[groupCount intValue];

    if ([AppDelegate sharedAppDelegate].groupChatNotificationCount>0) {
        
        UITabBarItem *tabBarItem = (UITabBarItem *)[[AppDelegate sharedAppDelegate].tabBarController.tabBar.items objectAtIndex:0];
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].groupChatNotificationCount];
        
    }
    else
    {
        [[[AppDelegate sharedAppDelegate].tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
        
    }
    

    if ([AppDelegate sharedAppDelegate].chatNotificationCount>0) {
        
        UITabBarItem *tabBarItem = (UITabBarItem *)[[AppDelegate sharedAppDelegate].tabBarController.tabBar.items objectAtIndex:1];
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].chatNotificationCount];
        
    }
    else
    {
        [[[AppDelegate sharedAppDelegate].tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];

    }
    if ([AppDelegate sharedAppDelegate].contactNotificationCount>0) {
        
        UITabBarItem *tabBarItem = (UITabBarItem *)[[AppDelegate sharedAppDelegate].tabBarController.tabBar.items objectAtIndex:2];
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].contactNotificationCount];
        
    }
    else
    {
        [[[AppDelegate sharedAppDelegate].tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
        
    }

    
    [self.delegate ResetBedgeInvocationDidFinish:self withResults:[rerg objectForKey:@"success"] withMessages:[rerg objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate ResetBedgeInvocationDidFinish:self 
                                     withResults:Nil
                                    withMessages:Nil
                                       withError:[NSError errorWithDomain:@"UserId" 
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to login. Please try again later" forKey:@"message"]]];
	return YES;
}

@end