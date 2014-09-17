//
//  ManageGroupListInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class ManageGroupListInvocation;

@protocol ManageGroupListInvocationDelegate 

-(void)ManageGroupListInvocationDidFinish:(ManageGroupListInvocation*)invocation 
                       withResults:(NSDictionary*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end

@interface ManageGroupListInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *pageString;
@property (nonatomic,strong)NSString *searchtext;

-(NSString*)body; 

@end
