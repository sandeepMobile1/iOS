//
//  SettingViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTableViewCell.h"
#import "ConstantLineServices.h"
#import "UnpaidRevenueInvocation.h"
#import "LogOutInvocation.h"
#import "ClearAllMessageInvocation.h"
#import "GroupListViewController.h"
#import "HelpViewController.h"
//#import "GAI.h"
//#import "GAITrackedViewController.h"
#import "NotificationSettingInvocation.h"
#import "UserProfileViewController.h"

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SettingTableViewCellDelegate,UIAlertViewDelegate,UnpaidRevenueInvocationDelegate,LogOutInvocationDelegate,ClearAllMessageInvocationDelegate,NotificationSettingInvocationDelegate>
{
    SettingTableViewCell *cell;
    ConstantLineServices *service;
    IBOutlet UINavigationBar *navigation;
    UIAlertView *logoutAlert;
    UIAlertView *clearMessageAlert;
    
    GroupListViewController *objGroupListViewController;
    HelpViewController *objHelpViewController;
    UserProfileViewController *objUserProfileViewController;
    

}
@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrSettingList;
@property(nonatomic,strong)NSMutableArray *arrSettingImageList;
@property(nonatomic,strong)NSString *revenueStr;
@property(nonatomic,assign)BOOL notificationStatus;


//- (void)dispatch;
-(IBAction)notificationSwitchPressed:(id)sender;
@end
