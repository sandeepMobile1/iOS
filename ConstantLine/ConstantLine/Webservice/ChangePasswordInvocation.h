//
//  ChangePasswordInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ChangePasswordInvocation;

@protocol ChangePasswordInvocationDelegate 

-(void)ChangePasswordInvocationDidFinish:(ChangePasswordInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end
@interface ChangePasswordInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *oPass;
@property (nonatomic,strong)NSString *nPass;

-(NSString*)body; 

@end
