//
//  GroupDetailInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupDetailInvocation.h"
#import "JSON.h"
#import "Config.h"

@implementation GroupDetailInvocation

@synthesize user_id,group_id;

-(void)invoke {
	NSString *a= @"groupInfo";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:self.group_id forKey:@"id"];
    [bodyD setObject:self.user_id forKey:@"user_id"];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *dic=[resultsd objectForKey:@"response"];
    
    if ([dic count]==0) {
        
        moveTabG=FALSE;
    }
    
      NSLog(@"%d",[resultsd count]);
    NSLog(@"%@",[dic objectForKey:@"Group"]);
     NSLog(@"%@",[dic objectForKey:@"error"]);
	
    [self.delegate GroupDetailInvocationDidFinish:self withResults:[dic objectForKey:@"Group"] withMessages:[dic objectForKey:@"error"] withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate GroupDetailInvocationDidFinish:self 
                                   withResults:Nil
                                  withMessages:Nil
                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                   code:[[self response] statusCode]
                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end



