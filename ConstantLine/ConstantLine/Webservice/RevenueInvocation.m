//
//  RevenueInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 11/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RevenueInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation RevenueInvocation

@synthesize user_id,group_id,transaction_id,subscription_charge;

-(void)invoke {
	NSString *a= @"groupTransaction";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    NSLog(@"%@",self.transaction_id);
    NSLog(@"%@",self.group_id);
    NSLog(@"%@",self.transaction_id);
    NSLog(@"%@",self.subscription_charge);

    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.group_id forKey:@"groupId"];
    [bodyD setObject:self.transaction_id forKey:@"transactionId"];
    [bodyD setObject:self.subscription_charge forKey:@"price"];
    
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"response"];
	 
    [self.delegate RevenueInvocationDidFinish:self withResults:[responseDic objectForKey:@"success"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate RevenueInvocationDidFinish:self 
                                                   withResults:Nil
                                                  withMessages:Nil
                                                     withError:[NSError errorWithDomain:@"UserId" 
                                                                                   code:[[self response] statusCode]
                                                                               userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end

