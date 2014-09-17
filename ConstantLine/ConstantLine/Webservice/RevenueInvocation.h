//
//  RevenueInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 11/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class RevenueInvocation;

@protocol RevenueInvocationDelegate 

-(void)RevenueInvocationDidFinish:(RevenueInvocation*)invocation 
                                       withResults:(NSString*)result
                                      withMessages:(NSString*)msg
                                         withError:(NSError*)error;

@end

@interface RevenueInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *transaction_id;
@property (nonatomic,strong)NSString *subscription_charge;

-(NSString*)body; 

@end
