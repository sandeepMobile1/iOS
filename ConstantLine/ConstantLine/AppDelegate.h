//
//  AppDelegate.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "ContactViewController.h"
#import "SettingViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "sqlite3.h"
#import <CoreData/CoreData.h>
#import "ResetBedgeInvocation.h"
#import "ConstantLineServices.h"
#import "GroupViewController.h"
#import "FBConnect.h"
//#import "GAI.h"
#import "FirstViewController.h"

#import "RESideMenu.h"

@class SearchChatListingViewController;

@interface AppDelegate : UIResponder <RESideMenuDelegate,UIApplicationDelegate,UITabBarControllerDelegate,ResetBedgeInvocationDelegate,UISplitViewControllerDelegate,FBSessionDelegate,UIAlertViewDelegate>
{
  	NSOperationQueue *myQueue;
	BOOL isOpen;
    NSOperationQueue *queue;
    
    ConstantLineServices *service;
    UIAlertView *appRateAlert;
    UIAlertView *exitAlert;
}

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationClassReference;
@property (nonatomic, assign) BOOL _appIsInbackground;
@property (assign, nonatomic) int appType,totalNotificationCount,chatNotificationCount,contactNotificationCount,groupChatNotificationCount,appRateCounter;
@property (strong, nonatomic) UIView *viewToolBarBase;
@property (strong, nonatomic)NSData *dataMsg;
@property (strong, nonatomic)NSString *attachement;
@property (strong, nonatomic)NSString *attachementimg;
@property (strong, nonatomic)NSData *senderimgData;
@property (strong, nonatomic)NSString *strsenderImage;
@property(nonatomic,retain) UISplitViewController *splitViewController;

@property (strong, nonatomic) FirstViewController *objFirstViewController;

@property (strong, nonatomic) SettingViewController *objSettingViewController;
@property (strong, nonatomic) ContactViewController *objContactViewController;

@property (strong, nonatomic) LoginViewController *objLoginViewController;
@property (strong, nonatomic) RegistrationViewController *objRegistrationViewController;

@property (strong, nonatomic) GroupViewController *objGroupViewController;


@property (assign, nonatomic) int rememberTag;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *nameCardId;
@property (strong, nonatomic) NSString *nameCardName;
@property (strong, nonatomic) NSString *nameCardImage;

@property (strong, nonatomic) NSString *checkNameCard;
@property (strong, nonatomic) NSString *selectedMembers;
@property (strong, nonatomic) NSMutableArray *arrSelectedContactList;

@property (assign, nonatomic) BOOL checkForground;
@property (nonatomic, strong) NSString *timestampStr;
@property (nonatomic, strong) NSString *strTimestamp;
@property (nonatomic, strong)NSString *zChatId;
@property (nonatomic, strong)NSString *senderId;
@property (nonatomic, strong)NSString *friendStatus;
@property (nonatomic, retain)NSString *chatDetailType;
@property (nonatomic, retain)NSString *checkPublicPrivateStatus;
@property (nonatomic, retain)NSString *addressContactId;
@property (strong, nonatomic) NSString *addressContactName;
@property (strong, nonatomic) NSString *checkaddressContact;


@property(nonatomic)sqlite3 *database; 
@property (nonatomic,strong) Facebook *facebook;
//@property(nonatomic, strong) id<GAITracker> tracker;


+(AppDelegate *)sharedAppDelegate;
-(void)createTabBar;
-(void)removeTabBar;
-(int)netStatus;

-(void)setNavigationBarCustomTitle:(UINavigationItem *)navigationItem naviGationController:(UINavigationController *)tempController NavigationTitle:(NSString *)title;
-(void)registerForNotifications;
-(void)Showtabbar;
-(void)hidetabbar;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

@end
