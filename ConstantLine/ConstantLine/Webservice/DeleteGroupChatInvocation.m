//
//  DeleteGroupChatInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DeleteGroupChatInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation DeleteGroupChatInvocation

@synthesize user_id,group_id,message_id;

-(void)invoke {
	NSString *a= @"delete_groupchat";
	[self post:a body:[self body]];
}

-(NSString*)body {
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:group_id forKey:@"group_id"];
    [bodyD setObject:message_id forKey:@"message_id"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}
-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease]JSONValue];
    
	NSError* error = Nil;
	
    [self.delegate DeleteGroupChatInvocationDidFinish:self withResults:[resultsd objectForKey:@"success"] withMessages:[resultsd objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate DeleteGroupChatInvocationDidFinish:self 
                                         withResults:Nil
                                        withMessages:Nil
                                           withError:[NSError errorWithDomain:@"UserId" 
                                                                         code:[[self response] statusCode]
                                                                     userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end





