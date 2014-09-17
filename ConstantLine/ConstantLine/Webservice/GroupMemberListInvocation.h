//
//  GroupMemberListInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class GroupMemberListInvocation;

@protocol GroupMemberListInvocationDelegate 

-(void)GroupMemberListInvocationDidFinish:(GroupMemberListInvocation*)invocation 
                                   withResults:(NSDictionary*)result
                                  withMessages:(NSString*)msg
                                     withError:(NSError*)error;

@end
@interface GroupMemberListInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;

-(NSString*)body; 

@end
