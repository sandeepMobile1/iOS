//
//  KickOffMemberInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class KickOffMemberInvocation;

@protocol KickOffMemberInvocationDelegate 

-(void)KickOffMemberInvocationDidFinish:(KickOffMemberInvocation*)invocation 
                        withResults:(NSString*)result
                       withMessages:(NSString*)msg
                          withError:(NSError*)error;

@end
@interface KickOffMemberInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *thread_id;

-(NSString*)body; 

@end
