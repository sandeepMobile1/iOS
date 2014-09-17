//
//  AppDelegate.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import "AppConstant.h"
#import "Reachability.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "QSStrings.h"
#import <CFNetwork/CFNetwork.h>
#import "ExistingContactListViewController.h"
#import "PhoneContactsViewController.h"
#import "RecomondedFriendsViewController.h"
#import "FirstViewController.h"
#import "DEMOLeftMenuViewController.h"

//static NSString* kAppId = @"833209056698618";
static NSString* kAppId = @"639892319392066";

//static NSString *const kTrackingId = @"UA-2939081-3";

//static NSString *const kTrackingId = @"UA-47676352-1";
//static NSString *const kAllowTracking = @"allowTracking";

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController,navigationController,checkForground;
@synthesize navigationClassReference,_appIsInbackground,appType,totalNotificationCount,viewToolBarBase;
@synthesize objLoginViewController,objRegistrationViewController,objContactViewController,objSettingViewController,rememberTag,email,password,nameCardId,checkNameCard,chatNotificationCount,contactNotificationCount,groupChatNotificationCount,selectedMembers,arrSelectedContactList,nameCardName,nameCardImage,timestampStr,database,attachement,attachementimg,senderimgData,strTimestamp,zChatId,senderId,friendStatus,chatDetailType,splitViewController,objGroupViewController,checkPublicPrivateStatus,addressContactId,addressContactName,checkaddressContact,facebook,objFirstViewController,appRateCounter;

@synthesize dataMsg;
@synthesize strsenderImage;

#define kRemoteNotificationReceivedNotification @"RemoteNotificationReceivedWhileRunning"
#define kRemoteNotificationBackgroundNotification @"RemoteNotificationReceivedWhileBackground"
#define kRemoteNotificationForgroundNotification @"RemoteNotificationReceivedWhileForgroud"
#define kRemoteNotificationLoginNotification @"RemoteNotificationReceivedWhileLogin"
#define kRemoteNotificationLoginProgressViewNotification @"RemoteNotificationReceivedWhileLoginProgress"
#define kRemoteNotificationLoginErrorNotification @"RemoteNotificationReceivedError"


#define kShowAlertKey @"ShowAlert"
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    moveTabG=FALSE;
    //[GAI sharedInstance].optOut =
    //![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    
    
    NSString *rootPath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath1 = [rootPath1 stringByAppendingPathComponent:@"plistCheckRatingData.plist"];
    NSMutableDictionary *plist_dict1 = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath1];
    
    NSString *rateCounter=[plist_dict1 valueForKey:@"rateCounter"];
    NSString *rateStatus=[plist_dict1 valueForKey:@"rateStatus"];
    
    NSLog(@"rateCounter %@",rateCounter);
    NSLog(@"rateStatus %@",rateStatus);
    
    if (rateCounter==nil || rateCounter==(NSString*)[NSNull null] || [rateCounter isEqualToString:@""]) {
        
        appRateCounter=0;
        rateStatus=@"";
    }
    else
    {
        appRateCounter=[rateCounter intValue];
    }
    
    if ([rateStatus isEqualToString:@"NO"] || [rateStatus isEqualToString:@""]) {
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistCheckRatingData.plist"];
        NSMutableDictionary *plist_dict = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        
        if(plist_dict == nil)
        {
            plist_dict = [[NSMutableDictionary alloc] init];
        }
        
        if (appRateCounter>=5) {
            
            appRateCounter=0;
        }
        
        NSString *rateCounterStr=[NSString stringWithFormat:@"%d",appRateCounter+1];
        
        [plist_dict setObject:[NSString stringWithFormat:@"%@",rateCounterStr] forKey:@"rateCounter"];
        [plist_dict setObject:[NSString stringWithFormat:@"%@",@"NO"]forKey:@"rateStatus"];
        
        [plist_dict writeToFile:plistPath atomically:YES];
        
        if ([rateCounterStr isEqualToString:@"5"]) {
            
            appRateAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Rate the App !" delegate:self cancelButtonTitle:@"Rate Later" otherButtonTitles:@"Rate Now", nil];
            [appRateAlert show];
        }
    }
    
    
    
    
    NSLog(@"applicationDidBecomeActive");
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"didFinishLaunchingWithOptions");
    
    [self registerForNotifications];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    [NSThread sleepForTimeInterval:2];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
	[self copyDatabaseIfNeeded];
    
    if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
    }
    
    
    self.checkForground=TRUE;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {          // iPhone and iPod touch style UI
        
        self.appType=kDeviceTypeiPhone;
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
        {          // iPhone and iPod touch style UI
            
            self.appType=kDeviceTypeTalliPhone;
        }
    }
    else
    {
        self.appType=kDeviceTypeiPad;
    }
    
    
    queue = [NSOperationQueue new];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    /* NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
     
     [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
     [GAI sharedInstance].optOut =
     ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
     
     [GAI sharedInstance].dispatchInterval = 120;
     
     [GAI sharedInstance].trackUncaughtExceptions = YES;
     self.tracker = [[GAI sharedInstance] trackerWithName:@"WellConnected"
     trackingId:kTrackingId];*/
    
    
    objLoginViewController=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    self.facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:objLoginViewController];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
    NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    
    
    [plist_dict setObject:@"" forKey:@"loginusernane"];
    [plist_dict setObject:@"" forKey:@"loginpassword"];
    [plist_dict setObject:@"no" forKey:@"keepmelogin"];
    [plist_dict writeToFile:plistPath atomically:YES];
    
    
    /*if ([[plist_dict valueForKey:@"keepmelogin"]isEqualToString:@"yes"]) {
     
     self.navigationController=[[[UINavigationController alloc] initWithRootViewController:objLoginViewController]autorelease];
     [self.window setRootViewController:self.navigationController];
     }
     else
     {*/
    objFirstViewController=[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    self.navigationController=[[[UINavigationController alloc] initWithRootViewController:objFirstViewController]autorelease];
    [self.window setRootViewController:self.navigationController];
    // }
    
    
    
    return YES;
}

- (void) copyDatabaseIfNeeded {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
    NSLog(@"%@",dbPath);
    
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	if(!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}


-(int)netStatus
{
	int variable;
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Internet Connection is not availaible" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
        [alert release];
		variable=1;
	}
	else {
		variable=0;
		
    }
	return variable;
}

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(void)hidetabbar
{
    checkTabbar=FALSE;
    /*[UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:0.5];
     
     int x_pos;
     if (self.appType==kDeviceTypeTalliPhone)
     {
     
     //x_pos = 567;
     
     x_pos = 575;
     }
     else
     {
     x_pos = 480;
     }
     // [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@""]];
     
     
     for(UIView *view in tabBarController.view.subviews)
     {
     if([view isKindOfClass:[UITabBar class]])
     {
     [view setFrame:CGRectMake(view.frame.origin.x, x_pos, view.frame.size.width, view.frame.size.height)];
     }
     else
     {
     [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, x_pos)];
     }
     }
     [UIView commitAnimations];*/
    
}
-(void)Showtabbar
{
    /*//[self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_toolbar_bg"]];
     
     UITabBar *tabBar = self.tabBarController.tabBar;
     UIView *parent = tabBar.superview; // UILayoutContainerView
     UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
     UIView *window = parent.superview;
     
     [UIView animateWithDuration:0.5
     animations:^{
     CGRect tabFrame = tabBar.frame;
     tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame)+12;
     tabBar.frame = tabFrame;
     
     CGRect contentFrame = content.frame;
     contentFrame.size.height -= tabFrame.size.height;
     }];*/
}

-(void)createTabBar {
    
    checkTabbar=TRUE;
    
    self.objGroupViewController=[[GroupViewController alloc] init];
    UINavigationController *navigationGroupViewController=[[[UINavigationController alloc] initWithRootViewController:self.objGroupViewController] autorelease];
    
    DEMOLeftMenuViewController *leftMenuViewController = [[DEMOLeftMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationGroupViewController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    [sideMenuViewController setBackgroundImage:[UIImage imageNamed:@"bg"]];
    //sideMenuViewController.backgroundImage = [UIImage imageNamed:@"bg"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor =[UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    //self.window.backgroundColor = [UIColor whiteColor];
}
-(void)removeTabBar
{
    gUserId=@"";
    [self.viewToolBarBase removeFromSuperview];
    objFirstViewController=[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    self.navigationController=[[[UINavigationController alloc] initWithRootViewController:objFirstViewController]autorelease];
    [self.window setRootViewController:self.navigationController];
    [self.facebook logout:self];
    
}
- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}

-(void)setNavigationBarCustomTitle:(UINavigationItem *)navigationItem naviGationController:(UINavigationController *)tempController NavigationTitle:(NSString *)title{
    
    UILabel *navLabel ;
    
    navLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)] autorelease];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.text=title;
    navLabel.textColor = [UIColor whiteColor];
    navLabel.font = [UIFont fontWithName:ARIALFONT_BOLD size:23.0];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navigationItem.titleView = navLabel;
    
    
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    [self.navigationClassReference popToRootViewControllerAnimated:NO];
    
    if (moveTabG==FALSE) {
        
        if ([gUserId isEqualToString:@""]) {
            
            exitAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Please login first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [exitAlert show];
            [exitAlert release];
            // return NO;
        }
        else
        {
            return YES;
        }
        return YES;
    }
    else{
        return NO;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==exitAlert) {
        
        [[AppDelegate sharedAppDelegate] removeTabBar];
    }
    if (alertView==appRateAlert) {
        
        if (buttonIndex==1) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8"]];
            
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistCheckRatingData.plist"];
            NSMutableDictionary *plist_dict = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
            
            if(plist_dict == nil)
            {
                plist_dict = [[NSMutableDictionary alloc] init];
            }
            
            if (appRateCounter>=5) {
                
                appRateCounter=0;
            }
            
            NSString *rateCounterStr=[NSString stringWithFormat:@"%d",appRateCounter+1];
            
            [plist_dict setObject:[NSString stringWithFormat:@"%@",rateCounterStr] forKey:@"rateCounter"];
            [plist_dict setObject:[NSString stringWithFormat:@"%@",@"YES"]forKey:@"rateStatus"];
            
            [plist_dict writeToFile:plistPath atomically:YES];
        }
    }
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

#pragma mark -
#pragma mark Remote notifications

-(void)registerForNotifications {
	
	UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
	NSString *devicetocken=[NSString stringWithFormat:@"%@",deviceToken];
	NSString *tkenstr1=[NSString stringWithString:[devicetocken substringFromIndex:1]];
	NSInteger imgstr=[tkenstr1 length]-1;
	NSString *tokenstr=[NSString stringWithString:[tkenstr1 substringToIndex:imgstr]];
	tokenstr = [tokenstr stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    tokenstr = [NSString stringWithFormat:@"%@",tokenstr];
    
    tokenstr = [tokenstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenstr = [tokenstr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenstr = [tokenstr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
	gDeviceToken=[tokenstr retain];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistDeviceTokenData.plist"];
    NSMutableDictionary *plist_dict = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    
    if(plist_dict == nil)
    {
        plist_dict = [[NSMutableDictionary alloc] init];
    }
    
    [plist_dict setObject:[NSString stringWithFormat:@"%@",gDeviceToken] forKey:@"device_token"];
    
    [plist_dict writeToFile:plistPath atomically:YES];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
	NSLog(@"Error in registration. Error: %@", error);
	
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
	if ( application.applicationState == UIApplicationStateActive )
	{
		NSDictionary* notifUserInfo = Nil;
		
		if (!_appIsInbackground) {
			
			NSLog(@"notappIsInbackground");
            
        }
		else
        {
			NSLog(@"_appIsInbackground");
		}
		NSArray *notifArray = [NSArray arrayWithObject:kShowAlertKey];
        notifUserInfo = [[[NSDictionary alloc] initWithObjects:notifArray forKeys:notifArray] autorelease];
        
        NSDictionary *temp_=[userInfo valueForKey:@"aps"];
        
        NSString *totalCount=[temp_ valueForKey:@"totalCount"];
        NSString *chatCount=[temp_ valueForKey:@"chatCount"];
        NSString *contactCount=[temp_ valueForKey:@"contactCount"];
        NSString *groupCount=[temp_ valueForKey:@"groupCount"];
        
        NSString *nType=[temp_ valueForKey:@"type"];
        NSString *nMessage=[temp_ valueForKey:@"alert"];
        
        if ([nType isEqualToString:@"alert"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:nMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        
        self.totalNotificationCount=[totalCount intValue];
        self.chatNotificationCount=[chatCount intValue];
        self.contactNotificationCount=[contactCount intValue];
        self.groupChatNotificationCount=[groupCount intValue];
        
        if (self.chatNotificationCount>0) {
            
            UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
            tabBarItem.badgeValue =[NSString stringWithFormat:@"%d",self.chatNotificationCount];
        }
        else{
            
            [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
            
        }
        if (self.contactNotificationCount>0) {
            
            UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:2];
            tabBarItem.badgeValue =[NSString stringWithFormat:@"%d",self.contactNotificationCount];
        }
        else{
            
            [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
            
        }
        if (self.groupChatNotificationCount>0) {
            
            UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
            tabBarItem.badgeValue =[NSString stringWithFormat:@"%d",self.groupChatNotificationCount];
        }
        else{
            
            [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_Notification_UPDATED_SUCCESSFULLY object:nil];
        
		NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationReceivedNotification object:userInfo userInfo:notifUserInfo];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        
		
	}
    
   	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSLog(@"applicationDidEnterBackground");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    
    
    moveTabG=FALSE;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        
        if (service==nil) {
            
            service=[[ConstantLineServices alloc] init];
        }
        [service ResetBedgeInvocation:gUserId delegate:self];
        
    }
    
}
-(void)ResetBedgeInvocationDidFinish:(ResetBedgeInvocation*)invocation
                         withResults:(NSString*)result
                        withMessages:(NSString*)msg
                           withError:(NSError*)error
{
    NSLog(@"%@",result);
    
    NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationForgroundNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    
}
#pragma mark Delegate
#pragma mark SplitViewController

- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    NSDictionary *dict = [self parseQueryString:[url query]];
    
    NSLog(@"%@",dict);
    
    return YES;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"createTabBar %@",url);
    
    
    NSString *myString = [url absoluteString];
    
    if (myString.length>16) {
        
        NSString *groupCode = [myString substringFromIndex:16];
        
        NSLog(@"%@",groupCode);
        
        if (groupCode.length>0) {
            
            urlSchemeSearchText=[groupCode retain];
            
        }
        
    }
    
    
    //  if (![gUserId isEqualToString:@""]) {
    
    [self createTabBar];
    self.tabBarController.selectedIndex=0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //  }
    
    
    if ([sourceApplication isEqualToString:@"com.ehealthme.wellconnected"])
    {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        
        return YES;
    }
    else
        return NO;
}

- (void)dealloc
{
    [_window release];
    
    [super dealloc];
}



@end

