//
//  DeleteChatInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class DeleteChatInvocation;

@protocol DeleteChatInvocationDelegate 

-(void)DeleteChatInvocationDidFinish:(DeleteChatInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end

@interface DeleteChatInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *message_id;

-(NSString*)body; 

@end
