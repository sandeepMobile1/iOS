//
//  SendPhoneListInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SendPhoneListInvocation.h"
#import "Config.h"

@implementation SendPhoneListInvocation

@synthesize user_id,phone_num_list;

-(void)invoke {
	NSString *a= @"findcontact";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:phone_num_list forKey:@"phoneNumber"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease]JSONValue];
    
	NSError* error = Nil;
	
    [self.delegate SendPhoneListInvocationDidFinish:self withResults:[resultsd objectForKey:@"response"]withMessages:@""  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate SendPhoneListInvocationDidFinish:self 
                                            withResults:Nil
                                           withMessages:Nil
                                              withError:[NSError errorWithDomain:@"UserId" 
                                                                            code:[[self response] statusCode]
                                                                        userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
