//
//  UnSubcribeInvocation.h
//  ConstantLine
//
//  Created by Pramod Sharma on 19/11/13.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class UnSubcribeInvocation;

@protocol UnSubcribeInvocationDelegate

-(void)UnSubcribeInvocationDidFinish:(UnSubcribeInvocation*)invocation
                                   withResults:(NSString*)result
                                  withMessages:(NSString*)msg
                                     withError:(NSError*)error;

@end
@interface UnSubcribeInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *transection_id;

-(NSString*)body;

@end
