//
//  SendCreditCardDetailInvocation.h
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class SendCreditCardDetailInvocation;

@protocol SendCreditCardDetailInvocationDelegate

-(void)SendCreditCardDetailInvocationDidFinish:(SendCreditCardDetailInvocation*)invocation
                          withResults:(NSString*)result
                         withMessages:(NSString*)msg
                            withError:(NSError*)error;

@end
@interface SendCreditCardDetailInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *credit_card_name;
@property (nonatomic,strong)NSString *credit_card_account;
@property (nonatomic,strong)NSString *credit_card_type;
@property (nonatomic,strong)NSString *credit_card_expirydate;
@property (nonatomic,strong)NSString *credit_card_crnNumber;
@property (nonatomic,strong)NSString *group_id;

-(NSString*)body;

@end
