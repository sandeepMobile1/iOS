//
//  ClearAllMessageInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ClearAllMessageInvocation;

@protocol ClearAllMessageInvocationDelegate

-(void)ClearAllMessageInvocationDidFinish:(ClearAllMessageInvocation*)invocation
                              withResults:(NSString*)result
                             withMessages:(NSString*)msg
                                withError:(NSError*)error;

@end
@interface ClearAllMessageInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;

-(NSString*)body; 

@end
