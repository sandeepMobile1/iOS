//
//  GroupTypeEditInvocation.h
//  ConstantLine
//
//  Created by Pramod Sharma on 15/11/13.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class GroupTypeEditInvocation;

@protocol GroupTypeEditInvocationDelegate

-(void)GroupTypeEditInvocationDidFinish:(GroupTypeEditInvocation*)invocation
                      withResults:(NSString*)result
                     withMessages:(NSString*)msg
                        withError:(NSError*)error;

@end


@interface GroupTypeEditInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *group_type;

-(NSString*)body;

@end
