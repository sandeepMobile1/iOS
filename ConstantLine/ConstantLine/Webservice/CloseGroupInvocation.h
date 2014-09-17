//
//  CloseGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class CloseGroupInvocation;

@protocol CloseGroupInvocationDelegate 

-(void)CloseGroupInvocationDidFinish:(CloseGroupInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end

@interface CloseGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *group_status;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *thread_id;

-(NSString*)body; 

@end
