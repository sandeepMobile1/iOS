//
//  GroupMemberListInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupMemberListInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation GroupMemberListInvocation

@synthesize user_id,group_id;

-(void)invoke {
	NSString *a= @"groupUserListing";

	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:gUserId forKey:@"userId"];
   // [bodyD setObject:user_id forKey:@"userIds"];
    [bodyD setObject:group_id forKey:@"groupId"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *rerg=[resultsd objectForKey:@"response"];
    
    if ([rerg count]==0) {
        
        moveTabG=FALSE;
    }
	
    [self.delegate GroupMemberListInvocationDidFinish:self withResults:rerg withMessages:[rerg objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate GroupMemberListInvocationDidFinish:self 
                                               withResults:Nil
                                              withMessages:Nil
                                                 withError:[NSError errorWithDomain:@"UserId" 
                                                                               code:[[self response] statusCode]
                                                                           userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end



