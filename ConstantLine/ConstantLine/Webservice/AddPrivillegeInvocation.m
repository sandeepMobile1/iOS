//
//  AddPrivillegeInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/24/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddPrivillegeInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation AddPrivillegeInvocation

@synthesize owner_id,group_id,friend_id;

-(void)invoke {
	NSString *a= @"groupPrivailage";
    
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.owner_id forKey:@"ownerId"];
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
    
    NSDictionary *rerg=[resultsd objectForKey:@"response"];
	
    [self.delegate AddPrivillegeInvocationDidFinish:self withResults:[rerg objectForKey:@"success"] withMessages:[rerg objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AddPrivillegeInvocationDidFinish:self 
                                     withResults:Nil
                                    withMessages:Nil
                                       withError:[NSError errorWithDomain:@"UserId" 
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
