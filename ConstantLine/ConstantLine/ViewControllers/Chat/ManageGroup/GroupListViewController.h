//
//  GroupListViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListTableViewCell.h"
#import "ChatListUnpaidTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ManageGroupListInvocation.h"
#import "GroupInfoViewController.h"

@class StartGroupViewController;

@interface GroupListViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,ChatListUnpaidTableViewCellDelegate,UISearchBarDelegate,ManageGroupListInvocationDelegate,UISearchBarDelegate>

{
    StartGroupViewController *objStartGroupView;

    IBOutlet UINavigationBar *navigation;
    ChatListTableViewCell *cell;
    ChatListUnpaidTableViewCell *unpaidCell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    GroupInfoViewController *objGroupInfoViewController;
    
    IBOutlet UIView *BottomView;
    IBOutlet UILabel *lblTotalRecordCount;
    IBOutlet UIImageView *imgBottomView;
    BOOL checkPaging;
    
    IBOutlet UISearchBar *searchBar;


}
@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrGroupList;
@property (nonatomic,assign)int totalRecord;
@property(nonatomic,assign)int page;


-(NSString *) stringByStrippingHTML:(NSString*)intro;


@end
