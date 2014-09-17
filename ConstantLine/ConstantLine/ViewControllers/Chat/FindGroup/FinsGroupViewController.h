//
//  FinsGroupViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListTableViewCell.h"
#import "ChatListUnpaidTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ExistingAppUsersListInvocation.h"
#import "AddContactListInvocation.h"
#import "FindGroupInvocation.h"
#import "JoinGroupInvocation.h"

@interface FinsGroupViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,ChatListUnpaidTableViewCellDelegate,FindGroupInvocationDelegate,UISearchBarDelegate,JoinGroupInvocationDelegate,ChatListTableViewCellDelegate>
{
    IBOutlet UINavigationBar *navigation;
    ChatListTableViewCell *cell;
    ChatListUnpaidTableViewCell *unpaidCell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    IBOutlet UISearchBar *searchBar;



}
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrGroupList;
@property(nonatomic,strong)NSMutableArray *arrSearchGroupList;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
