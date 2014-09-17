//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "Config.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "UserProfileViewController.h"
#import "SearchChatListingViewController.h"
#import "ExistingContactListViewController.h"
#import "GroupCell.h"
#import "AppDelegate.h"
#import "GroupDetailViewController.h"
#import "GroupListViewController.h"
#import "StartGroupViewController.h"
#import "ContactViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AppConstant.h"

@interface DEMOLeftMenuViewController ()<UserProfileViewDelegate,GroupHeaderDelegate,GroupCellDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation DEMOLeftMenuViewController

@synthesize groupHeader,viewUserProfile;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isArrowOpen=YES;
    self.viewUserProfile=({
        
        UserProfileView *view=[[UserProfileView alloc] init];
        view.delegate=self;
        CGRect frmae=view.frame;
        frmae.origin.x=0;
        frmae.origin.y=20;
        view.frame=frmae;
        view;
        
    });
    [self.view addSubview:self.viewUserProfile];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdatedNotification) name:AC_USER_PROFILE_UPDATED_SUCCESSFULLY object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUpdatedNotification) name:AC_USER_Notification_UPDATED_SUCCESSFULLY object:nil];

     
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        
        self.viewUserProfile.profileName.text=gUserName;
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,gUserImage]];
        NSData *imageData=[NSData dataWithContentsOfURL:url];
        self.viewUserProfile.profileImage.image=nil;
        self.viewUserProfile.profileImage.image=[UIImage imageWithData:imageData];
        self.viewUserProfile.profileImage.layer.cornerRadius =35.0;
        self.viewUserProfile.profileImage.clipsToBounds = YES;
        self.viewUserProfile.profileImage.layer.borderWidth=4.0;
        self.viewUserProfile.profileImage.layer.borderColor=[UIColor colorWithRed:143.0/255.0 green:129.0/255.0 blue:154.0/255.0 alpha:1.0].CGColor;
        
    });
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    
}
-(void)notificationUpdatedNotification
{
    [self.tableView reloadData];

}
-(void)profileUpdatedNotification
{
    self.viewUserProfile.profileName.text=gUserName;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,gUserImage]];
    NSData *imageData=[NSData dataWithContentsOfURL:url];
    self.viewUserProfile.profileImage.image=nil;
    self.viewUserProfile.profileImage.image=[UIImage imageWithData:imageData];
    self.viewUserProfile.profileImage.layer.cornerRadius =35.0;
    self.viewUserProfile.profileImage.clipsToBounds = YES;
    self.viewUserProfile.profileImage.layer.borderWidth=4.0;
    self.viewUserProfile.profileImage.layer.borderColor=[UIColor colorWithRed:143.0/255.0 green:129.0/255.0 blue:154.0/255.0 alpha:1.0].CGColor;
    
}
-(void)createAlertView
{
    alertBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [alertBackView setBackgroundColor:[UIColor blackColor]];
    [alertBackView setAlpha:0.5];
    [self.view addSubview:alertBackView];
    
    imgAlertView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 200, 200, 150)];
    [imgAlertView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:imgAlertView];
    
    imgAlertView.layer.cornerRadius =5;
    imgAlertView.clipsToBounds = YES;
    
    [imgAlertView setUserInteractionEnabled:TRUE];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 50)];
    [lbl setText:@"Do you want to logout?"];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    lbl.numberOfLines=2;
    [lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [imgAlertView  addSubview:lbl];
    
    btnOk=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk setFrame:CGRectMake(20, 90, 70, 45)];
    [btnOk addTarget:self action:@selector(btnOKPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [btnOk setTitle:@"YES" forState:UIControlStateNormal];
    [btnOk.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgAlertView addSubview:btnOk];
    
    btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setFrame:CGRectMake(110, 90, 70, 45)];
    [btnCancel addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"cancel_btn"] forState:UIControlStateNormal];
    [btnCancel setTitle:@"NO" forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgAlertView addSubview:btnCancel];
    
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HelpViewController *help;
   // ExistingContactListViewController *existingContact;
    ContactViewController *existingContact;
    NSLog(@"Sction  %d",indexPath.section);
    if (indexPath.section==0)
    {
       
        
    }
    else if (indexPath.section==1)
    {
        
        switch (indexPath.row)
        {
              
            case 0:
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SearchChatListingViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
                
            case 1:
                
                existingContact=[[ContactViewController alloc] init];
               // existingContact.checkView=@"contact";
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:existingContact]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            
            case 2:
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                
                break;
                
            case 3:
                
                help=[[HelpViewController alloc] init];
                help.urlStr=@"http://wellconnected.ehealthme.com/help";
                help.titleStr=@"Help";
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:help]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
                
             case 4:
                
               /* [[NSNotificationCenter defaultCenter] removeObserver:self];
                
                gUserName=@"";
                
                NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
                NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
                
                
                [plist_dict setObject:@"" forKey:@"loginusernane"];
                [plist_dict setObject:@"" forKey:@"loginpassword"];
                [plist_dict setObject:@"no" forKey:@"keepmelogin"];
                [plist_dict writeToFile:plistPath atomically:YES];
                
                [[AppDelegate sharedAppDelegate] removeTabBar];*/
                
                [self createAlertView];
                
                
                break;
            default:
                break;
        }
    }
    else
    {
        
    }
    
    
}
-(IBAction)btnOKPressed:(id)sender
{
    if (service==nil) {
        
        service=[[ConstantLineServices alloc] init];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service LogOutInvocation:gUserId deviceToken:gDeviceToken delegate:self];
}
-(IBAction)btnCancelPressed:(id)sender
{
    [alertBackView removeFromSuperview];
    [imgAlertView removeFromSuperview];
}
-(void)userProfileDidClick:(UIButton *)sender {
    
    
    UserProfileViewController *obj= [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    obj.userId=gUserId;
    obj.navTitle=gUserName;
    obj.checkBackButton=@"Menu";

    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:obj]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

#pragma mark- GroupCellDelegate

-(void)buttonDidClick:(UIButton *)sender{
    
    switch (sender.tag)
    {
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[GroupViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        break;
            
        case 2:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[GroupListViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        break;
        
        case 3:
            
            gCheckStartGroup=@"Menu";
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[StartGroupViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        break;
            
        default:
            break;
    }
}

#pragma mark- GroupHeaderDelegate

-(void)arrowButtonDidClick:(UIButton *)sender {
    
    NSLog(@"Sender : %d" ,sender.isSelected);
    if (sender.isSelected)
    {
        isArrowOpen=NO;
    }
    else
    {
        isArrowOpen=YES;
    }
    [self.tableView reloadData];
}
-(void)groupButtonDidClick:(UIButton *)sender
{
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[GroupViewController alloc] init]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section==0)
    {
        if (self.groupHeader==nil)
        {
            self.groupHeader=({
                
                GroupHeader *view=[[GroupHeader alloc] init];
                view.delegate=self;
                view;
            });
        }
        return self.groupHeader;
    }
    else
    {
        return nil;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section==0)
    {
         return 45;
    }
    else
    {
         return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    
    if (sectionIndex==0)
    {
        if (isArrowOpen)
        {
          return 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0)
    {
        return 100;
    }
    else
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone){
            
            return 45;
        }
        else
        {
            return 35;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isDragging==YES) {
        
        isArrowOpen=NO;

    }
    
    if (indexPath.section==0)
    {
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupIdentifier"];
        if (cell==nil)
        {
            NSArray *customCells = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
            cell = [customCells objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.delegate=self;
        }
        if ([AppDelegate sharedAppDelegate].groupChatNotificationCount>0) {
            
            [cell.imgNotification setHidden:FALSE];
            [cell.lblNotification setHidden:FALSE];
            
            [cell.lblNotification setText:[NSString stringWithFormat:@"%d",[[AppDelegate sharedAppDelegate] groupChatNotificationCount]]];
            
        }
        else
        {
            [cell.imgNotification setHidden:TRUE];
            [cell.lblNotification setHidden:TRUE];
            
        }

        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       
        cell=nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            
           
            if (indexPath.row==0 || indexPath.row==1) {
                
                imgNotification=[[UIImageView alloc] init];
                [imgNotification setImage:[UIImage imageNamed:@"NotificationCount.png"]];
                [imgNotification setUserInteractionEnabled:TRUE];
                [imgNotification setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:imgNotification];
                
                
                lblNotification=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
                [lblNotification setTextColor:[UIColor whiteColor]];
                [lblNotification setBackgroundColor:[UIColor clearColor]];
                [lblNotification setText:@"10"];
                [lblNotification setFont:[UIFont systemFontOfSize:10]];
                [lblNotification setTextAlignment:NSTextAlignmentCenter];
                [imgNotification addSubview:lblNotification];
                
                if (indexPath.row==0) {
                    
                    [imgNotification setFrame:CGRectMake(110, 10, 25, 25)];
                    
                    if ([AppDelegate sharedAppDelegate].chatNotificationCount>0) {
                        
                        [imgNotification setHidden:FALSE];
                        [lblNotification setText:[NSString stringWithFormat:@"%d",[[AppDelegate sharedAppDelegate] chatNotificationCount]]];

                    }
                    else
                    {
                        [imgNotification setHidden:TRUE];
                    }
                }
                else if(indexPath.row==1)
                {
                    [imgNotification setFrame:CGRectMake(140, 10, 25, 25)];
                    
                    if ([AppDelegate sharedAppDelegate].contactNotificationCount>0) {
                        
                        [imgNotification setHidden:FALSE];
                        [lblNotification setText:[NSString stringWithFormat:@"%d",[[AppDelegate sharedAppDelegate] contactNotificationCount]]];
                        
                    }
                    else
                    {
                        [imgNotification setHidden:TRUE];
                    }

                }
                
            }
           
                
            
            
            NSArray *titles = @[@"Chats", @"Contacts", @"Settings", @" Help", @"Logout"];
            NSArray *images = @[@"chat_icon.png", @"contact_icon.png", @"setting_icon.png", @"hepl_icon.png", @"logout_icon.png"];
            cell.textLabel.text = titles[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
        }
        return cell;
    }
    
    
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
    [alertBackView removeFromSuperview];
    [imgAlertView removeFromSuperview];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}



@end
