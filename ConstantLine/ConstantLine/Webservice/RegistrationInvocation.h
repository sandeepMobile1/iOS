//
//  RegistrationInvocation.h
//  SnagFu
//
//  Created by octal i-phone2 on 7/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class RegistrationInvocation;

@protocol RegistrationInvocationDelegate 

-(void)registrationInvocationDidFinish:(RegistrationInvocation*)invocation 
						   withResults:(NSString*)result
                          withMessages:(NSString*)msg
							 withError:(NSError*)error;

@end

@interface RegistrationInvocation :ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *dispName;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *phoneNo;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *dob;

-(NSString*)body; 

@end
