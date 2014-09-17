//
//  UnpaidRevenueInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class UnpaidRevenueInvocation;

@protocol UnpaidRevenueInvocationDelegate 

-(void)UnpaidRevenueInvocationDidFinish:(UnpaidRevenueInvocation*)invocation 
                       withResults:(NSDictionary*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end
@interface UnpaidRevenueInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;

-(NSString*)body; 

@end
