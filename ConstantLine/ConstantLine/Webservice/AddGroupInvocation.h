//
//  AddGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AddGroupInvocation;

@protocol AddGroupInvocationDelegate 

-(void)AddGroupInvocationDidFinish:(AddGroupInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end

@interface AddGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_name;
@property (nonatomic,strong)NSString *group_intro;
@property (nonatomic,strong)NSString *configuration_plan;
@property (nonatomic,strong)NSString *members_list;
@property (nonatomic,strong)NSString *subscription_period;
@property (nonatomic,strong)NSString *subscription_charge;
@property (nonatomic,strong)NSString *group_image;

-(NSString*)body; 

@end
