//
//  Chat+Parse.h
//  大画家
//
//  Created by Shweta Sharma on 11/06/12.
//  Copyright 2012 octalinfosolution Pvt Ltd. All rights reserved.
//

#import "Chat.h"

@interface Chat (Parse)

+(Chat*) ChatsFromDictionary:(NSDictionary*)Chatsd;
+(NSArray*) ChatsFromArray:(NSArray*) ChatsA;

@end
