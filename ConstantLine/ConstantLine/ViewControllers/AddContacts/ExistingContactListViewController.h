//
//  ExistingContactListViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandedTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ExistingAppUsersListInvocation.h"
#import "AddContactListInvocation.h"
#import "FriendProfileViewController.h"

@class ChatViewController;
@class UserProfileViewController;

@interface ExistingContactListViewController : UIViewController<RecommandedTableViewCellDelegate,ExistingAppUsersListInvocationDelegate,UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,UISearchBarDelegate,AddContactListInvocationDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    UIAlertView *addContactAlert;
    
    RecommandedTableViewCell *cell;
    ImageCache *objImageCache;
    IBOutlet UISearchBar *searchBar;
    ConstantLineServices *service;
    NSRange range;
    
    IBOutlet UINavigationBar *navigation;
    
    UserProfileViewController *objUserProfileViewController;
    FriendProfileViewController *objFriendProfileViewController;

    UITextView *alertTextField;
    
    ChatViewController *objChatViewController;
    
    IBOutlet UILabel *lblNoResult;
    int totalCharacterCount;

}
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrContactList;
@property(nonatomic,strong)NSMutableArray *arrSearchContactList;
@property (nonatomic,strong)NSString *checkView;
@property (nonatomic,strong)NSString *friendId;

- (void)handleSearchForTerm:(NSString *)searchTerm;
@end

