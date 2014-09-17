//
//  EditIntroOfGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class EditIntroOfGroupInvocation;

@protocol EditIntroOfGroupInvocationDelegate 

-(void)EditIntroOfGroupInvocationDidFinish:(EditIntroOfGroupInvocation*)invocation 
                             withResults:(NSString*)result
                            withMessages:(NSString*)msg
                               withError:(NSError*)error;

@end

@interface EditIntroOfGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *intro;

-(NSString*)body; 

@end
