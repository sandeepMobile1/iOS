//
//  BlockContactListViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandedTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "BlockListInvocation.h"
#import "ContactTableViewCell.h"
#import "FriendProfileViewController.h"
#import "BlockInvocation.h"

@class ChatViewController;
@class UserProfileViewController;

@interface BlockContactListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,BlockListInvocationDelegate,RecommandedTableViewCellDelegate,ImageCacheDelegate,BlockInvocationDelegate>
{
    RecommandedTableViewCell *cell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    
    IBOutlet UINavigationBar *navigation;
    
    ChatViewController *objChatViewController;
    UserProfileViewController *objUserProfileViewController;
    FriendProfileViewController *objFriendProfileViewController;

}

@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrBlockList;


@end
