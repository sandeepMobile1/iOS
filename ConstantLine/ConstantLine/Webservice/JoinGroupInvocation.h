//
//  JoinGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class JoinGroupInvocation;

@protocol JoinGroupInvocationDelegate 

-(void)JoinGroupInvocationDidFinish:(JoinGroupInvocation*)invocation 
                                        withResults:(NSString*)result
                                       withMessages:(NSString*)msg
                                          withError:(NSError*)error;

@end
@interface JoinGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *friend_id;

-(NSString*)body; 

@end
