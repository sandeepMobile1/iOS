//
//  Chat.m
//  Dolphin6
//
//  Created by Enuke Software on 09/12/11.
//  Copyright 2011 Enuke Software. All rights reserved.
//

#import "Chat.h"


@implementation Chat

@synthesize Id, sUserName, sUserType, sProfile, sData, sTime, bubbleSize, status,sUserImage;

-(void)dealloc {
	self.Id = Nil;
	self.sUserName = Nil;
	self.sUserType = Nil;
	self.sProfile = Nil;
	self.sData = Nil;
	self.sTime = Nil;
    self.sUserImage=Nil;
	self.status = Nil;
	[super dealloc];
}

@end
