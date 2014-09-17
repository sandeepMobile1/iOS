//
//  ContactListInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactListInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation ContactListInvocation

@synthesize user_id;

-(void)invoke {
	NSString *a= @"contact_listing";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"user_id"];
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    NSDictionary *dic=[resultsd objectForKey:@"response"];

    if ([dic count]==0) {
        
        moveTabG=FALSE;
    }

	NSError* error = Nil;
	
    [self.delegate ContactListInvocationDidFinish:self withResults:[dic objectForKey:@"success"] withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate ContactListInvocationDidFinish:self 
                                   withResults:Nil
                                  withMessages:Nil
                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end



