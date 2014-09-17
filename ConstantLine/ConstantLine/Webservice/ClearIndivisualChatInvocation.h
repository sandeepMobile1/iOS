//
//  ClearIndivisualChatInvocation.h
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ClearIndivisualChatInvocation;

@protocol ClearIndivisualChatInvocationDelegate

-(void)ClearIndivisualChatInvocationDidFinish:(ClearIndivisualChatInvocation*)invocation
                              withResults:(NSString*)result
                             withMessages:(NSString*)msg
                                withError:(NSError*)error;

@end
@interface ClearIndivisualChatInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;

-(NSString*)body;

@end
