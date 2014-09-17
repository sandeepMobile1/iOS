//
//  AcceptRejectOwnerRequestInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AcceptRejectOwnerRequestInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation AcceptRejectOwnerRequestInvocation

@synthesize user_id,groupId,memberId,messageId,status;

-(void)invoke {
	NSString *a= @"OwnerGroupAction";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.groupId forKey:@"groupId"];
    [bodyD setObject:self.status forKey:@"status"];
    [bodyD setObject:self.memberId forKey:@"memberId"];
    [bodyD setObject:self.messageId forKey:@"messageId"];
    
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"UserFriend"];
	
    [self.delegate AcceptRejectOwnerRequestInvocationDidFinish:self withResults:[responseDic objectForKey:@"sucess"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AcceptRejectOwnerRequestInvocationDidFinish:self 
                                                withResults:Nil
                                               withMessages:Nil
                                                  withError:[NSError errorWithDomain:@"UserId" 
                                                                                code:[[self response] statusCode]
                                                                            userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
