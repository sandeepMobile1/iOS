//
//  SendPhoneContactsInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class SendPhoneContactsInvocation;

@protocol SendPhoneContactsInvocationDelegate 

-(void)SendPhoneContactsInvocationDidFinish:(SendPhoneContactsInvocation*)invocation 
                                withResults:(NSDictionary*)result
                               withMessages:(NSString*)msg
                                  withError:(NSError*)error;

@end
@interface SendPhoneContactsInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *phone_num_list;
@property (nonatomic,strong)NSString *user_name;

-(NSString*)body; 

@end

