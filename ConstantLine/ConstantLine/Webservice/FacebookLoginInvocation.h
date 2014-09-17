//
//  FacebookLoginInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 30/01/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class FacebookLoginInvocation;

@protocol FacebookLoginInvocationDelegate

-(void)FacebookLoginInvocationDidFinish:(FacebookLoginInvocation*)invocation
                    withResults:(NSString*)result
                   withMessages:(NSString*)msg
                      withError:(NSError*)error;

@end

@interface FacebookLoginInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSString *UserImage;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *dob;
@property (nonatomic,retain)NSDictionary *rerg;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *fbId;

-(NSString*)body;
-(void)checkUserDetailOnLocalDB:(NSString*)userId;
-(void)saveUserDetailOnLocalDB;
-(void)updateUserDetailOnLocalDB;

@end
