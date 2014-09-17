//
//  FBLoginInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 13/06/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class FBLoginInvocation;

@protocol FBLoginInvocationDelegate

-(void)FBLoginInvocationDidFinish:(FBLoginInvocation*)invocation
                    withResults:(NSString*)result
                   withMessages:(NSString*)msg
                      withError:(NSError*)error;

@end

@interface FBLoginInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSString *UserImage;
@property (nonatomic,retain)NSDictionary *rerg;

-(NSString*)body;
-(void)checkUserDetailOnLocalDB:(NSString*)userId;
-(void)saveUserDetailOnLocalDB;
-(void)updateUserDetailOnLocalDB;


@end
