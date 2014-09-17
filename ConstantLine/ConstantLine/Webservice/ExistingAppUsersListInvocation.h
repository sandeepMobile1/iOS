//
//  ExistingAppUsersListInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ExistingAppUsersListInvocation;

@protocol ExistingAppUsersListInvocationDelegate 

-(void)ExistingAppUsersListInvocationDidFinish:(ExistingAppUsersListInvocation*)invocation 
                       withResults:(NSDictionary*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end
@interface ExistingAppUsersListInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *search_string;

-(NSString*)body; 

@end
