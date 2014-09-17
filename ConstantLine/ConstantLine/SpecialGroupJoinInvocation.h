//
//  SpecialGroupJoinInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 29/01/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class SpecialGroupJoinInvocation;

@protocol SpecialGroupJoinInvocationDelegate

-(void)SpecialGroupJoinInvocationDidFinish:(SpecialGroupJoinInvocation*)invocation
                        withResults:(NSString*)result
                       withMessages:(NSString*)msg
                          withError:(NSError*)error;

@end

@interface SpecialGroupJoinInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *friend_id;

-(NSString*)body;

@end
