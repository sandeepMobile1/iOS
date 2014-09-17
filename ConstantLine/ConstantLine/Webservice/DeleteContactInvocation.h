//
//  DeleteContactInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class DeleteContactInvocation;

@protocol DeleteContactInvocationDelegate 

-(void)DeleteContactInvocationDidFinish:(DeleteContactInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end
@interface DeleteContactInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;

-(NSString*)body; 

@end
