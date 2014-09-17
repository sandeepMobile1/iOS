//
//  ClearGroupMessageInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ClearGroupMessageInvocation;

@protocol ClearGroupMessageInvocationDelegate 

-(void)ClearGroupMessageInvocationDidFinish:(ClearGroupMessageInvocation*)invocation 
                              withResults:(NSString*)result
                             withMessages:(NSString*)msg
                                withError:(NSError*)error;

@end
@interface ClearGroupMessageInvocation :ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;

-(NSString*)body; 

@end
