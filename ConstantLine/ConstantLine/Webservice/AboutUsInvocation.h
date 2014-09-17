//
//  AboutUsInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 29/01/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AboutUsInvocation;

@protocol AboutUsInvocationDelegate

-(void)AboutUsInvocationDidFinish:(AboutUsInvocation*)invocation
                         withResults:(NSDictionary*)result
                        withMessages:(NSString*)msg
                           withError:(NSError*)error;

@end
@interface AboutUsInvocation : ConstantLineInvocation {
	
}
-(NSString*)body;

@end
