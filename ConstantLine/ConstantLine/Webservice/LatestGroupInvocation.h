//
//  LatestGroupInvocation.h
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class LatestGroupInvocation;

@protocol LatestGroupInvocationDelegate

-(void)LatestGroupInvocationDidFinish:(LatestGroupInvocation*)invocation
                              withResults:(NSDictionary*)result
                             withMessages:(NSString*)msg
                                withError:(NSError*)error;

@end

@interface LatestGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *pageString;

-(NSString*)body;

@end
