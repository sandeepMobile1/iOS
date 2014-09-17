//
//  ShareGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ShareGroupInvocation;

@protocol ShareGroupInvocationDelegate 

-(void)ShareGroupInvocationDidFinish:(ShareGroupInvocation*)invocation 
                              withResults:(NSString*)result
                             withMessages:(NSString*)msg
                                withError:(NSError*)error;

@end
@interface ShareGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *friend_id;
@property (nonatomic,strong)NSString *group_code;

-(NSString*)body; 

@end
