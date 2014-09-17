//
//  RegistrationInvocation.m
//  SnagFu
//
//  Created by octal i-phone2 on 7/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RegistrationInvocation.h"
#import "JSON.h"
#import "Config.h"


@implementation RegistrationInvocation

@synthesize email,password, userName,dispName,image,phoneNo,gender,dob;

-(void)invoke {
	NSString *a= @"register";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
	
	[bodyD setObject:self.email forKey:@"email_id"];    	
	[bodyD setObject:self.userName forKey:@"user_name"];	
	[bodyD setObject:self.password forKey:@"password"];
	[bodyD setObject:self.dispName forKey:@"display_name"];
    [bodyD setObject:self.image forKey:@"image"];
    [bodyD setObject:self.gender forKey:@"gender"];
    [bodyD setObject:self.dob forKey:@"dob"];
    [bodyD setObject:self.phoneNo forKey:@"phone_no"];

    
    NSLog(@"%@",bodyD);
    
	return [bodyD JSONRepresentation];
    
    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);

	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
	NSError* error = Nil;
	
	NSDictionary *rerg = [resultsd objectForKey:@"response"];
    
    
    [self.delegate registrationInvocationDidFinish:self withResults:[rerg objectForKey:@"Success"] withMessages:[rerg objectForKey:@"error"] withError:error];
    
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate registrationInvocationDidFinish:self 
                                       withResults:Nil
									  withMessages:Nil
                                         withError:[NSError errorWithDomain:@"UserId" 
                                                                       code:[[self response] statusCode]
                                                                   userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
