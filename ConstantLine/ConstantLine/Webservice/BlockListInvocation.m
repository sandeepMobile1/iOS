//
//  BlockListInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BlockListInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation BlockListInvocation

@synthesize user_id;

-(void)invoke {
	NSString *a= @"block_list";
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
    
    NSDictionary *rerg=[resultsd objectForKey:@"response"];
    
    if ([rerg count]==0) {
        
        moveTabG=FALSE;
    }
	
    [self.delegate BlockListInvocationDidFinish:self withResults:rerg withMessages:[rerg objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate BlockListInvocationDidFinish:self 
                                               withResults:Nil
                                              withMessages:Nil
                                                 withError:[NSError errorWithDomain:@"UserId" 
                                                                               code:[[self response] statusCode]
                                                                           userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end




