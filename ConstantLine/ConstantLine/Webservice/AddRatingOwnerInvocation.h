//
//  AddRatingOwnerInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class AddRatingOwnerInvocation;

@protocol AddRatingOwnerInvocationDelegate 

-(void)AddRatingOwnerInvocationDidFinish:(AddRatingOwnerInvocation*)invocation 
                        withResults:(NSString*)result
                       withMessages:(NSString*)msg
                          withError:(NSError*)error;

@end
@interface AddRatingOwnerInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *owner_id;
@property (nonatomic,strong)NSString *rating;

-(NSString*)body; 

@end
