//
//  AddPrivillegeInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/24/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AddPrivillegeInvocation;

@protocol AddPrivillegeInvocationDelegate 

-(void)AddPrivillegeInvocationDidFinish:(AddPrivillegeInvocation*)invocation 
                         withResults:(NSString*)result
                        withMessages:(NSString*)msg
                           withError:(NSError*)error;

@end
@interface AddPrivillegeInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *owner_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *friend_id;

-(NSString*)body; 

@end
