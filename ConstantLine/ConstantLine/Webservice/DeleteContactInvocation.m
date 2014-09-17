//
//  DeleteContactInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DeleteContactInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation DeleteContactInvocation

@synthesize user_id,friend_id;

-(void)invoke {
	NSString *a= @"delete_contact";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
   // [bodyD setObject:user_id forKey:@"id"];
   // [bodyD setObject:friend_id forKey:@"friend_id"];
     [bodyD setObject:friend_id forKey:@"id"];

    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];

	
    [self.delegate DeleteContactInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate DeleteContactInvocationDidFinish:self 
                                         withResults:Nil
                                        withMessages:Nil
                                           withError:[NSError errorWithDomain:@"UserId" 
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end





