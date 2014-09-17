//
//  SettingViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "UserProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "AboutUsViewController.h"
#import "MBProgressHUD.h"
#import "BlockContactListViewController.h"
#import "GroupListViewController.h"
#import "HelpViewController.h"
#import "UserProfileViewController.h"

//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"

@implementation SettingViewController

@synthesize tblView,revenueStr,notificationStatus;

@synthesize arrSettingList=_arrSettingList;
@synthesize arrSettingImageList=_arrSettingImageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //self.screenName = @"Settings";
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Settings"];
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    self.arrSettingImageList=[[NSMutableArray alloc] init];
    self.arrSettingList=[[NSMutableArray alloc] init];
    navigation=self.navigationController.navigationBar;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton setFrame:CGRectMake(0,0, 25,29)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=left;
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![gUserId isEqualToString:@""]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            service=[[ConstantLineServices alloc] init];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service UnpaidRevenueInvocation:gUserId delegate:self];
            
        }
        
    }
}
/*- (void)dispatch {
    
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                            action:@"buttonPress"
                                             label:@"dispatch"
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
}*/

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[AppDelegate sharedAppDelegate] Showtabbar];
    
   /* id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"Settings" value:@"Stopwatch"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self dispatch];*/
    
    
}

-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)notificationSwitchPressed:(UISwitch *)sender
{
    if (self.notificationStatus)
    {
        self.notificationStatus=NO;
    }
    else
    {
        self.notificationStatus=YES;
    }
    //[self.tblView reloadData];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service NotificationSettingInvocation:gUserId notificationStatus:[NSString stringWithFormat:@"%d",self.notificationStatus] delegate:self];
    
}
#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrSettingList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 67.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier=@"Cell";
    cell = (SettingTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (Nil == cell)
    {
        cell = [SettingTableViewCell createTextRowWithOwner:self withDelegate:self];
        [cell.notificationSwitch addTarget:self action:@selector(notificationSwitchPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.lblName.text= [self.arrSettingList objectAtIndex:indexPath.row];
    
    NSString *imageName=[self.arrSettingImageList objectAtIndex:indexPath.row];
    [cell.imgView setImage:[UIImage imageNamed:imageName]];
    
    if (indexPath.row==0 || indexPath.row==1 || indexPath.row==2 || indexPath.row==3)
    {
        [cell.imgArrow setHidden:NO];
        [cell.notificationSwitch setHidden:YES];
    }
    else
    {
        [cell.imgArrow setHidden:YES];
        [cell.notificationSwitch setOn:self.notificationStatus];
        [cell.notificationSwitch setHidden:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.revenueStr isEqualToString:@""] || [self.revenueStr isEqualToString:@"0"])
    {
        if (indexPath.row==0)
        {
            objUserProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            objUserProfileViewController.userId=gUserId;
            objUserProfileViewController.navTitle=gUserName;
            objUserProfileViewController.checkBackButton=@"Setting";
            [self.navigationController pushViewController:objUserProfileViewController animated:YES];
        }
        else if(indexPath.row==1)
        {
            BlockContactListViewController *objBlockList;
            objBlockList=[[BlockContactListViewController alloc] initWithNibName:@"BlockContactListViewController" bundle:nil];
            [self.navigationController pushViewController:objBlockList animated:YES];
            [objBlockList release];

        }
        else if(indexPath.row==2)
        {
            ChangePasswordViewController *objChangePasswordViewController;
            objChangePasswordViewController=[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            [self.navigationController pushViewController:objChangePasswordViewController animated:YES];
            [objChangePasswordViewController release];

        }
        else if(indexPath.row==3)
        {
            AboutUsViewController *objAboutUsViewController;
            objAboutUsViewController=[[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:objAboutUsViewController animated:YES];
            [objAboutUsViewController release];
        }
    }
    else
    {
        if (indexPath.row==0)
        {
            objUserProfileViewController=[[UserProfileViewController alloc] init];
            objUserProfileViewController.userId=gUserId;
            [self.navigationController pushViewController:objUserProfileViewController animated:YES];
           
        }
        else if(indexPath.row==1)
        {
            BlockContactListViewController *objBlockList;
            objBlockList=[[BlockContactListViewController alloc] initWithNibName:@"BlockContactListViewController" bundle:nil];
            [self.navigationController pushViewController:objBlockList animated:YES];
            [objBlockList release];

           
        }
        else if(indexPath.row==2)
        {
            
            ChangePasswordViewController *objChangePasswordViewController;
            objChangePasswordViewController=[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            [self.navigationController pushViewController:objChangePasswordViewController animated:YES];
            [objChangePasswordViewController release];
            
           
        }
        else if(indexPath.row==3)
        {
            AboutUsViewController *objAboutUsViewController;
            objAboutUsViewController=[[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:objAboutUsViewController animated:YES];
            [objAboutUsViewController release];

        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==logoutAlert)
    {
        
        if (buttonIndex==1) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service LogOutInvocation:gUserId deviceToken:gDeviceToken delegate:self];
            }
        }
    }
    else if(alertView==clearMessageAlert)
    {
        if (buttonIndex==1)
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [service ClearAllMessageInvocation:gUserId delegate:self];
            }
        }
    }
}

#pragma -----------
#pragma webservice delegate

-(void)UnpaidRevenueInvocationDidFinish:(UnpaidRevenueInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSDictionary *responsedic=[result objectForKey:@"response"];
    
    self.revenueStr=[NSString stringWithFormat:@"%@",[responsedic objectForKey:@"unpaidAmount"]];
    
    if ([[responsedic objectForKey:@"notificationStatus"] isEqualToString:@"0"])
    {
        self.notificationStatus=NO;
    }
    else
    {
        self.notificationStatus=YES;
    }
    
    
    [self.arrSettingList removeAllObjects];
    [self.arrSettingImageList removeAllObjects];
    
    if ([revenueStr isEqualToString:@"0"] || [self.revenueStr isEqualToString:@""])
    {
        
        [self.arrSettingList addObject:@"My Profile"];
        [self.arrSettingList addObject:@"Block Contact List"];
        [self.arrSettingList addObject:@"Change Password"];
        [self.arrSettingList addObject:@"About Us"];
        [self.arrSettingList addObject:@"Enable Notification"];
        
        [self.arrSettingImageList addObject:@"about_us_icon.png"];
        [self.arrSettingImageList addObject:@"block_content_icon.png"];
        [self.arrSettingImageList addObject:@"change_pass_icon.png"];
        [self.arrSettingImageList addObject:@"about_us_icon.png"];
        [self.arrSettingImageList addObject:@"notification_icon.png"];
    }
    else
    {
        [self.arrSettingList addObject:@"My Profile"];
        [self.arrSettingList addObject:@"Block Contact List"];
        [self.arrSettingList addObject:@"Change Password"];
        [self.arrSettingList addObject:@"About Us"];
        [self.arrSettingList addObject:@"Enable Notification"];
        
        [self.arrSettingImageList addObject:@"about_us_icon.png"];
        [self.arrSettingImageList addObject:@"block_content_icon.png"];
        [self.arrSettingImageList addObject:@"change_pass_icon.png"];
        [self.arrSettingImageList addObject:@"about_us_icon.png"];
        [self.arrSettingImageList addObject:@"notification_icon.png"];
    }
    
    [tblView reloadData];
    moveTabG=FALSE;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)LogOutInvocationDidFinish:(LogOutInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else {
        
        NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat"];
        NSLog(@"%@",sqlStatement);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
        }
        
        NSString *sqlStatement1=[NSString stringWithFormat:@"delete from tbl_chatUser"];
        NSLog(@"%@",sqlStatement1);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement1 cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
            
        }
        
        //  [[[[AppDelegate sharedAppDelegate].window subviews] objectAtIndex:0] removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        gUserName=@"";
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
        NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
        
        
        [plist_dict setObject:@"" forKey:@"loginusernane"];
        [plist_dict setObject:@"" forKey:@"loginpassword"];
        [plist_dict setObject:@"no" forKey:@"keepmelogin"];
        [plist_dict writeToFile:plistPath atomically:YES];
        
        [[AppDelegate sharedAppDelegate] removeTabBar];
        
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)ClearAllMessageInvocationDidFinish:(ClearAllMessageInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else {
        
        // NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat"];
        
        NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat where MsgUserId= NOT IN ('%@') and GroupId='%@'" ,@"1",@"0"];
        
        
        NSLog(@"%@",sqlStatement);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"All messages has been deleted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            [alert show];
            [alert release];
            
        }
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)NotificationSettingInvocationDidFinish:(NotificationSettingInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    service=nil;
}
- (void)viewDidUnload
{
    _arrSettingImageList=nil;
    _arrSettingList=nil;
    self.revenueStr=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrSettingImageList release];
    [_arrSettingList release];
    self.revenueStr=nil;
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
