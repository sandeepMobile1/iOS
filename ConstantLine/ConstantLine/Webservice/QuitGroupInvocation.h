//
//  QuitGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class QuitGroupInvocation;

@protocol QuitGroupInvocationDelegate 

-(void)QuitGroupInvocationDidFinish:(QuitGroupInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end
@interface QuitGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *owner_id;
@property (nonatomic,strong)NSString *type;

-(NSString*)body; 

@end
