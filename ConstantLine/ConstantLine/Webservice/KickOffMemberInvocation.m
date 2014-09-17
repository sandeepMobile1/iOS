//
//  KickOffMemberInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "KickOffMemberInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation KickOffMemberInvocation

@synthesize user_id,friend_id,group_id,thread_id;

-(void)invoke {
	NSString *a= @"groupKickOut";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    NSLog(@"%@",self.thread_id);
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.friend_id forKey:@"memberId"];
    [bodyD setObject:self.thread_id forKey:@"threadId"];
    [bodyD setObject:self.group_id forKey:@"groupId"];

    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease]JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];

	
    [self.delegate KickOffMemberInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate KickOffMemberInvocationDidFinish:self 
                                    withResults:Nil
                                   withMessages:Nil
                                      withError:[NSError errorWithDomain:@"UserId" 
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end






