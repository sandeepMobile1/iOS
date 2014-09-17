//
//  ChatListInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ChatListInvocation;

@protocol ChatListInvocationDelegate 

-(void)ChatListInvocationDidFinish:(ChatListInvocation*)invocation 
                                withResults:(NSDictionary*)result
                               withMessages:(NSString*)msg
                                  withError:(NSError*)error;

@end
@interface ChatListInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *searchString;

-(NSString*)body; 

@end
