//
//  FindGroupInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FindGroupInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation FindGroupInvocation

@synthesize user_id,searchCriteria,pageString;

-(void)invoke {
	NSString *a= @"findGroup";
	[self post:a body:[self body]];
}

-(NSString*)body {
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:user_id forKey:@"userId"];
    [bodyD setObject:searchCriteria forKey:@"search_name"];
    [bodyD setObject:self.pageString forKey:@"page"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];

	
    [self.delegate FindGroupInvocationDidFinish:self withResults:dic withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate FindGroupInvocationDidFinish:self 
                                   withResults:Nil
                                  withMessages:Nil
                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end



