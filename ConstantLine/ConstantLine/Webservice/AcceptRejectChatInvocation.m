//
//  AcceptRejectChatInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AcceptRejectChatInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation AcceptRejectChatInvocation

@synthesize user_id,friend_id,type;

-(void)invoke {
	NSString *a= @"chat_action";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:user_id forKey:@"chatId"];
    [bodyD setObject:friend_id forKey:@"memberId"];
    [bodyD setObject:type forKey:@"status"];
    [bodyD setObject:gUserId forKey:@"userId"];

    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"UserFriend"];
	
    [self.delegate AcceptRejectChatInvocationDidFinish:self withResults:[responseDic objectForKey:@"sucess"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AcceptRejectChatInvocationDidFinish:self 
                                                    withResults:Nil
                                                   withMessages:Nil
                                                      withError:[NSError errorWithDomain:@"UserId" 
                                                                                    code:[[self response] statusCode]
                                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
