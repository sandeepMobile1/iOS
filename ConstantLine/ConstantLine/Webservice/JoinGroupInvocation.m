//
//  JoinGroupInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JoinGroupInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation JoinGroupInvocation

@synthesize user_id,group_id,friend_id;

-(void)invoke {
	NSString *a= @"userSendGroupInvitation";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.group_id forKey:@"groupId"];
    [bodyD setObject:self.friend_id forKey:@"memberId"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"response"];
	
    [self.delegate JoinGroupInvocationDidFinish:self withResults:[responseDic objectForKey:@"success"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate JoinGroupInvocationDidFinish:self 
                                                    withResults:Nil
                                                   withMessages:Nil
                                                      withError:[NSError errorWithDomain:@"UserId" 
                                                                                    code:[[self response] statusCode]
                                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end