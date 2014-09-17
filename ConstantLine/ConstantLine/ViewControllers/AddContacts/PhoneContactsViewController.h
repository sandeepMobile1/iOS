//
//  PhoneContactsViewController.h
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
#import "SendPhoneContactsInvocation.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AddContactListInvocation.h"

@interface PhoneContactsViewController : UIViewController<RecommandedTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,UISearchBarDelegate,SendPhoneContactsInvocationDelegate,MFMessageComposeViewControllerDelegate,AddContactListInvocationDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    RecommandedTableViewCell *cell;
    IBOutlet UISearchBar *searchBar;
    ConstantLineServices *service;
    NSRange range;
    
    UIAlertView *addContactAlert;
    
    IBOutlet UINavigationBar *navigation;
    
    NSString *phoneNumList;
    NSString *userName;

    NSString *phoneNum;
    UIAlertView *phoneAlert;
    IBOutlet UILabel *lblNoResult;
    
    UITextView *alertTextField;

}
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) NSMutableArray *arrContactList;
@property(nonatomic,strong) NSString *phoneNumList;
@property(nonatomic,strong)  NSString *friendId;
@property(nonatomic,strong)NSMutableArray *arrSearchContactList;

- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
