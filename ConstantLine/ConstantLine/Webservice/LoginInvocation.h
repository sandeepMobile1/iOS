//
//  LoginInvocation.h
//  SnagFu
//
//  Created by octal i-phone2 on 7/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class LoginInvocation;

@protocol LoginInvocationDelegate 

-(void)loginInvocationDidFinish:(LoginInvocation*)invocation 
                    withResults:(NSString*)result
                   withMessages:(NSString*)msg
                      withError:(NSError*)error;

@end
@interface LoginInvocation : ConstantLineInvocation {
	
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
