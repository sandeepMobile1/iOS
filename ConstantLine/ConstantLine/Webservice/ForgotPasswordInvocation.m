//
//  ForgotPasswordInvocation.m
//  SnagFu
//
//  Created by octal i-phone2 on 7/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswordInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation ForgotPasswordInvocation

@synthesize emailId;

-(void)invoke {
	NSString *a= @"forgot_password";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
	
	[bodyD setValue:self.emailId forKey:@"email"];
  	
    NSLog(@"%@",bodyD);
    
	return [bodyD JSONRepresentation];
    
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
	NSError* error = Nil;
    
    NSDictionary *rerg = [resultsd objectForKey:@"response"];

    
    [self.delegate ForgotPasswordInvocationDidFinish:self withResults:[rerg objectForKey:@"success"] withMessages:[rerg objectForKey:@"error"] withError:error];
    
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate ForgotPasswordInvocationDidFinish:self
                                         withResults:Nil
                                        withMessages:Nil
                                           withError:[NSError errorWithDomain:@"UserId"
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
