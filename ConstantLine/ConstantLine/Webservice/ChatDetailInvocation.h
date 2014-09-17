//
//  ChatDetailInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ChatDetailInvocation;

@protocol ChatDetailInvocationDelegate 

-(void)ChatDetailInvocationDidFinish:(ChatDetailInvocation*)invocation 
                       withResults:(NSDictionary*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end

@interface ChatDetailInvocation :ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *lastMsg_id;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *groupType;
@property (nonatomic,strong)NSString *groupId;
@property (nonatomic,strong)NSString *page;

-(NSString*)body; 

@end
