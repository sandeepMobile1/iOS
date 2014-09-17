//
//  ChatListInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatListInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation ChatListInvocation

@synthesize user_id,searchString;

-(void)invoke {
	NSString *a= @"chat_listing";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:user_id forKey:@"user_id"];
    [bodyD setObject:searchString forKey:@"search_name"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);

    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease]JSONValue];
    NSLog(@"%@",resultsd);
    
	NSError* error = Nil;
	
    NSDictionary *dic=[resultsd objectForKey:@"response"];
    
    if ([dic count]==0) {
        
        moveTabG=FALSE;
    }
    
    [self.delegate ChatListInvocationDidFinish:self withResults:dic withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
   
    moveTabG=FALSE;
	
    [self.delegate ChatListInvocationDidFinish:self 
                                   withResults:Nil
                                  withMessages:Nil
                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end


