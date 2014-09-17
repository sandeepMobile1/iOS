//
//  BlockInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BlockInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation BlockInvocation

@synthesize user_id,friend_id,type;

-(void)invoke {
	NSString *a= @"updateMemberBlock";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:friend_id forKey:@"member_id"];
    [bodyD setObject:type forKey:@"block"];
    
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"response"];
	
    [self.delegate BlockInvocationDidFinish:self withResults:[responseDic objectForKey:@"success"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate BlockInvocationDidFinish:self 
                                                    withResults:Nil
                                                   withMessages:Nil
                                                      withError:[NSError errorWithDomain:@"UserId" 
                                                                                    code:[[self response] statusCode]
                                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end





