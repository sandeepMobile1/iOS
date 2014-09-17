//
//  ShareGroupInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ShareGroupInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation ShareGroupInvocation

@synthesize user_id,group_id,friend_id,group_code;

-(void)invoke {
	NSString *a= @"groupInvitation";
    
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.group_id forKey:@"groupId"]; 
    [bodyD setObject:self.friend_id forKey:@"memberId"];
    [bodyD setObject:self.group_code forKey:@"groupCode"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *rerg=[resultsd objectForKey:@"response"];
	
    [self.delegate ShareGroupInvocationDidFinish:self withResults:[rerg objectForKey:@"success"] withMessages:[rerg objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate ShareGroupInvocationDidFinish:self 
                                          withResults:Nil
                                         withMessages:Nil
                                            withError:[NSError errorWithDomain:@"UserId" 
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end




