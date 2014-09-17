//
//  SendChatInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class SendChatInvocation;

@protocol SendChatInvocationDelegate 

-(void)SendChatInvocationDidFinish:(SendChatInvocation*)invocation 
                       withResults:(NSString*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end
@interface SendChatInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *imageName;
@property (nonatomic,strong)NSString *audioName;
@property (nonatomic,strong)NSString *namecardId;
@property (nonatomic,strong)NSString *threadId;
@property (nonatomic,strong)NSString *groupId;
@property (nonatomic,strong)NSString *groupType;
@property (nonatomic,strong)NSString *publicPrivateType;

-(NSString*)body; 

@end
