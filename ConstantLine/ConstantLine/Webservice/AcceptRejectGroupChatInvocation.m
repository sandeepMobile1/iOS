//
//  AcceptRejectGroupChatInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AcceptRejectGroupChatInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation AcceptRejectGroupChatInvocation

@synthesize user_id,groupId,groupUserTableId,groupOwnerId,status;

-(void)invoke {
	NSString *a= @"group_action";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.groupId forKey:@"groupId"];
    [bodyD setObject:self.status forKey:@"status"];
    [bodyD setObject:self.groupOwnerId forKey:@"groupOwnerId"];
    [bodyD setObject:self.groupUserTableId forKey:@"groupUserTableId"];

    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"UserFriend"];
	
    [self.delegate AcceptRejectGroupChatInvocationDidFinish:self withResults:[responseDic objectForKey:@"sucess"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AcceptRejectGroupChatInvocationDidFinish:self 
                                           withResults:Nil
                                          withMessages:Nil
                                             withError:[NSError errorWithDomain:@"UserId" 
                                                                           code:[[self response] statusCode]
                                                                       userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

