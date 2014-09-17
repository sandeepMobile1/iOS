//
//  FindGroupInvocation.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class FindGroupInvocation;

@protocol FindGroupInvocationDelegate 

-(void)FindGroupInvocationDidFinish:(FindGroupInvocation*)invocation 
                       withResults:(NSDictionary*)result
                      withMessages:(NSString*)msg
                         withError:(NSError*)error;

@end

@interface FindGroupInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *searchCriteria;
@property (nonatomic,strong)NSString *pageString;

-(NSString*)body; 

@end
