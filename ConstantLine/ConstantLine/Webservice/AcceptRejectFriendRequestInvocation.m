//
//  AcceptRejectFriendRequestInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AcceptRejectFriendRequestInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation AcceptRejectFriendRequestInvocation

@synthesize user_id,friend_id,type;

-(void)invoke {
	NSString *a= @"contact_action";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:gUserId forKey:@"userId"];
    [bodyD setObject:friend_id forKey:@"memberId"];
    [bodyD setObject:type forKey:@"status"];
    [bodyD setObject:user_id forKey:@"contactId"];

    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"UserFriend"];
	
    [self.delegate AcceptRejectFriendRequestInvocationDidFinish:self withResults:[responseDic objectForKey:@"sucess"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AcceptRejectFriendRequestInvocationDidFinish:self 
                                         withResults:Nil
                                        withMessages:Nil
                                           withError:[NSError errorWithDomain:@"UserId" 
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end




