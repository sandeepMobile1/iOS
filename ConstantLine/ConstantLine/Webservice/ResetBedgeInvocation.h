//
//  ResetBedgeInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ResetBedgeInvocation;

@protocol ResetBedgeInvocationDelegate 

-(void)ResetBedgeInvocationDidFinish:(ResetBedgeInvocation*)invocation 
                         withResults:(NSString*)result
                        withMessages:(NSString*)msg
                           withError:(NSError*)error;

@end


@interface ResetBedgeInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *userId;

-(NSString*)body; 

@end
