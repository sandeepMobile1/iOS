//
//  AddRatingOwnerInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddRatingOwnerInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation AddRatingOwnerInvocation

@synthesize user_id,rating,owner_id;

-(void)invoke {
	NSString *a= @"groupOwnerRating";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:user_id forKey:@"userId"];
    [bodyD setObject:owner_id forKey:@"ownerId"];
    [bodyD setObject:rating forKey:@"rating"];
    
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];

    [self.delegate AddRatingOwnerInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AddRatingOwnerInvocationDidFinish:self 
                                    withResults:Nil
                                   withMessages:Nil
                                      withError:[NSError errorWithDomain:@"UserId" 
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end






