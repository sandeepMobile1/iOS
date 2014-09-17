//
//  UrlSchemeInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 27/06/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class UrlSchemeInvocation;

@protocol UrlSchemeInvocationDelegate

-(void)UrlSchemeInvocationDidFinish:(UrlSchemeInvocation*)invocation
                                  withResults:(NSDictionary*)result
                                 withMessages:(NSString*)msg
                                    withError:(NSError*)error;

@end

@interface UrlSchemeInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *groupCode;

-(NSString*)body;

@end
