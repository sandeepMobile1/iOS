//
//  Chat+Parse.m
//  大画家
//
//  Created by Shweta Sharma on 11/06/12.
//  Copyright 2012 octalinfosolution Pvt Ltd. All rights reserved.
//

#import "Chat+Parse.h"
#import "JSON.h"
#import "Chat.h"
#import "QSStrings.h"

@implementation Chat (Parse)

+(Chat*) ChatsFromDictionary:(NSDictionary*)Chatsd{
	if (!Chatsd) {
		return Nil;
	}

	Chat *u = [[[Chat alloc]init] autorelease];
    u.Id =  [Chatsd objectForKey:@"msgId"];
	
	NSString *data = [Chatsd objectForKey:@"data"];
	if([data length] > 0){
		
		NSData* base64String = [QSStrings decodeBase64WithString:data];
		
		u.sData = [[[NSString alloc] initWithData:base64String 
											   encoding:NSUTF8StringEncoding] autorelease];
	}
	
	u.sUserType =  [Chatsd objectForKey:@"type"];
	
	return u;
}

+(NSArray*) ChatsFromArray:(NSArray*) ChatsA{
	if (!ChatsA) {
		return Nil;
	}
	
	NSMutableArray *users = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < ChatsA.count; i++) {
        Chat *u = [Chat ChatsFromDictionary:[ChatsA objectAtIndex:i]];
        if (u) {
            [users addObject:u];
        }
    }	
	
	return users;	
}

@end

