//
//  AddGroupInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddGroupInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation AddGroupInvocation

@synthesize user_id,group_name,group_intro,configuration_plan,members_list,subscription_period,subscription_charge,group_image;
-(void)invoke {
	NSString *a= @"add_group";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:group_name forKey:@"group_name"];
    [bodyD setObject:group_intro forKey:@"group_intro"];
    [bodyD setObject:members_list forKey:@"members_list"];
    [bodyD setObject:subscription_period forKey:@"subscription_period"];
    [bodyD setObject:subscription_charge forKey:@"subscription_charge"];
    [bodyD setObject:group_image forKey:@"group_image"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
	
    [self.delegate AddGroupInvocationDidFinish:self withResults:[resultsd objectForKey:@"success"] withMessages:[resultsd objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AddGroupInvocationDidFinish:self 
                                         withResults:Nil
                                        withMessages:Nil
                                           withError:[NSError errorWithDomain:@"UserId" 
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end





