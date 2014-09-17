//
//  LogOutInvocation.h
//  SmackTalk360
//
//  Created by octal i-phone2 on 7/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ConstantLineInvocation.h"
#import "SAServiceAsyncInvocation.h"

@class LogOutInvocation;

@protocol LogOutInvocationDelegate

-(void)LogOutInvocationDidFinish:(LogOutInvocation*)invocation
                                 withResults:(NSString*)result
                                withMessages:(NSString*)msg
                                   withError:(NSError*)error;

@end

@interface LogOutInvocation : ConstantLineInvocation{
    
}
@property(strong, nonatomic)NSString *userId;
@property(strong, nonatomic)NSString *deviceToken;

-(NSString*)body;

@end
