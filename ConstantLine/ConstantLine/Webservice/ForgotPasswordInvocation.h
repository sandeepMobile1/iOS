//
//  ForgotPasswordInvocation.h
//  SnagFu
//
//  Created by octal i-phone2 on 7/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ForgotPasswordInvocation;

@protocol ForgotPasswordInvocationDelegate

-(void)ForgotPasswordInvocationDidFinish:(ForgotPasswordInvocation*)invocation
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end
@interface ForgotPasswordInvocation : ConstantLineInvocation {
	
}

@property(strong, nonatomic)NSString *emailId;

-(NSString*)body;

@end
