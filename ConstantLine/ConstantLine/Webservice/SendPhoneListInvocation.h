//
//  SendPhoneListInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class SendPhoneListInvocation;

@protocol SendPhoneListInvocationDelegate 

-(void)SendPhoneListInvocationDidFinish:(SendPhoneListInvocation*)invocation 
                                withResults:(NSDictionary*)result
                               withMessages:(NSString*)msg
                                  withError:(NSError*)error;

@end
@interface SendPhoneListInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *phone_num_list;

-(NSString*)body; 

@end
