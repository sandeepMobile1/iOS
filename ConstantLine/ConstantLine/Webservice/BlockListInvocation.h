//
//  BlockListInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class BlockListInvocation;

@protocol BlockListInvocationDelegate 

-(void)BlockListInvocationDidFinish:(BlockListInvocation*)invocation 
                                   withResults:(NSDictionary*)result
                                  withMessages:(NSString*)msg
                                     withError:(NSError*)error;

@end
@interface BlockListInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;

-(NSString*)body; 

@end
