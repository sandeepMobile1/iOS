//
//  AcceptRejectOwnerRequestInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AcceptRejectOwnerRequestInvocation;

@protocol AcceptRejectOwnerRequestInvocationDelegate 

-(void)AcceptRejectOwnerRequestInvocationDidFinish:(AcceptRejectOwnerRequestInvocation*)invocation 
                                    withResults:(NSString*)result
                                   withMessages:(NSString*)msg
                                      withError:(NSError*)error;

@end

@interface AcceptRejectOwnerRequestInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *groupId;
@property (nonatomic,strong)NSString *memberId;
@property (nonatomic,strong)NSString *messageId;
@property (nonatomic,strong)NSString *status;

-(NSString*)body; 

@end
