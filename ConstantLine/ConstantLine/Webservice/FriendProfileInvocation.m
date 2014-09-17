//
//  FriendProfileInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FriendProfileInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation FriendProfileInvocation

@synthesize user_id,friend_id;

-(void)invoke {
	NSString *a= @"friend_profile";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:friend_id forKey:@"friend_id"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease]JSONValue];
    
	NSError* error = Nil;
	
    [self.delegate FriendProfileInvocationDidFinish:self withResults:resultsd withMessages:@"" withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate FriendProfileInvocationDidFinish:self 
                                        withResults:Nil
                                       withMessages:Nil
                                          withError:[NSError errorWithDomain:@"UserId" 
                                                                        code:[[self response] statusCode]
                                                                    userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end




