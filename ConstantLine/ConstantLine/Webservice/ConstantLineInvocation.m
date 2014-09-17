//
//  ConstantLineInvocation.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ConstantLineInvocation.h"

@implementation ConstantLineInvocation

-(id)init {
	self = [super init];
	if (self) {
		self.clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
		self.clientVersionHeaderName = @"ProductStore-Client-Version";
	}
	return self;
}
@end
