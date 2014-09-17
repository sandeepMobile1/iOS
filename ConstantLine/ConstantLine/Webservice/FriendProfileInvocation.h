//
//  FriendProfileInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class FriendProfileInvocation;

@protocol FriendProfileInvocationDelegate 

-(void)FriendProfileInvocationDidFinish:(FriendProfileInvocation*)invocation 
                            withResults:(NSDictionary*)result
                           withMessages:(NSString*)msg
                              withError:(NSError*)error;

@end
@interface FriendProfileInvocation : ConstantLineInvocation {
	
}
@property (nonatomic,strong)NSString *friend_id;

@property (nonatomic,strong)NSString *user_id;

-(NSString*)body; 

@end