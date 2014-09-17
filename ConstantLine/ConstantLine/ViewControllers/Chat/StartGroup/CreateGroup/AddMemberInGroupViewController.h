//
//  AddMemberInGroupViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMembersTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ContactListInvocation.h"
#import "ShareGroupInvocation.h"

@interface AddMemberInGroupViewController : UIViewController<AddMembersTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,UISearchBarDelegate,ContactListInvocationDelegate,UIAlertViewDelegate,UITextFieldDelegate,ShareGroupInvocationDelegate>

{
    AddMembersTableViewCell *cell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    NSRange range;
    
    IBOutlet UINavigationBar *navigation;
    
    UIAlertView *shareAlert;
    UITextField *txtShareGroup;
}
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) NSMutableArray *arrContactList;
@property(nonatomic,strong) NSString *checkContactView;
@property(nonatomic,strong) NSString *groupId;
@property(nonatomic,strong) NSString *friendId;

//-(void)displayContactsFromLocalDatabase;

@end