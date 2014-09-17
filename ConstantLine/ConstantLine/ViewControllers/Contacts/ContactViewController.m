//
//  ContactViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "ContactTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AddContactViewController.h"
#import "ChatViewController.h"
#import "UserProfileViewController.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "RecomondedFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"

@implementation ContactViewController

@synthesize tblView;

@synthesize arrContactList=_arrContactList;
@synthesize arrSearchContactList=_arrSearchContactList;
@synthesize arrRecomandedList=_arrRecomandedList;

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ."
#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.screenName = @"Contacts";

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
    
    font = [UIFont fontWithName:ARIALFONT_BOLD size:14.0];
    
    VertPadding = 4;       // additional padding around the edges
    HorzPadding = 4;
    
    TextLeftMargin = 17;   // insets for the text
    TextRightMargin = 15;
    TextTopMargin = 10;
    TextBottomMargin = 11;
    
    MinBubbleWidth = 50;   // minimum width of the bubble
    MinBubbleHeight = 40;  // minimum height of the bubble
    
    WrapWidth = 185;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveForgroundNotification:) name:@"RemoteNotificationReceivedWhileForgroud" object:Nil];
    
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Contacts"];
    
   /* EditButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [EditButton setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [EditButton setTitle:@"Edit" forState:UIControlStateNormal];
    [EditButton.titleLabel setFont:[UIFont fontWithName:ARIALFONT_BOLD size:13]];
    [EditButton setFrame:CGRectMake(0,10, 45,25)];
    [EditButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *editbuttoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)]autorelease];
    [editbuttoView addSubview:EditButton];
    
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:editbuttoView] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;*/
    
    UIButton *AddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[AddButton setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [AddButton setFrame:CGRectMake(0,8, 42,29)];
    [AddButton setTitle:@"Add" forState:UIControlStateNormal];
    [AddButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    [AddButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *addbuttoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 1, 39, 43)]autorelease];
    [addbuttoView addSubview:AddButton];
    
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:addbuttoView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton setFrame:CGRectMake(0,0, 25,29)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=left;

  
        if (self.arrContactList==nil) {
            
            self.arrContactList=nil;
        }
        if (self.arrSearchContactList==nil) {
            
            self.arrSearchContactList=nil;
        }
        if (self.arrRecomandedList==nil) {
            
            self.arrRecomandedList=nil;
        }
        
        self.arrContactList=[[NSMutableArray alloc] init];
        self.arrSearchContactList=[[NSMutableArray alloc] init];
        self.arrRecomandedList=[[NSMutableArray alloc] init];

           
}
-(IBAction)addButtonClick:(id)sender
{
    if (moveTabG==FALSE) {
        
        objAddContactViewController=[[AddContactViewController alloc] init];
        [self.navigationController pushViewController:objAddContactViewController animated:YES];

    }
  }
- (void)didReceiveBackgroundNotification:(NSNotification*) note{
    
    NSLog(@"didReceiveBackgroundNotification");
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            NSDictionary* notification = (NSDictionary*)[note object];
            
            NSString* nType = [notification valueForKeyPath:@"aps.type"];
            
            if ([nType isEqualToString:@"contact"]) {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [service ContactListInvocation:gUserId delegate:self];
            }
            
        }
        
    }
}

- (void)didReceiveForgroundNotification:(NSNotification*) note{
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service ContactListInvocation:gUserId delegate:self];
            
        }
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
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
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 370)];
            
            
        }
        else
        {
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 370-IPHONE_FIVE_FACTOR)];
            
            
            
            
        }
        
    }

        
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   
    
        [lblNoResult setHidden:TRUE];
        
        checkPN=@"YES";
        
        checkIndex=TRUE;

        searchBar.text=@"";
        [searchBar resignFirstResponder];
    
    if (![gUserId isEqualToString:@""]) {
       
        if (service!=nil) {
            service=nil;
        }
        if (objImageCache!=nil) {
            
            objImageCache=nil;
        }
        
        service=[[ConstantLineServices alloc] init];
        objImageCache=[[ImageCache alloc] init];
        objImageCache.delegate=self;
        
        [self.tblView setContentOffset:CGPointMake(0, 0)];
        
        self.tblView.delegate=nil;
        self.tblView.dataSource=nil;
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    moveTabG=TRUE;
    [service ContactListInvocation:gUserId delegate:self];

    }
        
    }
    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];
    
    self.tblView.sectionIndexBackgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"alphabet_strip.png"]];

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
    [tracker set:@"Contacts" value:@"Stopwatch"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self dispatch];*/
    
    
}

-(IBAction)editButtonClick:(id)sender
{
    if (self.editing) {
        
		[super setEditing:NO animated:NO];
        [EditButton setTitle:@"Edit" forState:UIControlStateNormal];
		[self.tblView setEditing:NO animated:NO];
		[self.tblView reloadData];
        
	}
	else {
        
		[super setEditing:YES animated:YES];
        [EditButton setTitle:@"Done" forState:UIControlStateNormal];
        
        
		[self.tblView setEditing:YES animated:YES];
		[self.tblView reloadData];
        
		
	}
    
}
-(void) buttonAddFriend:(ContactTableViewPendingCell*)cellValue
{
    NSIndexPath * indexPath = [self.tblView indexPathForCell:cellValue];
    
    NSString *requestId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *friendId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service AcceptRejectFriendRequestInvocation:requestId friendId:friendId type:@"2" delegate:self];
    
}
-(void) buttonRejectFriend:(ContactTableViewPendingCell*)cellValue
{
    NSIndexPath * indexPath = [self.tblView indexPathForCell:cellValue];
    
    NSString *requestId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *friendId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service AcceptRejectFriendRequestInvocation:requestId friendId:friendId type:@"3" delegate:self];
}

#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    NSLog(@"numberOfSectionsInTableView");

    NSInteger section=0;
    
    section=[ALPHA_ARRAY count];
    
	return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[[self.arrContactList objectAtIndex:section] count];
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    NSString *requestStatus=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"request_status"];
    
    if ([requestStatus isEqualToString:@"1"]) {
        
        NSString *intro=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"intro"];
        
        CGSize randomSizeFortext=[self sizeForText:intro];

        float a;
        
        if (randomSizeFortext.height>60) {
            
            a=randomSizeFortext.height+40;
            
        }
        else if (randomSizeFortext.height>40) {
            
            a=randomSizeFortext.height+30;
            
        }
        else if (randomSizeFortext.height>20) {
            
            a=randomSizeFortext.height+10;
            
        }
        else
        {
            a=randomSizeFortext.height;

        }
        
        if (a<70) {
            
            height=70;
        }
        else
        {
            height=a;
            
        }
        


    }
    else
    {
        height=60;

    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    static NSString *pendingCellIdentifier=@"PendingCell";

    NSString *requestStatus=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"request_status"];
    

    if ([requestStatus isEqualToString:@"1"]) {
        
        pendingCell = (ContactTableViewPendingCell*)[self.tblView dequeueReusableCellWithIdentifier:pendingCellIdentifier];
        
        
        if (Nil == pendingCell)
        {
            pendingCell = [ContactTableViewPendingCell createTextRowWithOwner:self withDelegate:self];
        }
        
        [pendingCell setBackgroundColor:[UIColor grayColor]];
        
        pendingCell.accessoryType = UITableViewCellAccessoryNone;
        pendingCell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSString *image;
        
        pendingCell.lblName.text=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"user_name"];
        
        pendingCell.txtView.text=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"intro"];
        
        NSString *intro=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"intro"];

        CGSize randomSizeFortext=[self sizeForText:intro];
        
        if (randomSizeFortext.height>50) {
            
            [pendingCell.txtView setFrame:CGRectMake(pendingCell.txtView.frame.origin.x,pendingCell.txtView.frame.origin.y,pendingCell.txtView.frame.size.width,randomSizeFortext.height+10)];
        }
        else
        {
            [pendingCell.txtView setFrame:CGRectMake(pendingCell.txtView.frame.origin.x,pendingCell.txtView.frame.origin.y,pendingCell.txtView.frame.size.width,randomSizeFortext.height)];
        }
        
        image=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"user_image"];
        
        NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbImageUrl,image];
        
        if (image==nil || image==(NSString *)[NSNull null] || [image isEqualToString:@""]) {
            
            [pendingCell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
            
        }
        else
        {
            if (imageurl && [imageurl length] > 0) {
                
                UIImage *img = [objImageCache iconForUrl:imageurl];
                
                if (img == Nil) {
                    
                    CGSize kImgSize_1;
                    if ([[UIScreen mainScreen] scale] == 1.0)
                    {
                        kImgSize_1=CGSizeMake(80, 80);
                    }
                    else{
                        kImgSize_1=CGSizeMake(80*2, 80*2);
                    }
                    
                    [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:indexPath];
                    
                    
                }
                
                else {
                    
                    [pendingCell.imgView setImage:img];
                }
                
            }
            
            
            
        }
        
        return pendingCell;
    }
    else
    {
        cell = (ContactTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
        

        
        if (Nil == cell)
        {
            
            cell = [ContactTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        ContactTableViewCell *weakCell = cell;
        
        NSString *userid=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"];

        
        [cell setAppearanceWithBlock:^{
            //   weakCell.leftUtilityButtons = [self leftButtons];
            weakCell.leftUtilityButtons = [self leftButtons:userid];
            weakCell.delegate = self;
            weakCell.containingTableView = tableView;
        } force:NO];
        
        [cell setCellHeight:cell.frame.size.height];


        NSString *image;
        
        
        cell.lblName.text=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"user_name"];
        
        image=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"user_image"];
        
        NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbImageUrl,image];
        
        if (image==nil || image==(NSString *)[NSNull null] || [image isEqualToString:@""]) {
            
            [cell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
            
        }
        else
        {
            if (imageurl && [imageurl length] > 0) {
                
                UIImage *img = [objImageCache iconForUrl:imageurl];
                
                if (img == Nil) {
                    
                    CGSize kImgSize_1;
                    if ([[UIScreen mainScreen] scale] == 1.0)
                    {
                        kImgSize_1=CGSizeMake(80, 80);
                    }
                    else{
                        kImgSize_1=CGSizeMake(80*2, 80*2);
                    }
                    
                    [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:indexPath];
                    
                    
                }
                
                else {
                    
                    [cell.imgView setImage:img];
                }
                
            }
            
            
            
        }
        
        return cell;

    }
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *requestStatus=[[[self.arrContactList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"request_status"];
    
    if (![requestStatus isEqualToString:@"1"]) {

    
            [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";

            objFriendProfileViewController=[[FriendProfileViewController alloc] init];
            objFriendProfileViewController.userId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"user_id"];
            objFriendProfileViewController.navTitle=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"user_name"];
            objFriendProfileViewController.checkView=@"Other";
            objFriendProfileViewController.checkChatButtonStatus=@"YES";
            
            [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
        
    }
    
}
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}

/*#pragma mark Edit Table delegate method

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    NSString *userid=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    NSString *localId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    
    if (![localId isEqualToString:@"100"]) {
        
        [self.arrContactList removeObjectAtIndex:indexPath.row];
        [self.arrSearchContactList removeObjectAtIndex:indexPath.row];
        
        NSLog(@"%@",userid);
        
        NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_contact where UserId='%@' and ContactId='%@'",gUserId,localId];
        
        NSLog(@"%@",sqlStatement);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            
            NSLog(@"success");
        }
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        service=[[ConstantLineServices alloc] init];
        [service DeleteContactInvocation:gUserId friendId:userid delegate:self];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You can't delete this user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}*/
-(IBAction)btnRecomandedFriendsPressed:(id)sender
{
   
  RecomondedFriendsViewController *objRecomandedView=[[RecomondedFriendsViewController alloc] init];
  objRecomandedView.arrRecommandFriendList=[[NSMutableArray alloc] init];
  [objRecomandedView.arrRecommandFriendList addObjectsFromArray:self.arrRecomandedList];
  [self.navigationController pushViewController:objRecomandedView animated:YES];
  [objRecomandedView release];

    
}
- (void) createSectionList: (id) wordArray
{
    NSString *idStr;
	NSString *firstname;
	NSString *image;
    NSString *requestStatus;
    
    int unreadCount=0;
	
    NSLog(@"%@",wordArray);
    
    NSLog(@"%d",[wordArray count]);
    
    if (self.arrContactList!=nil) {
        
        self.arrContactList=nil;
    }
    self.arrContactList=[[NSMutableArray alloc] init];
    
    if (gArrContactList!=nil) {
        
        gArrContactList=nil;
    }
    gArrContactList=[[NSMutableArray alloc] init];


    
    for (int i = 0; i < 27; i++) [self.arrContactList addObject:[[NSMutableArray alloc] init]];
	
    int k=0;
	
    
    
    for (k=0; k < [wordArray count]; k++) {
        
        NSLog(@"%d",[wordArray count]);
        
        NSString *word =[[wordArray objectAtIndex:k] objectForKey:@"user_name"];
        
        word= [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        word=[word stringByReplacingOccurrencesOfString:@"1" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"0" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"2" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"3" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"4" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"5" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"6" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"7" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"8" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"9" withString:@"z"];
        word=[word stringByReplacingOccurrencesOfString:@"." withString:@"z"];

        
        if ([word length] == 0) continue;
        
        
        range = [ALPHA rangeOfString:[[word substringToIndex:1] uppercaseString]];
        
        
        if ([[wordArray  objectAtIndex:k]objectForKey:@"user_name"]==nil || [[wordArray  objectAtIndex:k]objectForKey:@"user_name"]== (NSString*)[NSNull null]) {
            
            firstname=@"";
            
        }
        else
        {
            firstname=[[wordArray  objectAtIndex:k]objectForKey:@"user_name"];
            
        }
        if ([[wordArray  objectAtIndex:k]objectForKey:@"user_id"]==nil || [[wordArray  objectAtIndex:k]objectForKey:@"user_id"]== (NSString*)[NSNull null]) {
            
            idStr=@"";
            
        }
        else
        {
            idStr=[[wordArray  objectAtIndex:k]objectForKey:@"user_id"];
            
        }
        if ([[wordArray  objectAtIndex:k]objectForKey:@"user_image"]==nil || [[wordArray  objectAtIndex:k]objectForKey:@"user_image"]== (NSString*)[NSNull null]) {
            
            image=@"";
            
        }
        else
        {
            image=[[wordArray  objectAtIndex:k]objectForKey:@"user_image"];
            
        }
        if ([[wordArray  objectAtIndex:k]objectForKey:@"request_status"]==nil || [[wordArray  objectAtIndex:k]objectForKey:@"request_status"]== (NSString*)[NSNull null]) {
            
            requestStatus=@"";
            
        }
        else
        {
            requestStatus=[[wordArray  objectAtIndex:k]objectForKey:@"request_status"];
            
            if ([requestStatus isEqualToString:@"1"]) {
                
                unreadCount=unreadCount+1;
            }
            
        }
        NSString *deleteId=[[wordArray  objectAtIndex:k]objectForKey:@"id"];
        NSString *intro=[[wordArray  objectAtIndex:k]objectForKey:@"intro"];

        
        
        NSLog(@"%d",range.location);
        
        [[self.arrContactList objectAtIndex:range.location]addObject:[NSDictionary dictionaryWithObjectsAndKeys:firstname,@"user_name",idStr,@"user_id",image,@"user_image",deleteId,@"id",requestStatus,@"request_status",intro,@"intro",nil]];
        
        
        
    }
    [gArrContactList removeAllObjects];
    [gArrContactList addObjectsFromArray:self.arrContactList];
    
    [AppDelegate sharedAppDelegate].contactNotificationCount=unreadCount;
    
    UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:2];
    tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].contactNotificationCount];
    
    NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].contactNotificationCount);
    
    if ([AppDelegate sharedAppDelegate].contactNotificationCount==0) {
        
        [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
        
    }
    
    [self.tblView setHidden:FALSE];	
    self.tblView.delegate=self;
    self.tblView.dataSource=self;
    [self.tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:1];
    
    
    
	
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    NSLog(@"sectionIndexTitlesForTableView");
    
    BOOL dotFlag = FALSE;
    
    NSMutableArray *indexarray=[[NSMutableArray alloc]init];
    
    if (checkIndex==TRUE) {
        
        for (NSDictionary *dic in self.arrSearchContactList){
            
            if([[dic objectForKey:@"user_name"] length] > 0){
                
                NSString *fstLetter1 = [[dic objectForKey:@"user_name"] substringToIndex:1];
                NSString* fstLetter = [fstLetter1 uppercaseString];
                
                if(![indexarray containsObject:fstLetter]){
                    
                    BOOL flag=[self stringIsNumeric:fstLetter];
                    
                    if (flag) {
                        
                        dotFlag = TRUE;
                    }
                    else
                    {
                        [indexarray addObject:fstLetter];
                    }
                }
            }
        }
        if(dotFlag){
            [indexarray addObject:@"."];            
        }
    }
    
    
    return indexarray;
    
}
-(BOOL) stringIsNumeric:(NSString *)str {
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
    
    UILabel * headerLabel;
    
    
    if([[self.arrContactList objectAtIndex:section] count]==0)
    {
        return nil;
        
    }
    
    else {
        
        UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(5.0, 2.0, 300.0, 20.0)] autorelease];
        [customView setBackgroundColor:[UIColor colorWithRed:136.0/255.0 green:141.0/255.0 blue:154.0/255.0 alpha:1.0]];
        headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Arial" size:16];
        [headerLabel setFont:[UIFont systemFontOfSize:16]];
        headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 20.0);
        [headerLabel setTextColor:[UIColor whiteColor]];
        [customView addSubview:headerLabel];
        
        [headerLabel setText:[NSString stringWithFormat:@"%@",[ALPHA_ARRAY objectAtIndex:section]]];
        
        [headerLabel release];
        
        return customView;
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height=0;
    
    NSLog(@"%d",section);
    
    
    if ([[self.arrContactList objectAtIndex:section] count]==0) {
        
        height=0;
        
    }
    
    else
    {
        height=20;
        
    }
    
    
    
    return height;
}

#pragma mark Swipe tableview delegate


- (NSArray *)leftButtons:(NSString *)tag
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.1411764 green:0.18431317 blue:0.2392156 alpha:1.0] icon:[UIImage imageNamed:@"close_icon.png"] tag:tag];
    
    return leftUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell1 didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath * indexPath = [self.tblView indexPathForCell:cell1];
            
            NSLog(@"%d",indexPath.section);
            NSLog(@"%d",indexPath.row);

            NSString *userid=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"];
            
            NSString *localId=[[[self.arrContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"user_id"];
            
            if (![localId isEqualToString:@"100"]) {
                
                [self.arrContactList removeObjectAtIndex:indexPath.row];
                [self.arrSearchContactList removeObjectAtIndex:indexPath.row];
                
                NSLog(@"%@",userid);
                NSLog(@"%@",localId);

                NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_contact where UserId='%@' and ContactId='%@'",gUserId,localId];
                
                NSLog(@"%@",sqlStatement);
                
                if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
                {
                    
                    NSLog(@"success");
                }
                
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                service=[[ConstantLineServices alloc] init];
                [service DeleteContactInvocation:gUserId friendId:userid delegate:self];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You can't delete this user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
            [cell1 hideUtilityButtonsAnimated:YES];
            
            break;
        }
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell1 didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            
            [cell1 hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            [cell1 hideUtilityButtonsAnimated:YES];
            
            break;
        }
        case 2:
        {
            [cell1 hideUtilityButtonsAnimated:YES];
            
            break;
        }
        case 3:
        {
            [cell1 hideUtilityButtonsAnimated:YES];
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
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
    [self handleSearchForTerm:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
    
    [lblNoResult setHidden:TRUE];
    checkIndex=TRUE;
    [searchBar resignFirstResponder];
    
	[searchBar1 resignFirstResponder];
	searchBar1.text = @"";
    
    if (self.arrContactList.count>0) {
        [self.arrContactList removeAllObjects];
    }
    for(int i=0;i<self.arrSearchContactList.count;i++){
        
        [self.arrContactList addObject:[self.arrSearchContactList objectAtIndex:i]];
    }
    
    [self createSectionList:self.arrSearchContactList];
    
    
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    if (self.arrContactList!=nil) {
        
        self.arrContactList=nil;
    }
    self.arrContactList=[[NSMutableArray alloc] init];
    
    if (gArrContactList!=nil) {
        
        gArrContactList=nil;
    }
    gArrContactList=[[NSMutableArray alloc] init];

    
    if ([searchTerm length] != 0)
	{
		NSInteger counter = 0;
        
		
        for (int i=0; i<[self.arrSearchContactList count]; i++)
		{
            
			NSString *idStr=[[self.arrSearchContactList objectAtIndex:counter]valueForKey:@"user_id"];
			NSString *memberImage_str;
			NSString *membername_str;
            NSString *requestStatus;
            
            if ([[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"user_name"]==nil || [[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"user_name"]== (NSString*)[NSNull null]) {
                
                membername_str=@"";
            }
            else
            {
                membername_str=[[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"user_name"];
                
            }
            if ([[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"user_image"]==nil || [[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"user_image"]==(NSString*)[NSNull null]) {
                
                memberImage_str=@"";
            }
            else
            {
                memberImage_str=[[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"user_image"];
                
            }
            if ([[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"request_status"]==nil || [[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"request_status"]==(NSString*)[NSNull null]) {
                
                requestStatus=@"";
            }
            else
            {
                requestStatus=[[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"request_status"];
                
            }
            
            NSString *intro=@"";
            
            if ([[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"intro"]==nil || [[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"intro"]==(NSString*)[NSNull null]) {
                
                intro=@"";
            }
            else
            {
                intro=[[self.arrSearchContactList objectAtIndex:counter] valueForKey:@"intro"];
                
            }

            NSLog(@"%@",memberImage_str);
            
            NSRange r=[membername_str rangeOfString:searchTerm options:NSCaseInsensitiveSearch];
            
            NSLog(@"%@",memberImage_str);
            
			if(r.location != NSNotFound)
			{
                NSString *deleteId=[[self.arrSearchContactList objectAtIndex:counter]objectForKey:@"id"];
                
                
                [self.arrContactList addObject:[NSDictionary dictionaryWithObjectsAndKeys:membername_str,@"user_name",idStr,@"user_id",memberImage_str,@"user_image",deleteId,@"id",requestStatus,@"request_status",intro,@"intro",nil]];
                
                //NSLog(@"%@",self.arrContactList);
				
			}
            
			counter++;
		}
        NSLog(@"%@",self.arrContactList);
        
        NSLog(@"%d",[self.arrContactList count]);
        
        if ([self.arrContactList count]==0) {
            
            checkIndex=FALSE;
            [lblNoResult setHidden:FALSE];
        }
        else
        {
            checkIndex=TRUE;
            [lblNoResult setHidden:TRUE];
        }
        [gArrContactList addObjectsFromArray:self.arrContactList];

        [self createSectionList:self.arrContactList];
        
	}
    else
    {
        [lblNoResult setHidden:TRUE];
        checkIndex=TRUE;
        [searchBar resignFirstResponder];
        
        [gArrSearchContactList addObjectsFromArray:self.arrSearchContactList];

        [self createSectionList:self.arrSearchContactList];
    }
	
    [self.tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}
#pragma mark...........
#pragma calculate size methods

- (CGSize)sizeForText:(NSString*)text
{
	CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(getFloatX(WrapWidth),9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;
    
	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;
    
	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;
    
	//bubbleSize.width += HorzPadding*2;
	bubbleSize.width = 240;
	bubbleSize.height +=VertPadding*2;
    
	return bubbleSize;
}

#pragma Mark--------
#pragma Webservice delegate

-(void)ContactListInvocationDidFinish:(ContactListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrContactList removeAllObjects];
    [self.arrSearchContactList removeAllObjects];
    
    [gArrSearchContactList removeAllObjects];
    [gArrContactList removeAllObjects];
    
    NSLog(@"%@",msg);
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        if ([result count]>0) {
            
            NSMutableArray *responseArray=[result objectForKey:@"contacts"];
            
            NSSortDescriptor *firstDescriptor =[[[NSSortDescriptor alloc] initWithKey:@"user_name"
                                                                           ascending:YES
                                                                            selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
            
            NSArray *descriptors = [NSArray arrayWithObjects: firstDescriptor, nil];
            NSArray *sortedArray = [responseArray sortedArrayUsingDescriptors:descriptors];
            
            
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
        
            /*   [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];
            [self.arrSearchContactList addObjectsFromArray:sortedArray];*/

            gArrSearchContactList=[[NSMutableArray alloc] init];
            [gArrSearchContactList addObjectsFromArray:self.arrSearchContactList];
           
            NSLog(@"%@",sortedArray);
            NSLog(@"%@",responseArray);
            NSLog(@"%@",self.arrSearchContactList);
        }
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    if ([self.arrSearchContactList count]>0) {
        
        [EditButton setEnabled:TRUE];
    }
    else
    {
        self.editing=FALSE;
        [EditButton setTitle:@"Edit" forState:UIControlStateNormal];
		[self.tblView setEditing:NO animated:NO];
        [EditButton setEnabled:FALSE];
        
    }
    
    [self createSectionList:self.arrSearchContactList];
    
    if ([self.arrContactList count]>0) {
        
        [lblNoResult setHidden:TRUE];
    }
    else
    {
        [lblNoResult setHidden:FALSE];
    }

    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)SendPhoneListInvocationDidFinish:(SendPhoneListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrRecomandedList removeAllObjects];
    
    if ([result count]>0) {
        
        NSMutableArray *responseArray=[result objectForKey:@"ContactList"];
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"id",@"image",@"username",@"phone",@"email",@"intro",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                NSString *userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"id"]];
                NSString * userImage=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"image"]];
                NSString * userName=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"username"]];                
                NSString *phoneNo=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"phone"]];

                NSString *status=@"0";
                
                [self.arrRecomandedList addObject:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id",userName,@"user_name",userImage,@"user_image",phoneNo,@"phone", status,@"status",nil]];
                
            }
            
            gArrRecomandedList=[[NSMutableArray alloc] init];
            [gArrRecomandedList addObjectsFromArray:self.arrRecomandedList];
            
            [arrOfResponseField release];
        }
        
    }
    moveTabG=FALSE;
    
}
-(void)DeleteContactInvocationDidFinish:(DeleteContactInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    else
    {
        [service ContactListInvocation:gUserId delegate:self];
        
    }
    
}
-(void)AcceptRejectFriendRequestInvocationDidFinish:(AcceptRejectFriendRequestInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    else
    {
        [service ContactListInvocation:gUserId delegate:self];
        
    }
}
#pragma mark ------------Delegate-----------------
#pragma mark Sqlite method


-(void)viewWillDisappear:(BOOL)animated
{
    
   
        checkPN=@"NO";
        [searchBar resignFirstResponder];
        
        service=nil;
        [objImageCache cancelDownload];
        objImageCache=nil;
        [searchBar resignFirstResponder];
        tblView.delegate=nil;
        tblView.dataSource=nil;
  
}
- (void)viewDidUnload
{
    _arrRecomandedList=nil;
    _arrContactList=nil;
    _arrSearchContactList=nil;
    self.tblView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrRecomandedList release];
    [_arrContactList release];
    [_arrSearchContactList release];
    self.tblView=nil;

     [super dealloc];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
