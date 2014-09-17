//
//  SearchChatListingViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SearchChatListingViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "ChatListData.h"
#import "AddContactViewController.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"
#import "StartGroupViewController.h"
#import "GroupInfoViewController.h"
#import "FinsGroupViewController.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "QSStrings.h"
#import "GroupListViewController.h"
#import "SettingViewController.h"
#import "PrivateChatListData.h"
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
@implementation SearchChatListingViewController

@synthesize tblView;

@synthesize arrChatList=_arrChatList;
@synthesize arrPrivateChatList=_arrPrivateChatList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //self.screenName = @"Chat Listing";
        
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
    
    [btnNotification setHidden:TRUE];
    
    if (self.arrChatList!=nil) {
        
        self.arrChatList=nil;
    }
    
    self.arrChatList=[[NSMutableArray alloc] init];
    
    if (self.arrPrivateChatList!=nil) {
        
        self.arrPrivateChatList=nil;
    }
    
    self.arrPrivateChatList=[[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveForgroundNotification:) name:@"RemoteNotificationReceivedWhileForgroud" object:Nil];
    
    
    //[tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep.png"]]];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Chats"];
    
    /*UIButton *SearchButton=[UIButton buttonWithType:UIButtonTypeCustom];
     [SearchButton setImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
     [SearchButton setFrame:CGRectMake(0,1, 39,43)];
     [SearchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     UIView *searchbuttoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 1, 39, 43)]autorelease];
     [searchbuttoView addSubview:SearchButton];
     
     UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:searchbuttoView]autorelease];
     self.navigationItem.leftBarButtonItem=leftBtn;
     */
    
    UIButton *AddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[AddButton setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [AddButton setFrame:CGRectMake(0,8, 42,29)];
    [AddButton setTitle:@"Add" forState:UIControlStateNormal];
    [AddButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    [AddButton.titleLabel setTextColor:[UIColor whiteColor]];
    [AddButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *addbuttoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 1, 39, 43)]autorelease];
    [addbuttoView addSubview:AddButton];
    
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:addbuttoView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton setFrame:CGRectMake(0,0, 25,29)];
    [menuButton addTarget:self action:@selector
     
     
     
     
     (presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=left;
    

    // Do any additional setup after loading the view from its nib.
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
    
  /*  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"Chat Listing" value:@"Stopwatch"];
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
            
            if ([nType isEqualToString:@"chat"]) {
                
                moveTabG=TRUE;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service ChatListInvocation:gUserId searchString:@"" delegate:self];
                
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [service ChatListInvocation:gUserId searchString:@"" delegate:self];
            
        }
        
    }
    
}

-(IBAction)searchButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}


-(void)viewWillAppear:(BOOL)animated
{
    checkPN=@"YES";
    NSLog(@"viewWillAppear");
    
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 450)];
            
            
        }
        else
        {
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 450-IPHONE_FIVE_FACTOR)];
            
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 436)];
            
            
        }
        else
        {
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 436-IPHONE_FIVE_FACTOR)];
            
            
            
            
        }
        
    }
    
    
    objImageCache=[[ImageCache alloc] init];
    objImageCache.delegate=self;
    
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    
    
    [self.tblView setContentOffset:CGPointMake(0, 0)];
    
    tblView.delegate=self;
    tblView.dataSource=self;
    
    if (![gUserId isEqualToString:@""]) {
        
        if (service==nil) {
            
            service=[[ConstantLineServices alloc] init];
        }
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [service ChatListInvocation:gUserId searchString:@"" delegate:self];
            
        }
        
    }
    
    
}

#pragma mark Delegate
#pragma mark TableView Delegate And DateSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrChatList count];
    
    NSLog(@"%d",[self.arrChatList count]);
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    if ([data.requestStatus isEqualToString:@"1"]) {
        
        return 90;
        
    }
    else
    {
        return 80;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //static NSString *cellIdentifier=@"Cell";
    static NSString *unpaidCellIdentifier=@"UnpaidCell";
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",data.paidStatus);
    
    unpaidCell = (ChatListUnpaidTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:unpaidCellIdentifier];
    
    if (Nil == unpaidCell)
    {
        unpaidCell = [ChatListUnpaidTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    [unpaidCell setBackgroundColor:[UIColor clearColor]];
    
    
    unpaidCell.accessoryType = UITableViewCellAccessoryNone;
    unpaidCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    unpaidCell.lblName.text= data.name;
    unpaidCell.lblMessage.text=[data.message capitalizedString];
    unpaidCell.lblDate.text=data.date;
    
    int msgCount=[data.unreadMessageCount intValue];
    
    if (msgCount>0) {
        
        [unpaidCell.lblMsgCount setText:[NSString stringWithFormat:@"%@",data.unreadMessageCount]];

    }
    else
    {
        [unpaidCell.lblMsgCount setText:@""];

    }
    
    if ([data.chatType isEqualToString:@"1"]) {
        
        [unpaidCell.imgChatType setImage:[UIImage imageNamed:@"msg_icon"]];
    }
    else if([data.chatType isEqualToString:@"2"])
    {
        [unpaidCell.imgChatType setImage:[UIImage imageNamed:@"photo_icon"]];

    }
    else
    {
        [unpaidCell.imgChatType setImage:[UIImage imageNamed:@"clip_icon"]];

    }
    
    if ([data.requestStatus isEqualToString:@"1"]) {
        
        [unpaidCell.btnAccept setHidden:FALSE];
        [unpaidCell.btnReject setHidden:FALSE];
        
        [unpaidCell.imgSep setFrame:CGRectMake(0, 89, 320, 1)];
    }
    else
    {
        [unpaidCell.btnAccept setHidden:TRUE];
        [unpaidCell.btnReject setHidden:TRUE];
        
        [unpaidCell.imgSep setFrame:CGRectMake(0, 79, 320, 1)];
        
    }
    
    if (data.readStatus==nil || data.readStatus==(NSString*)[NSNull null] || [data.readStatus isEqualToString:@""]) {
        
        [unpaidCell.imgStatus setImage:nil];
        
    }
    else
    {
        if ([data.readStatus isEqualToString:@"read"])
        {
            
            [unpaidCell.imgStatus setImage:nil];
        }
        else
        {
            [unpaidCell.imgStatus setImage:[UIImage imageNamed:@"green.png"]];
        }
    }
    

    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        if ([data.groupType isEqualToString:@"0"]) {
            
            [unpaidCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
            
        }
        else
        {
            [unpaidCell.imgView setImage:[UIImage imageNamed:@"group_pic.png"]];
            
        }
    }
    else
    {
        NSString *imageUrl=@"";
        if ([data.groupType isEqualToString:@"0"]) {
            
            imageUrl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
            
        }
        else
        {
            imageUrl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.image];
            
        }
        
        UIImage *img = [objImageCache iconForUrl:imageUrl];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:imageUrl withSize:kImgSize_1 forIndexPath:indexPath];
            
            
        }
        
        else {
            
            [unpaidCell.imgView setImage:img];
        }
        
    }
    
    
    return unpaidCell;
    //}
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    if ([data.requestStatus isEqualToString:@"2"]) {
        
        int msgCount=[AppDelegate sharedAppDelegate].chatNotificationCount-[data.unreadMessageCount intValue];
        
        [AppDelegate sharedAppDelegate].chatNotificationCount=msgCount;
        
        UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].chatNotificationCount];
        
        NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].chatNotificationCount);
        
        if ([AppDelegate sharedAppDelegate].chatNotificationCount==0) {
            
            [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
            
        }
        
        objChatViewController=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        
        objChatViewController.friendUserName=data.name;
        objChatViewController.groupType=data.groupType;
        objChatViewController.threadId=data.zChatId;
        objChatViewController.groupTitle=@"";

        if ([data.groupType isEqualToString:@"0"]) {
            
            objChatViewController.friendId=data.userId;
            objChatViewController.groupId=@"0";
        }
        else
        {
            objChatViewController.groupId=data.userId;
            objChatViewController.friendId=@"0";
            
        }
        
        NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
        
        objChatViewController.friendUserImage=imageUrl;
        
        [self.navigationController pushViewController:objChatViewController animated:YES];
    }
    
}

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}

-(void) buttonUnpaidAcceptClick:(ChatListUnpaidTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        
        if ([data.groupType isEqualToString:@"0"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectChatInvocation:data.messasgeId friendId:data.userId type:@"2" delegate:self];
            
            
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"2" delegate:self];
        }
        
    }
    
}
-(void) buttonUnpaidRejectClick:(ChatListUnpaidTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        if ([data.groupType isEqualToString:@"0"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectChatInvocation:data.messasgeId friendId:data.userId type:@"3" delegate:self];
            
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"3" delegate:self];
        }
    }
    
}
-(void) buttonAcceptClick:(ChatListTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        if ([data.groupType isEqualToString:@"0"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectChatInvocation:data.messasgeId friendId:data.userId type:@"2" delegate:self];
            
        }
        else
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
-(void) buttonRejectClick:(ChatListTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrChatList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        if ([data.groupType isEqualToString:@"0"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectChatInvocation:data.messasgeId friendId:data.userId type:@"3" delegate:self];
            
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service AcceptRejectGroupChatInvocation:gUserId groupId:data.userId groupUserTableId:data.groupUserTableId groupOwnerId:data.groupOwnerId status:@"3" delegate:self];
        }
    }
    
    
}
-(IBAction)addButtonClick:(id)sender
{
    if (moveTabG==FALSE) {
        
        objPrivateChatController=[[PrivateChatContactsViewController alloc] init];
        [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";
        objPrivateChatController.checkView=@"addPrivate";
        
        [self.navigationController pushViewController:objPrivateChatController animated:YES];
    }
}

-(IBAction)stratGroupPressed:(id)sender
{
    
    objStartGroupView=[[StartGroupViewController alloc] initWithNibName:@"StartGroupViewController" bundle:nil];
    
    [self.navigationController pushViewController:objStartGroupView animated:YES];
}
-(IBAction)manageGroupPressed:(id)sender
{
    
    objGroupListViewController=[[GroupListViewController alloc]initWithNibName:@"GroupListViewController" bundle:nil];
    
    [self.navigationController pushViewController:objGroupListViewController animated:YES];
    
    /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Under development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alert show];
     [alert release];*/
}
-(IBAction)findGroupPressed:(id)sender
{
    objFinsGroupViewController=[[FinsGroupViewController alloc]initWithNibName:@"FinsGroupViewController" bundle:nil];
    
    [self.navigationController pushViewController:objFinsGroupViewController animated:YES];
    
    /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Under development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alert show];
     [alert release];*/
    
}


#pragma mark Delegate
#pragma mark Webservide Delegate

-(void)ChatListInvocationDidFinish:(ChatListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrChatList removeAllObjects];
    [self.arrPrivateChatList removeAllObjects];
    
    unreadCount=0;
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"ChatDetail"];
        
        NSLog(@"unreadCount %@",[result objectForKey:@"unreadCount"]);
        
        NSString *unreadCountStr=[NSString stringWithFormat:@"%@",[result objectForKey:@"unreadCount"]];
        
        unreadCount=[unreadCountStr intValue];
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"friend_id",@"Chattype",@"friend_name",@"friend_image",@"message",@"msgId",@"status",@"date",@"groupId",@"groupImage",@"groupName",@"groupType",@"paidStatus",@"subCharge",@"request_status",@"groupOwnerId",@"groupUserTableId",@"static",@"subscription",@"chatStatus",@"individualCount",@"threadId",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                
                ChatListData *data=[[[ChatListData alloc] init] autorelease];
                
                data.requestStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"request_status"]];
                
                data.groupType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupType"]];
                data.chatStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"chatStatus"]];
                data.zChatId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"threadId"]];
                
                data.unreadMessageCount=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"individualCount"]];
                
                // data.unreadMessageCount=@"0";
                
                
                if ([data.groupType isEqualToString:@"0"]) {
                    
                    data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"friend_id"]];
                    data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"friend_image"]];
                    data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"friend_name"]];
                }
                else
                {
                    data.subscribeStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"subscription"]];
                    
                    data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupId"]];
                    data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupImage"]];
                    data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupName"]];
                }
                
                data.readStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"status"]];
                data.chatType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"Chattype"]];
                
                NSString *staticStr=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"static"]];
                
                NSString *msg=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"message"]];
                
                NSLog(@"msg %@",msg);
                
                NSString *result=@"";
                
                if ([data.chatType isEqualToString:@"1"]) {
                    
                    NSLog(@"fsfhjds kjdsh jkdsgh jgk d");
                    
                    if ([staticStr isEqualToString:@"1"]) {
                        
                        result=msg;
                    }
                    else
                    {
                        
                        NSData *dataMsg=[QSStrings decodeBase64WithString:msg];
                        
                        result = [[[NSString alloc] initWithData:dataMsg encoding:NSUTF8StringEncoding] autorelease];
                        
                    }
                    
                }
                else
                {
                    result=msg;
                }
                
                NSLog(@"result %@",result);
                
                data.message=result;
                data.messasgeId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"msgId"]];
                data.date=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"created"]];
                data.charge=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"subCharge"]];
                data.groupOwnerId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupOwnerId"]];
                data.groupUserTableId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupUserTableId"]];
                
                NSString *paidStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"paidStatus"]];
                
                if (paidStatus==nil || paidStatus==(NSString*)[NSNull null] || [paidStatus isEqualToString:@""]) {
                    
                    
                    data.paidStatus=@"0";
                }
                else
                {
                    data.paidStatus=paidStatus;
                }
                
                
                
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
    
    
    [AppDelegate sharedAppDelegate].chatNotificationCount=unreadCount;
    
    UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
    tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].chatNotificationCount];
    
    NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].chatNotificationCount);
    
    if ([AppDelegate sharedAppDelegate].chatNotificationCount==0) {
        
        [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
        
    }
    
    [self.tblView reloadData];
    [self.tblView setHidden:FALSE];
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)AcceptRejectChatInvocationDidFinish:(AcceptRejectChatInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
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
            [service ChatListInvocation:gUserId searchString:@"" delegate:self];
            
        }
        
    }
    
    
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
            [service ChatListInvocation:gUserId searchString:@"" delegate:self];
        }
    }
    
}


#pragma mark Search Bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
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
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service ChatListInvocation:gUserId searchString:@"" delegate:self];
        
    }
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        if (searchTerm.length>0) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service ChatListInvocation:gUserId searchString:searchTerm delegate:self];
        }
        
    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [objImageCache cancelDownload];
    objImageCache=nil;
    
    service=nil;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    checkPN=@"NO";
    self.tblView.delegate=nil;
    self.tblView.dataSource=nil;
}

#pragma mark Delegate
#pragma mark Webservide Delegate

- (void)viewDidUnload
{
    _arrChatList=nil;
    _arrPrivateChatList=nil;
    self.tblView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_arrPrivateChatList release];
    [_arrChatList release];
    self.tblView=nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
