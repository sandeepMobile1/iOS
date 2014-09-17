//
//  AcceptRejectGroupChatInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AcceptRejectGroupChatInvocation;

@protocol AcceptRejectGroupChatInvocationDelegate 

-(void)AcceptRejectGroupChatInvocationDidFinish:(AcceptRejectGroupChatInvocation*)invocation 
                               withResults:(NSString*)result
                              withMessages:(NSString*)msg
                                 withError:(NSError*)error;

@end
@interface AcceptRejectGroupChatInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *groupId;
@property (nonatomic,strong)NSString *groupUserTableId;
@property (nonatomic,strong)NSString *groupOwnerId;
@property (nonatomic,strong)NSString *status;

-(NSString*)body; 

@end
