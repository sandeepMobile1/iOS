//
//  GroupViewController.m
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import "GroupViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "ChatListData.h"
#import "MBProgressHUD.h"
#import "StartGroupViewController.h"
#import "GroupInfoViewController.h"
#import "FinsGroupViewController.h"
#import "QSStrings.h"
#import "GroupListViewController.h"
#import "ChatViewController.h"
#import "HelpViewController.h"
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
#import <Twitter/Twitter.h>

static NSString* kAppId = @"639892319392066";

@interface GroupViewController ()


@end

@implementation GroupViewController

@synthesize tblView;

@synthesize arrChatList=_arrChatList;
@synthesize arrSearchGroupList=_arrSearchGroupList;
@synthesize searchString,page,totalRecord,actionSheetView,shareGroupCode,shareGroupName,shareGroupImage;

@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize posting = _posting;
@synthesize fbUserDetails,FBUserID,FBUserName, FBToken,facebook;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
       // self.screenName = @"Groups";

    
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [imgBottomView setAlpha:0.9];
    
    [lblNoResult setHidden:TRUE];
    [btnNoResult setHidden:TRUE];
    
    imgSearchView.layer.cornerRadius =5;
    imgSearchView.clipsToBounds = YES;
    
    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep.png"]]];

    
    [self.tblView setContentSize:CGSizeMake(0, 44)];
    
    
    if (self.arrChatList==nil) {
        
        self.arrChatList=[[NSMutableArray alloc] init];
    }
    if (self.arrSearchGroupList==nil) {
        
        self.arrSearchGroupList=[[NSMutableArray alloc] init];
    }
    
    self.searchString=@"";

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveForgroundNotification:) name:@"RemoteNotificationReceivedWhileForgroud" object:Nil];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"My Groups"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignKeyBoard) name:AC_USER_Notification_Resign_Keyboard object:nil];
    
    
    UIButton *startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"New" forState:UIControlStateNormal];
    [startButton setFrame:CGRectMake(0,8, 45,29)];
    [startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];

    [startButton addTarget:self action:@selector(stratGroupPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIView *startButtonView=[[[UIView alloc] initWithFrame:CGRectMake(0, 1, 45, 43)]autorelease];
    [startButtonView addSubview:startButton];
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:startButtonView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    if (![gUserId isEqualToString:@""]) {
       
        UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [menuButton setFrame:CGRectMake(0,0, 25,29)];
        [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem=left;

    }
    
    self.page=1;
    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

    // Do any additional setup after loading the view from its nib.
}

-(void)resignKeyBoard
{
    txtSearch.text=@"";
    [txtSearch resignFirstResponder];
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];

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
    [tracker set:@"Groups" value:@"Stopwatch"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self dispatch];*/

    
}
- (void)didReceiveBackgroundNotification:(NSNotification*) note{
	
    if ([checkPN isEqualToString:@"YES"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            NSDictionary* notification = (NSDictionary*)[note object];
            
            NSString* nType = [notification valueForKeyPath:@"aps.type"];
            
            if ([nType isEqualToString:@"groupchat"]) {
                
                moveTabG=TRUE;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                
                checkPaging=FALSE;

                
                [service LatestGroupInvocation:gUserId page:pageStr delegate:self];
            }
            
        }
        
    }
    
	
}
- (void)didReceiveForgroundNotification:(NSNotification*) note
{
    if ([checkPN isEqualToString:@"YES"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            
            checkPaging=FALSE;

            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if (self.searchString==nil || self.searchString==(NSString*)[NSNull null] || [self.searchString isEqualToString:@""]) {
                
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                
                [service LatestGroupInvocation:gUserId page:pageStr delegate:self];
            }
            else
            {
                searchBar.text=self.searchString;
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                NSLog(@"%@",pageStr);
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                
                [service FindGroupInvocation:gUserId searchCriteria:self.searchString pageString:pageStr delegate:self];            }
            
        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    checkPN=@"YES";
    
    searchBar.text=@"";
    
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    objImageCache=[[ImageCache alloc] init];
    objImageCache.delegate=self;
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:202.0/255.0  blue:211.0/255.0 alpha:0.9];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:49.0/255.0 green:202.0/255.0  blue:211.0/255.0 alpha:0.9];
    }
    [self.tblView setContentOffset:CGPointMake(0, 0)];
    tblView.delegate=self;
    tblView.dataSource=self;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 450)];
            
            [searchView setFrame:CGRectMake(0, 0, 320, 568)];
            
        }
        else
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 450-IPHONE_FIVE_FACTOR)];
            
            [searchView setFrame:CGRectMake(0, 0, 320, 568-IPHONE_FIVE_FACTOR)];

        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 370+IPHONE_FIVE_FACTOR)];
            
            [searchView setFrame:CGRectMake(0, 0, 320, 480+IPHONE_FIVE_FACTOR)];

            
            
        }
        else
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 370)];
            
            [searchView setFrame:CGRectMake(0, 0, 320, 480)];

            
        }
        
    }

    
    if (service==nil) {
        
        service=[[ConstantLineServices alloc] init];
    }
    
    if (urlSchemeSearchText==nil || urlSchemeSearchText==(NSString*)[NSNull null] ||[urlSchemeSearchText isEqualToString:@""]) {
        
    }
    else
    {
        self.searchString=[urlSchemeSearchText retain];
        
    }

    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        
        if (self.searchString==nil || self.searchString==(NSString*)[NSNull null] || [self.searchString isEqualToString:@""]) {
           
            moveTabG=TRUE;

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if (gUserId==nil || gUserId==(NSString*)[NSNull null]) {
                
                gUserId=@"";
            }
           
            self.page=1;
            
            NSString *pageStr=[NSString stringWithFormat:@"%d",page];
            
            checkPaging=FALSE;

            
            [service LatestGroupInvocation:gUserId page:pageStr delegate:self];

        }
        else
        {
            if (urlSchemeSearchText==nil || urlSchemeSearchText==(NSString*)[NSNull null] || [urlSchemeSearchText isEqualToString:@""]) {
                
                searchBar.text=self.searchString;
                [tblView reloadData];
                
                checkPaging=TRUE;
            }
            else
            {
                checkPaging=FALSE;

                self.searchString=urlSchemeSearchText;
                searchBar.text=self.searchString;
                
                [self handleSearchForTerm:searchBar.text];

            }
            
            //[service FindGroupInvocation:gUserId searchCriteria:self.searchString delegate:self];
        }
        
    }
    
}


#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
	
    return ({
        
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        view.image=[UIImage imageNamed:@"sep.png"];
        view.backgroundColor=[UIColor clearColor];
        view;
    });
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int rowCount=0;
    rowCount=[self.arrChatList count];
    return rowCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    //static NSString *unpaidCellIdentifier=@"UnpaidCell";
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",data.paidStatus);
    
  

        cell = (ChatListTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (Nil == cell)
        {
            cell = [ChatListTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSLog(@"%@",data.name);
        cell.lblName.text= data.name;
        cell.lblMessage.text=data.message;
        cell.lblDate.text=data.date;
        cell.lblFee.text=[NSString stringWithFormat:@"Monthly fee: $%@",data.charge];
    
    
    if ([data.groupJoinStatus isEqualToString:@"0"]) {
        
        [cell.btnShare setHidden:FALSE];

    }
    else
    {
        [cell.btnShare setHidden:TRUE];
    }
    
        if ([data.latestStatus isEqualToString:@"1"])
        {
            
            [cell.btnAccept setHidden:TRUE];
            [cell.btnReject setHidden:TRUE];
            [cell.imgStatus setImage:nil];


        }
        else
        {
            if ([data.requestStatus isEqualToString:@"1"])
            {
                [cell.btnAccept setHidden:FALSE];
                [cell.btnReject setHidden:FALSE];
            }
            else
            {
                 if ([data.subscribeStatus isEqualToString:@"0"])
                 {
                    cell.lblMessage.text=@"";
                 }
                
                [cell.btnAccept setHidden:TRUE];
                [cell.btnReject setHidden:TRUE];
            }
            
            if (data.readStatus==nil || data.readStatus==(NSString*)[NSNull null] || [data.readStatus isEqualToString:@""]) {
                
                [cell.imgStatus setImage:nil];

            }
            else
            {
                if ([data.readStatus isEqualToString:@"read"])
                {
                    
                    [cell.imgStatus setImage:nil];
                }
                else
                {
                    [cell.imgStatus setImage:[UIImage imageNamed:@"green.png"]];
                }
            }
           

        }
    
    
    [cell.btnAccept setHidden:TRUE];
    [cell.btnReject setHidden:TRUE];
    
        if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""])
        {
            [cell.imgView setImage:[UIImage imageNamed:@"group_pic.png"]];
        }
        else
        {
            NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.image];
            UIImage *img = [objImageCache iconForUrl:imageUrl];
            if (img == Nil)
            {
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(65, 65);
                }
                else
                {
                    kImgSize_1=CGSizeMake(65*2, 65*2);
                }
                [objImageCache startDownloadForUrl:imageUrl withSize:kImgSize_1 forIndexPath:indexPath];
            }
            else
            {
                [cell.imgView setImage:img];
            }
            
        }
        
        
        return cell;
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([gUserId isEqualToString:@""]) {
        
        exitAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Please login first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [exitAlert show];
        [exitAlert release];

    }
    else
    {
        ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
        
        if ([data.groupJoinStatus isEqualToString:@"1"]) {
            
            if ([data.paidStatus isEqualToString:@"1"]) {
                
                if ([data.subscribeStatus isEqualToString:@"1"]) {
                    
                    int msgCount=[AppDelegate sharedAppDelegate].groupChatNotificationCount-[data.unreadMessageCount intValue];
                    
                    [AppDelegate sharedAppDelegate].groupChatNotificationCount=msgCount;
                    
                    UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
                    tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].groupChatNotificationCount];
                    
                    NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].groupChatNotificationCount);
                    
                    if ([AppDelegate sharedAppDelegate].groupChatNotificationCount==0) {
                        
                        [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
                        
                    }
                    
                    objChatViewController=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                    
                    objChatViewController.friendUserName=data.name;
                    objChatViewController.groupTitle=data.name;

                    if ([data.groupSpecialType isEqualToString:@"0"]) {
                        
                        objChatViewController.groupId=data.userId;
                        
                    }
                    else
                    {
                        /* if ([data.groupParentId isEqualToString:@"0"]) {
                         
                         objChatViewController.groupId=data.userId;
                         
                         }
                         else
                         {
                         objChatViewController.groupId=data.groupParentId;
                         
                         }*/
                        
                        objChatViewController.groupId=data.userId;
                        
                    }
                    
                    objChatViewController.groupType=@"1";
                    objChatViewController.friendId=@"0";
                    
                    NSLog(@"%@",data.zChatId);
                    
                    objChatViewController.threadId=data.zChatId;
                    [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
                    
                    [self.navigationController pushViewController:objChatViewController animated:YES];
                    
                    [objChatViewController release];
                    
                }
                else
                {
                    objGroupInfoViewController=[[GroupInfoViewController alloc] initWithNibName:@"GroupInfoViewController" bundle:nil];
                    
                    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
                    
                    if ([data.groupSpecialType isEqualToString:@"0"]) {
                        
                        objGroupInfoViewController.groupId=data.userId;
                        
                        
                    }
                    else
                    {
                        /*if ([data.groupParentId isEqualToString:@"0"]) {
                         
                         objGroupInfoViewController.groupId=data.userId;
                         
                         
                         }
                         else
                         {
                         objGroupInfoViewController.groupId=data.groupParentId;
                         
                         }*/
                        
                        objGroupInfoViewController.groupId=data.userId;
                        
                    }
                    objGroupInfoViewController.joinStatus=data.groupJoinStatus;
                    
                    [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
                    
                    [self.navigationController pushViewController:objGroupInfoViewController animated:YES];
                    [objGroupInfoViewController release];
                }
                
            }
            else
            {
                int msgCount=[AppDelegate sharedAppDelegate].groupChatNotificationCount-[data.unreadMessageCount intValue];
                
                [AppDelegate sharedAppDelegate].groupChatNotificationCount=msgCount;
                
                UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
                tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].groupChatNotificationCount];
                
                NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].groupChatNotificationCount);
                
                if ([AppDelegate sharedAppDelegate].groupChatNotificationCount==0) {
                    
                    [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
                    
                }
                objChatViewController=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                
                objChatViewController.friendUserName=data.name;
                objChatViewController.groupType=@"1";
                objChatViewController.groupTitle=data.name;

                if ([data.groupSpecialType isEqualToString:@"0"]) {
                    
                    objChatViewController.groupId=data.userId;
                    
                }
                else
                {
                    /*if ([data.groupParentId isEqualToString:@"0"]) {
                     
                     objChatViewController.groupId=data.userId;
                     
                     }
                     else
                     {
                     objChatViewController.groupId=data.groupParentId;
                     
                     }*/
                    
                    objChatViewController.groupId=data.userId;
                    
                }
                objChatViewController.friendId=@"0";
                NSLog(@"%@",data.zChatId);
                
                objChatViewController.threadId=data.zChatId;
                
                [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
                
                [self.navigationController pushViewController:objChatViewController animated:YES];
                
                [objChatViewController release];
                
            }
            
        }
        else
        {
            if (![data.subscribeStatus isEqualToString:@"1"]) {
                
                objGroupInfoViewController=[[GroupInfoViewController alloc] initWithNibName:@"GroupInfoViewController" bundle:nil];
                
                ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
                
                if ([data.groupSpecialType isEqualToString:@"0"]) {
                    
                    objGroupInfoViewController.groupId=data.userId;
                    
                    
                }
                else
                {
                    objGroupInfoViewController.groupId=data.userId;
                    
                   
                }
                objGroupInfoViewController.joinStatus=data.groupJoinStatus;
                
                [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
                
                [self.navigationController pushViewController:objGroupInfoViewController animated:YES];
                [objGroupInfoViewController release];
                
                
            }
            
        }

    }
    
 }

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}
-(void) buttonUnpaidRejectClick:(ChatListUnpaidTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"3" delegate:self];
        }    
}
-(void) buttonRejectClick:(ChatListTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
       
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"3" delegate:self];
    }
    
    
}
-(void) buttonAcceptClick:(ChatListTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    if ([data.latestStatus isEqualToString:@"1"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if ([data.groupSpecialType isEqualToString:@"1"]) {
                
               /* if ([data.groupParentId isEqualToString:@"0"]) {
                    
                    [service SpecialGroupJoinInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];

                }
                else
                {
                    [service SpecialGroupJoinInvocation:gUserId friendId:data.groupOwnerId groupId:data.groupParentId delegate:self];
                    

                }*/
                
                [service SpecialGroupJoinInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];

                
            }
            else
            {
                [service JoinGroupInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];
                
            }
            

            
            
        }

    }
    else
    {
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
                //if ([data.paidStatus isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"2" delegate:self];
                /*}
                 else{
                 
                 objPaypalViewController =[[PaypalViewController alloc] init];
                 objPaypalViewController.userId=gUserId;
                 objPaypalViewController.groupId=data.userId;
                 objPaypalViewController.type=@"2";
                 objPaypalViewController.groupOwnerId=data.groupOwnerId;
                 objPaypalViewController.groupUserTableId=data.groupUserTableId;
                 objPaypalViewController.checkAcceptRequest=@"NO";
                 
                 NSLog(@"%@",data.messasgeId);
                 
                 [self.navigationController pushViewController:objPaypalViewController animated:YES];
                 }*/
                
            }
        
    }
    
    
}
-(void) buttonUnpaidAcceptClick:(ChatListUnpaidTableViewCell*)cellValue
{
    
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    if ([data.latestStatus isEqualToString:@"1"]) {
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           
            if ([data.groupSpecialType isEqualToString:@"1"]) {
                
               /* if ([data.groupParentId isEqualToString:@"0"]) {
                    
                    [service SpecialGroupJoinInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];
                    
                }
                else
                {
                    [service SpecialGroupJoinInvocation:gUserId friendId:data.groupOwnerId groupId:data.groupParentId delegate:self];
                    
                }*/
                
                [service SpecialGroupJoinInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];

                
            }
            else
            {
                [service JoinGroupInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];
                
            }
        }
 
    }
    else
    {
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            
           
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"2" delegate:self];
            }
            
      
    }
    
    
}
-(void) buttonShareClick:(ChatListTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];

    self.shareGroupName=data.name;
    self.shareGroupCode=data.groupCode;
    self.shareGroupImage=data.image;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    self.actionSheetView = actionSheet;
    
    
    UIImageView *background = [[UIImageView alloc] init];
    [background setFrame:CGRectMake(0, 0, 320, 600)];
    [background setBackgroundColor:[UIColor whiteColor]];
    background.contentMode = UIViewContentModeScaleToFill;
    [self.actionSheetView addSubview:background];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 25)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Share"];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:20]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.actionSheetView addSubview:lblTitle];
    
    
    UIButton *ShareAppButton = [UIButton buttonWithType: UIButtonTypeCustom];
    ShareAppButton.frame = CGRectMake(20, 40, 280, 40);
    [ShareAppButton addTarget:self action:@selector(btnShareOnSMSPressed:) forControlEvents:UIControlEventTouchUpInside];
    ShareAppButton.adjustsImageWhenHighlighted = YES;
    [ShareAppButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [ShareAppButton setTitle:@"Share On SMS" forState:UIControlStateNormal];
    [ShareAppButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ShareAppButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShareAppButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionSheetView addSubview: ShareAppButton];
    
    UIButton *ShareFBButton = [UIButton buttonWithType: UIButtonTypeCustom];
    ShareFBButton.frame = CGRectMake(20, 90, 280, 40);
    [ShareFBButton addTarget:self action:@selector(btnShareFBPressed:) forControlEvents:UIControlEventTouchUpInside];
    ShareFBButton.adjustsImageWhenHighlighted = YES;
    [ShareFBButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [ShareFBButton setTitle:@"Share On Facebook" forState:UIControlStateNormal];
    [ShareFBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ShareFBButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShareFBButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionSheetView addSubview: ShareFBButton];
    
    UIButton *ShareTWButton = [UIButton buttonWithType: UIButtonTypeCustom];
    ShareTWButton.frame = CGRectMake(20, 140, 280, 40);
    [ShareTWButton addTarget:self action:@selector(btnShareTWPressed:) forControlEvents:UIControlEventTouchUpInside];
    ShareTWButton.adjustsImageWhenHighlighted = YES;
    [ShareTWButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [ShareTWButton setTitle:@"Share On Twitter" forState:UIControlStateNormal];
    [ShareTWButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ShareTWButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShareTWButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionSheetView addSubview: ShareTWButton];
    
    UIButton *ShareMailButton = [UIButton buttonWithType: UIButtonTypeCustom];
    ShareMailButton.frame = CGRectMake(20, 190, 280, 40);
    [ShareMailButton addTarget:self action:@selector(btnShareMailPressed:) forControlEvents:UIControlEventTouchUpInside];
    ShareMailButton.adjustsImageWhenHighlighted = YES;
    [ShareMailButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [ShareMailButton setTitle:@"Share On Mail" forState:UIControlStateNormal];
    [ShareMailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ShareMailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShareMailButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionSheetView addSubview: ShareMailButton];
    
    UIButton *cancelButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, 245, 280, 40);
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.adjustsImageWhenHighlighted = YES;
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"navi_blue_btn.png"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionSheetView addSubview: cancelButton];
    
    [self.actionSheetView showInView:self.view];
    [self.actionSheetView setBounds:CGRectMake(0,0,320, 600)];

}
-(void)cancelButtonClicked:(id)sender {
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
}
-(IBAction)btnShareOnSMSPressed:(id)sender
{
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
	NSString *mailCurrentLink=@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8";
    
    
    NSString *currentTitleStr=[NSString stringWithFormat:@"I thought you would be interested to join this push-to-talk support group: %@.  First, install app WellConnected: ",self.shareGroupName];
    
    NSString *postData = [NSString stringWithFormat:@"%@. %@ Then, search group #: %@", currentTitleStr,mailCurrentLink,self.shareGroupCode];
    
    NSLog(@"%@",postData);
    
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        
        controller.body = postData;
        controller.recipients = nil;
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    
}
-(IBAction)btnShareFBPressed:(id)sender
{
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [self facebookLogin];
        
    }
    
}
-(IBAction)btnShareTWPressed:(id)sender
{
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    [self performSelector:@selector(postOnTwitter) withObject:nil afterDelay:0.001];
}

-(void)postOnTwitter
{
    
	NSString *mailCurrentLink=@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8";
    
    
    NSString *currentTitleStr=[NSString stringWithFormat:@"Join this push-to-talk support group: %@ First, install app WellConnected: ",self.shareGroupName];
    
    NSString *postData = [NSString stringWithFormat:@"%@ \n %@ Then, search group #: %@", currentTitleStr,mailCurrentLink,self.shareGroupCode];
    
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:postData];
        
        
        [tweetSheet addURL:[NSURL URLWithString:@""]];
        
        [self presentModalViewController:tweetSheet animated:YES];
        
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult res){
            
            
            if (res == TWTweetComposeViewControllerResultDone){
                
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"Your tweet has been posted successfully"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
            else if(res==TWTweetComposeViewControllerResultCancelled){
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"Your tweet can't be posted on twitter"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                
                [alertView show];
            }
            //dismiss the twitter modal view controller.
            [self dismissModalViewControllerAnimated:YES];
            
        };
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(IBAction)btnShareMailPressed:(id)sender
{
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
        
        [self sendEmail];
    }
}

-(void)sendEmail
{
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
	
	
}
-(void)displayComposerSheet
{
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    NSString *subject=[NSString stringWithFormat:@"Push-to-talk support group for %@",self.shareGroupName];
    
	[picker setSubject:subject];
	NSArray *toRecipients = [NSArray arrayWithObject:@""];
	[picker setToRecipients:toRecipients];
	
	NSString *titleStr=[NSString stringWithFormat:@"I thought you would be interested to join this push-to-talk support group: %@ <br><br> First, install app WellConnected: ",self.shareGroupName];
    
	NSString *mailCurrentLink=@"<html><body><a href=\"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8\">https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8</a></body></html>";
    
    NSString *groupCode=[NSString stringWithFormat:@"Then, search group #: %@",self.shareGroupCode];
    
    
	NSString *emailBody = @"";
	emailBody =[emailBody stringByAppendingFormat:@""];
	emailBody =[emailBody stringByAppendingFormat:@""];
    emailBody =[emailBody stringByAppendingFormat:@"%@",titleStr];
    emailBody =[emailBody stringByAppendingFormat:@""];
	emailBody =[emailBody stringByAppendingFormat:@"<br>"];
	emailBody =[emailBody stringByAppendingFormat:@"%@",[mailCurrentLink retain]];
	emailBody =[emailBody stringByAppendingFormat:@"<br><br>"];
    emailBody =[emailBody stringByAppendingFormat:@"%@",groupCode];
    
	
	[picker setMessageBody:emailBody isHTML:YES];
    
	
	[self presentModalViewController:picker animated:YES];
	[[[[picker viewControllers] lastObject] navigationItem] setTitle:@"New Message"];
	
	
    [picker release];
}

#pragma mark -
#pragma mark MailComposer Delegate Method


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
-(void)launchMailAppOnDevice
{
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    NSString *subject=[NSString stringWithFormat:@"Push-to-talk support group for %@",self.shareGroupName];
    
	[picker setSubject:subject];
	NSArray *toRecipients = [NSArray arrayWithObject:@""];
	[picker setToRecipients:toRecipients];
	
	NSString *titleStr=[NSString stringWithFormat:@"I thought you would be interested to join this push-to-talk support group: %@ <br><br> First, install app WellConnected: ",self.shareGroupName];
    
	NSString *mailCurrentLink=@"<html><body><a href=\"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8\">https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8</a></body></html>";
    
    NSString *groupCode=[NSString stringWithFormat:@"Then, search group #: %@",self.shareGroupCode];
    
	NSString *emailBody = @"";
	emailBody =[emailBody stringByAppendingFormat:@""];
	emailBody =[emailBody stringByAppendingFormat:@""];
    emailBody =[emailBody stringByAppendingFormat:@"%@",titleStr];
    emailBody =[emailBody stringByAppendingFormat:@""];
	emailBody =[emailBody stringByAppendingFormat:@"<br>"];
	emailBody =[emailBody stringByAppendingFormat:@"%@",[mailCurrentLink retain]];
	emailBody =[emailBody stringByAppendingFormat:@"<br><br>"];
    emailBody =[emailBody stringByAppendingFormat:@"%@",groupCode];
    
	
	[picker setMessageBody:emailBody isHTML:YES];
    
	
	[self presentModalViewController:picker animated:YES];
	[[[[picker viewControllers] lastObject] navigationItem] setTitle:@"New Message"];
	
	
    [picker release];
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
}
#pragma mark UIActionSheetDelegate


-(void)actionSheet:(UIActionSheet *)menu didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    int i = buttonIndex;
    switch(i)
    {
        case 0:
        {
            
        }
            
            break;
        case 1:
        {
            
            break;
            
        }
        default:
            break;
    }
    
}
-(void)facebookLogin
{
    if (facebook!=nil) {
        facebook=nil;
    }
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    facebook.sessionDelegate = self;
    permissions =  [NSArray arrayWithObjects:
                    @"email",@"read_stream", @"user_birthday",
                    @"user_about_me", @"publish_stream", @"offline_access", nil];
    [self login];
    
}
#pragma Mark ---------
#pragma Mark Facebook delegate

- (void)login {
    
	if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [self facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [self facebook].expirationDate =[defaults objectForKey:@"FBExpirationDateKey"];
		
	}
	
    if (![[self facebook] isSessionValid]) {
        [self facebook].sessionDelegate = self;
        [[self facebook] authorize:permissions];
		
    } else {
		[self getUserInfo:self];
	}
	
}
- (void)fbDidLogin {
	
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	NSString *fbToken=[defaults objectForKey:@"FBAccessTokenKey"];
    
    NSLog(@"%@",fbToken);
    
	[self getUserInfo:self];
	
}

- (void)getUserInfo:(id)sender {
	
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @" Back" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    // NSString *mailCurrentLink=@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8";
    
    NSString *currentTitleStr=[NSString stringWithFormat:@"Join this push-to-talk support group: %@ First, install app WellConnected ",self.shareGroupName];
    
    currentTitleStr=[currentTitleStr stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *postData = [NSString stringWithFormat:@"%@ \n Then, search group #: %@", currentTitleStr,self.shareGroupCode];
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,self.shareGroupImage];
    
    SBJSON *jsonWriter = [SBJSON new] ;
    
    NSDictionary* imageShare = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"image", @"type",
                                imageurl,@"src",
                                @"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8", @"href",
                                nil];
    
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8", @"name",
                                postData, @"caption",
                                @"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8", @"href",
                                [NSArray arrayWithObjects:imageShare, nil ], @"media",
                                nil];
    
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"api_key",
                                   @"Share on Facebook",  @"user_message_prompt",
                                   attachmentStr, @"attachment",
                                   nil];
    
    [facebook dialog: @"stream.publish"
           andParams: params
         andDelegate:self];
    
    
    
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    
	NSLog(@"%@", result);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert=	[[UIAlertView alloc] initWithTitle:nil message:@"You have posted successfully on facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
	
}
-(void)fbDidNotLogin:(BOOL)cancelled
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Facebook action cancel" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
	
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
	
}
-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    
}
-(void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    
}
-(void)dialogDidComplete:(FBDialog *)dialog
{
	
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    UIAlertView *alert=	[[UIAlertView alloc] initWithTitle:nil message:@"You have posted successfully on facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
	
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    
}
-(void)dialogDidNotComplete:(FBDialog *)dialog
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
}


-(IBAction)stratGroupPressed:(id)sender
{
    if ([gUserId isEqualToString:@""]) {
        
        exitAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Please login first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [exitAlert show];
        [exitAlert release];
        
    }
    else
    {
        objStartGroupView=[[StartGroupViewController alloc] initWithNibName:@"StartGroupViewController" bundle:nil];
        gCheckStartGroup=@"Group";

        [self.navigationController pushViewController:objStartGroupView animated:YES];
    }
   
}
-(IBAction)btnNoResultPressed:(id)sender
{
    if ([gUserId isEqualToString:@""]) {
        
        exitAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Please login first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [exitAlert show];
        [exitAlert release];
        
    }
    else
    {
        objStartGroupView=[[StartGroupViewController alloc] initWithNibName:@"StartGroupViewController" bundle:nil];
        gCheckStartGroup=@"Group";

        [self.navigationController pushViewController:objStartGroupView animated:YES];
    }

}
-(IBAction)manageGroupPressed:(id)sender
{
    objGroupListViewController=[[GroupListViewController alloc]initWithNibName:@"GroupListViewController" bundle:nil];
    
    [self.navigationController pushViewController:objGroupListViewController animated:YES];
    
    
}
-(IBAction)findGroupPressed:(id)sender
{
    objFinsGroupViewController=[[FinsGroupViewController alloc]initWithNibName:@"FinsGroupViewController" bundle:nil];
    
    [self.navigationController pushViewController:objFinsGroupViewController animated:YES];
    
}
-(IBAction)btnSearchPressed:(id)sender
{
    [txtSearch resignFirstResponder];
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    if (txtSearch.text.length>0) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            self.page=1;
            
            searchBar.text=txtSearch.text;
            self.searchString=txtSearch.text;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *pageStr=[NSString stringWithFormat:@"%d",page];
            NSLog(@"%@",pageStr);
            
            checkPaging=FALSE;
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            [service FindGroupInvocation:gUserId searchCriteria:txtSearch.text pageString:pageStr delegate:self];
        }
    }

}
-(IBAction)btnHelpPressed:(id)sender
{
    HelpViewController *help=[[HelpViewController alloc] init];
    help.urlStr=@"http://wellconnected.ehealthme.com/help";
    help.titleStr=@"";
    [self.navigationController pushViewController:help animated:YES];
}
-(IBAction)btnCancelPressed:(id)sender
{
    txtSearch.text=@"";
    [txtSearch resignFirstResponder];
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    if (![gUserId isEqualToString:@""]) {
        
        [self presentLeftMenuViewController:sender];

    }
    

}

#pragma mark Search Bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
    self.page=1;

	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1
{
	searchBar.showsCancelButton = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
	[searchBar resignFirstResponder];
	[self handleSearchForTerm:searchBar.text];
}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    searchBar1.showsCancelButton = YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
    
    [searchBar resignFirstResponder];
    
	[searchBar1 resignFirstResponder];
	searchBar1.text = @"";
    self.searchString=@"";
    
    [self.arrChatList removeAllObjects];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.page=1;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    checkPaging=FALSE;

    [service LatestGroupInvocation:gUserId page:pageStr delegate:self];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    
    NSLog(@"handleSearchForTerm");
    
    if (searchTerm.length>0) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            self.page=1;

            self.searchString=searchTerm;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *pageStr=[NSString stringWithFormat:@"%d",page];
            NSLog(@"%@",pageStr);
            
            checkPaging=FALSE;
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            [service FindGroupInvocation:gUserId searchCriteria:self.searchString pageString:pageStr delegate:self];
            
        }
    }
    
}
#pragma mark Delegate
#pragma mark Webservide Delegate



-(void)LatestGroupInvocationDidFinish:(LatestGroupInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    if (checkPaging==FALSE) {
        
        [self.arrChatList removeAllObjects];
        [self.arrSearchGroupList removeAllObjects];
        
    }
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"GroupDetail"];
        
        NSLog(@"unreadCount %@",[result objectForKey:@"unreadCount"]);
        
        NSString *unreadCountStr=[NSString stringWithFormat:@"%@",[result objectForKey:@"unreadCount"]];
        
        unreadCount=[unreadCountStr intValue];
        
        NSString *totRecord=[NSString stringWithFormat:@"%@",[result objectForKey:@"total_records"]];
        
        [lblTotalRecordCount setText:totRecord];
        
        if (totRecord==nil || totRecord==(NSString*)[NSNull null] || [totRecord isEqualToString:@""]) {
            
            self.totalRecord=0;
        }
        else
        {
            self.totalRecord=[totRecord intValue];
        }

        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"created",@"groupId",@"groupImage",@"groupName",@"groupType",@"intro",@"paidStatus",@"subCharge",@"join",@"groupOwnerId",@"latest",@"request_status",@"status",@"groupUserTableId",@"subscribe_status",@"individualCount",@"threadId",@"parent_id",@"special",@"groupCode",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                ChatListData *data=[[[ChatListData alloc] init] autorelease];
                
                data.groupType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupType"]];
                
                data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupId"]];
                
                data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupImage"]];
                
                data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupName"]];
                data.unreadMessageCount=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"individualCount"]];
                data.groupCode=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupCode"]];

                
                 //data.unreadMessageCount=@"0";
                
                NSLog(@"%@",[arrValue valueForKey:@"threadId"]);
                
                data.zChatId=[arrValue valueForKey:@"threadId"];
                
                NSLog(@"%@",data.zChatId);
                
                data.message=[self stringByStrippingHTML:[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]]];

                
               // data.message=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];
                data.date=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"created"]];
                data.charge=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"subCharge"]];
                data.groupJoinStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"join"]];
                data.groupOwnerId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupOwnerId"]];
                data.groupUserTableId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupUserTableId"]];
                data.subscribeStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"subscribeStatus"]];
                
                NSString *paidStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"paidStatus"]];
                NSString *latestStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"latest"]];

                data.latestStatus=latestStatus;
                
                if (paidStatus==nil || paidStatus==(NSString*)[NSNull null] || [paidStatus isEqualToString:@""]) {
                    
                    data.paidStatus=@"0";
                }
                else
                {
                    data.paidStatus=paidStatus;
                }
                
                data.readStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"status"]];
                data.requestStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"request_status"]];
                
                data.groupParentId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"parent_id"]];
                data.groupSpecialType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"special"]];


                [self.arrChatList addObject:data];
            }
            [self.arrSearchGroupList addObjectsFromArray:self.arrChatList];
            [arrOfResponseField release];
            
        }
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    [AppDelegate sharedAppDelegate].groupChatNotificationCount=unreadCount;
    
    UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
    tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].groupChatNotificationCount];
    
    NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].groupChatNotificationCount);
    
    if ([AppDelegate sharedAppDelegate].groupChatNotificationCount==0) {
        
        [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
        
    }

    [self.tblView reloadData];
    
    if (self.totalRecord>[self.arrChatList count]) {
        
        [BottomView removeFromSuperview];
        [BottomView setFrame:CGRectMake(0, self.view.frame.size.height-BottomView.frame.size.height, BottomView.frame.size.width, BottomView.frame.size.height)];
        
        [self.view addSubview:BottomView];
    }
    else
    {
        [BottomView removeFromSuperview];
    }
    
    if ([self.arrChatList count]>0) {
        
        [self.tblView setHidden:FALSE];
        [searchView removeFromSuperview];
    }
    else
    {
        [searchView removeFromSuperview];
        [self.tblView setHidden:TRUE];
        
        [self.view addSubview:searchView];
        

    }
    
    [lblNoResult setHidden:TRUE];
    [btnNoResult setHidden:TRUE];
    moveTabG=FALSE;
   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)FindGroupInvocationDidFinish:(FindGroupInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"result %@",result);
    
    if (![gUserId isEqualToString:@""]) {
        
        urlSchemeSearchText=@"";

    }
    
    NSLog(@"aaaaaaaaaaaaENDENDENDNDNDNNENDNNDNDssssssssbbbbbbbbbbbb");

    
    
    if (checkPaging==FALSE) {
        
        
        [self.arrChatList removeAllObjects];

    }
    NSLog(@"aaaaaaaaaaaaENDENDENDNDNDNNENDNNDNDssssssss");

    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"GroupDetail"];
        
        NSString *totRecord=[NSString stringWithFormat:@"%@",[result objectForKey:@"totalRecord"]];
        
        [lblTotalRecordCount setText:totRecord];
        
        if (totRecord==nil || totRecord==(NSString*)[NSNull null] || [totRecord isEqualToString:@""]) {
            
            self.totalRecord=0;
        }
        else
        {
            self.totalRecord=[totRecord intValue];
        }
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"friend_id",@"Chattype",@"friend_name",@"friend_image",@"message",@"msgId",@"status",@"date",@"groupId",@"groupImage",@"groupName",@"groupType",@"paidStatus",@"subCharge",@"request_status",@"groupOwnerId",@"groupUserTableId",@"static",@"join",@"threadId",@"parent_id",@"special",@"groupCode",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                ChatListData *data=[[[ChatListData alloc] init] autorelease];
                
                data.groupType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupType"]];
                
                data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupId"]];
                data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupImage"]];
                data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupName"]];
                data.groupJoinStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"join"]];
                data.zChatId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"threadId"]];
                data.groupCode=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupCode"]];

                data.message=[self stringByStrippingHTML:[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"message"]]];
                data.date=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"created"]];
                data.charge=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"subCharge"]];
                data.groupOwnerId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupOwnerId"]];
                
                NSString *paidStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"paidStatus"]];
                
                
                if (paidStatus==nil || paidStatus==(NSString*)[NSNull null] || [paidStatus isEqualToString:@""]) {
                    
                    
                    data.paidStatus=@"0";
                }
                else
                {
                    data.paidStatus=paidStatus;
                }
                
                data.groupParentId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"parent_id"]];
                data.groupSpecialType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"special"]];
                
                [self.arrChatList addObject:data];
            }
            
            [arrOfResponseField release];
            
            
        }
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    NSLog(@"ENDENDENDNDNDNNENDNNDNDssssssss");

    
    [self.tblView reloadData];
    
    if (self.totalRecord>[self.arrChatList count]) {
        
        [BottomView removeFromSuperview];
        [BottomView setFrame:CGRectMake(0, self.view.frame.size.height-BottomView.frame.size.height, BottomView.frame.size.width, BottomView.frame.size.height)];
        
        [self.view addSubview:BottomView];
    }
    else
    {
        [BottomView removeFromSuperview];
    }

    [searchView removeFromSuperview];
    [self.tblView setHidden:FALSE];

    if ([self.arrChatList count]>0) {
        
        [lblNoResult setHidden:TRUE];
        [btnNoResult setHidden:TRUE];
        
    }
    else
    {
        [lblNoResult setHidden:FALSE];
        [btnNoResult setHidden:FALSE];
    }
    
    NSLog(@"ENDENDENDNDNDNNENDNNDND");

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    moveTabG=FALSE;
}

-(void)JoinGroupInvocationDidFinish:(JoinGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)SpecialGroupJoinInvocationDidFinish:(SpecialGroupJoinInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)AcceptRejectGroupChatInvocationDidFinish:(AcceptRejectGroupChatInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    else
    {
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            checkPaging=FALSE;

            
            NSString *pageStr=[NSString stringWithFormat:@"%d",page];
            
            [service LatestGroupInvocation:gUserId page:pageStr delegate:self];        }
    }
    
}
-(NSString *) stringByStrippingHTML:(NSString*)intro {
    NSRange r;
    while ((r = [intro rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        intro = [intro stringByReplacingCharactersInRange:r withString:@""];
    
    intro= [intro stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    return intro;
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    
    if (self.searchString==nil || self.searchString==(NSString*)[NSNull null] || [self.searchString isEqualToString:@""]) {
        
        NSInteger count=[self.arrChatList count];
        
        if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height) {
            
            if (count < totalRecord)
            {
                page=page+1;
                
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                NSLog(@"%@",pageStr);
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                checkPaging=TRUE;
                
                [service LatestGroupInvocation:gUserId page:pageStr delegate:self];
                
                
                
                
            }
        }

    }
    else
    {
        NSInteger count=[self.arrChatList count];
        
        if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height) {
            
            if (count < totalRecord)
            {
                page=page+1;
                
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                NSLog(@"%@",pageStr);
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                checkPaging=TRUE;
                
                [service FindGroupInvocation:gUserId searchCriteria:self.searchString pageString:pageStr delegate:self];
                
                
                
                
            }
        }
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==exitAlert) {
       
        [[AppDelegate sharedAppDelegate] removeTabBar];
    }
}
#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollViewToCenterOfScreen:textField];
    
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
    CGFloat availableHeight = applicationFrame.size.height - 245;
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField) {
        
        searchBar.text=txtSearch.text;
        self.searchString=txtSearch.text;

		[textField resignFirstResponder];
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
        
        if (txtSearch.text.length>0) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                self.page=1;
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                NSLog(@"%@",pageStr);
                
                checkPaging=FALSE;
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                
                [service FindGroupInvocation:gUserId searchCriteria:txtSearch.text pageString:pageStr delegate:self];
            }
        }

	}
	return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    checkPN=@"NO";
    
    [objImageCache cancelDownload];
   
    objImageCache=nil;
    
    service=nil;
    
    txtSearch.text=@"";
    [txtSearch resignFirstResponder];
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];

    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.tblView.delegate=nil;
    self.tblView.dataSource=nil;
}
-(void)viewDidUnload
{
    
    self.tblView=nil;
    _arrChatList=nil;
    _arrSearchGroupList=nil;

    [super viewDidUnload];
}
-(void)dealloc
{
    [_arrChatList release];
    self.tblView=nil;
    [_arrSearchGroupList release];

    
     [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
