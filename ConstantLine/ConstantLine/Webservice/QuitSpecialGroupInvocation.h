//
//  QuitSpecialGroupInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 11/07/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class QuitSpecialGroupInvocation;

@protocol QuitSpecialGroupInvocationDelegate

-(void)QuitSpecialGroupInvocationDidFinish:(QuitSpecialGroupInvocation*)invocation
                        withResults:(NSString*)result
                       withMessages:(NSString*)msg
                          withError:(NSError*)error;

@end

@interface QuitSpecialGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *owner_id;
@property (nonatomic,strong)NSString *type;

-(NSString*)body;

@end
