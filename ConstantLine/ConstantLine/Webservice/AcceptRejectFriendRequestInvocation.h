//
//  AcceptRejectFriendRequestInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AcceptRejectFriendRequestInvocation;

@protocol AcceptRejectFriendRequestInvocationDelegate 

-(void)AcceptRejectFriendRequestInvocationDidFinish:(AcceptRejectFriendRequestInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end
@interface AcceptRejectFriendRequestInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *type;

-(NSString*)body; 

@end
