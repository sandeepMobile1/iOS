//
//  SearchChatListingViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListTableViewCell.h"
#import "ChatListUnpaidTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ChatListInvocation.h"
#import "AcceptRejectChatInvocation.h"
#import "AcceptRejectGroupChatInvocation.h"
#import "PrivateChatContactsViewController.h"
//#import "GAI.h"
//#import "GAITrackedViewController.h"

@class AddContactViewController;
@class ChatViewController;
@class StartGroupViewController;
@class GroupListViewController;
@class FinsGroupViewController;

@interface SearchChatListingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,ChatListUnpaidTableViewCellDelegate,ChatListInvocationDelegate,UISearchBarDelegate,AcceptRejectChatInvocationDelegate,AcceptRejectGroupChatInvocationDelegate>
{
    IBOutlet UINavigationBar *navigation;
    ChatListTableViewCell *cell;
    ChatListUnpaidTableViewCell *unpaidCell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    IBOutlet UISearchBar *searchBar;
    
    PrivateChatContactsViewController *objPrivateChatController;

    
    NSString *checkPN;
    AddContactViewController *objAddContactViewController;
    ChatViewController *objChatViewController;
    StartGroupViewController *objStartGroupView;
    GroupListViewController *objGroupListViewController;
    FinsGroupViewController *objFinsGroupViewController;
    int unreadCount;
    
    IBOutlet UIButton    *btnNotification;
    IBOutlet UIImageView *imgTopView;
    IBOutlet UIButton    *btnStartGroup;
    IBOutlet UIButton    *btnManageGroup;
    IBOutlet UIButton    *btnFindGroup;
    NSString *checkTableHeight;

}
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrChatList;
@property(nonatomic,strong)NSMutableArray *arrPrivateChatList;

- (void)handleSearchForTerm:(NSString *)searchTerm;

-(IBAction)stratGroupPressed:(id)sender;
-(IBAction)manageGroupPressed:(id)sender;
-(IBAction)findGroupPressed:(id)sender;
//- (void)dispatch;
@end
