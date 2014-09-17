//
//  EditProfileInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class EditProfileInvocation;

@protocol EditProfileInvocationDelegate 

-(void)EditProfileInvocationDidFinish:(EditProfileInvocation*)invocation 
                       withResults:(NSString*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end
@interface EditProfileInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *user_image;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *dob;
@property (nonatomic,strong)NSString *intro;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *display_name;
@property (nonatomic,strong)NSString *phone_no;

-(NSString*)body; 

@end
