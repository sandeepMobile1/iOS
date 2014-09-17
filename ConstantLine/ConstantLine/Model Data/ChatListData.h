//
//  ChatListData.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListData : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *charge;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *readStatus;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *chatType;
@property(nonatomic,strong)NSString *groupType;
@property(nonatomic,strong)NSString *paidStatus;
@property(nonatomic,strong)NSString *messasgeId;
@property(nonatomic,assign)float cellHeight;
@property(nonatomic,strong)NSString *zChatId;
@property(nonatomic,strong)NSString *requestStatus;
@property(nonatomic,strong)NSString *groupUserTableId;
@property(nonatomic,strong)NSString *groupOwnerId;
@property(nonatomic,strong)NSString *groupJoinStatus;
@property(nonatomic,strong)NSString *subscribeStatus;
@property(nonatomic,strong)NSString *chatStatus;
@property(nonatomic,strong)NSString *latestStatus;
@property(nonatomic,strong)NSString *unreadMessageCount;
@property(nonatomic,strong)NSString *groupParentId;
@property(nonatomic,strong)NSString *groupSpecialType;
@property(nonatomic,strong)NSString *groupCode;

@end
