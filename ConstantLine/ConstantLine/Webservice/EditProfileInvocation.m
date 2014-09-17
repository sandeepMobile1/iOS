//
//  EditProfileInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EditProfileInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation EditProfileInvocation

@synthesize user_id,user_name,user_image,gender,dob,intro,email,display_name,phone_no;

-(void)invoke {
	NSString *a= @"edit_profile";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
	
    [self.delegate EditProfileInvocationDidFinish:self withResults:[resultsd objectForKey:@"success"] withMessages:[resultsd objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate EditProfileInvocationDidFinish:self 
                                         withResults:Nil
                                        withMessages:Nil
                                           withError:[NSError errorWithDomain:@"UserId" 
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end





