//
//  BlockInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class BlockInvocation;

@protocol BlockInvocationDelegate 

-(void)BlockInvocationDidFinish:(BlockInvocation*)invocation 
                                        withResults:(NSString*)result
                                       withMessages:(NSString*)msg
                                          withError:(NSError*)error;

@end
@interface BlockInvocation :  ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *type;

-(NSString*)body; 

@end
