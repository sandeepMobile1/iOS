//
//  SendCreditCardDetailInvocation.m
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import "SendCreditCardDetailInvocation.h"
#import "Config.h"
#import "JSON.h"

@implementation SendCreditCardDetailInvocation

@synthesize user_id,credit_card_name,credit_card_account,credit_card_expirydate,credit_card_type,credit_card_crnNumber,group_id;

-(void)invoke {
	NSString *a= @"process_payment";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    [bodyD setObject:self.user_id forKey:@"userId"];
    [bodyD setObject:self.group_id forKey:@"groupId"];
    [bodyD setObject:self.credit_card_name forKey:@"card_name"];
    [bodyD setObject:self.credit_card_account forKey:@"account_number"];
    [bodyD setObject:self.credit_card_type forKey:@"card_type"];
    [bodyD setObject:self.credit_card_expirydate forKey:@"expiry_date"];
    [bodyD setObject:self.credit_card_crnNumber forKey:@"crn_number"];

    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"response"];
	
    [self.delegate SendCreditCardDetailInvocationDidFinish:self withResults:[responseDic objectForKey:@"success"] withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate SendCreditCardDetailInvocationDidFinish:self
                                    withResults:Nil
                                   withMessages:Nil
                                      withError:[NSError errorWithDomain:@"UserId"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
