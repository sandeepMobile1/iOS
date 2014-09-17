//
//  PrivateChatListData.h
//  ConstantLine
//
//  Created by Pramod Sharma on 20/11/13.
//
//

#import <Foundation/Foundation.h>

@interface PrivateChatListData : NSObject

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
@property(nonatomic,assign)NSString *zChatId;
@property(nonatomic,strong)NSString *requestStatus;
@property(nonatomic,strong)NSString *groupUserTableId;
@property(nonatomic,strong)NSString *groupOwnerId;
@property(nonatomic,strong)NSString *groupJoinStatus;
@property(nonatomic,strong)NSString *subscribeStatus;
@property(nonatomic,strong)NSString *chatStatus;


@end
