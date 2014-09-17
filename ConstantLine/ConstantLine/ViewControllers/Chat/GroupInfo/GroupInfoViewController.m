//
//  GroupInfoViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "GroupDetailData.h"
#import "ManageGroupViewController.h"
#import "KickOffMemberViewController.h"
#import "AddMemberInGroupViewController.h"
#import "UIImageExtras.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import "DisplayMoreIntroViewController.h"
#import <Twitter/Twitter.h>
#import "FriendProfileViewController.h"

//static NSString* kAppId = @"833209056698618";
static NSString* kAppId = @"639892319392066";

@implementation GroupInfoViewController

@synthesize tblView,groupId,groupOwnerId,privilageStatus,threadId,userIds,groupType,transactionId,joinStatus,subscriptionStatus,kickOutStatus,actionSheetView,arrGroupMemberList,specialStatus,arrImageAudioPath;

@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize posting = _posting;
@synthesize fbUserDetails,FBUserID,FBUserName, FBToken,facebook;

@synthesize strTransactionId,productId,productName,productPrice;

@synthesize arrGroupDetailData=_arrGroupDetailData;

static NSString        *ALERT_TITLE            = @"Purchase Upgrade";

SKProductsRequest *request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.arrGroupDetailData=[[NSMutableArray alloc] init];
    self.arrGroupMemberList=[[NSMutableArray alloc] init];
    
    font = [UIFont fontWithName:ARIALFONT_BOLD size:15.0];
    
    VertPadding = 4;       // additional padding around the edges
    HorzPadding = 4;
    
    TextLeftMargin = 17;   // insets for the text
    TextRightMargin = 15;
    TextTopMargin = 10;
    TextBottomMargin = 11;
    
    MinBubbleWidth = 50;   // minimum width of the bubble
    MinBubbleHeight = 40;  // minimum height of the bubble
    
    WrapWidth = 115;
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Info"];
    
    // Do any additional setup after loading the view from its nib.
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 568)];
            
        }
        else
        {
            
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 568-IPHONE_FIVE_FACTOR)];
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 480+IPHONE_FIVE_FACTOR-10)];
            
            
        }
        else
        {
            
            [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 480-10)];
            
            
            
        }
        
    }
    
    desc=@"Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Shweta Description Description Description Description Description Description Description Description Description Description Description Description Shalu";
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    [self.tblView setContentOffset:CGPointMake(0, 0)];
    
    if(status==0)
    {
        moveTabG=TRUE;
        if (service!=nil) {
            
            service=nil;
        }
        if (objImageCache!=nil) {
            
            objImageCache=nil;
        }
        objImageCache=[[ImageCache alloc] init];
        objImageCache.delegate=self;
        
        tblView.delegate=self;
        tblView.dataSource=self;
        
        service=[[ConstantLineServices alloc] init];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service GroupDetailInvocation:gUserId groupId:self.groupId delegate:self];
        
    }
}
#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    if ([self.arrGroupDetailData count]>0) {
        
        GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
        
        if ([data.groupType isEqualToString:@"1"]) {
            
            rowCount=1;
        }
        else
        {
            if ([self.joinStatus isEqualToString:@"0"]) {
                
                rowCount=2;
            }
            else
            {
                rowCount=3;
            }
            
        }
        
        float noArr=[self.arrGroupMemberList count];
        float row=(noArr/4);
        
        rowCount=rowCount+ceil(row);
        
    }
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    if ([self.arrGroupDetailData count]>0) {
        
        GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
        
        if ([data.groupType isEqualToString:@"1"]) {
            
            if (indexPath.row==0) {
                
                height=330;
                
            }
            else
            {
                height=90;
            }
        }
        else
        {
            if (indexPath.row==0) {
                
                NSString *text=@"";
                text= getStringAfterTriming(data.groupIntro);
                CGSize s = [text sizeWithFont:font constrainedToSize:CGSizeMake(271,130000)lineBreakMode:NSLineBreakByWordWrapping];
                
                height=s.height;
                
                height=height+130;
                
            }
            
            else if(indexPath.row==1)
            {
                if ([self.joinStatus isEqualToString:@"0"]) {
                    
                    
                    if ([data.groupCloseStatus isEqualToString:@"1"]) {
                        
                        height=200;

                    }
                    else
                    {
                        height=300;
 
                    }
                    
                }
                else
                {
                    height=200;
                    
                }
            }
            
            else if(indexPath.row==2)
            {
                if ([self.joinStatus isEqualToString:@"0"]) {
                    
                    height=90;
                    
                }
                else
                {
                    if ([gUserId isEqualToString:self.groupOwnerId]) {
                        
                        height=242;
                    }
                    else if ([self.privilageStatus isEqualToString:@"1"])
                    {
                        height=405;
                    }
                    else
                    {
                        if ([self.subscriptionStatus isEqualToString:@"1"] || [self.subscriptionStatus isEqualToString:@"2"]) {
                            
                            height=353;
                            
                        }
                        else
                        {
                            height= 320;
                        }
                    }
                    
                }
                
                
            }
            else
            {
                height=90;
            }
            
        }
        
    }
    
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    //static NSString *cellIdentifier=@"Cell";
    static NSString *secondCellIdentifier=@"SecondCell";
    static NSString *ownerCellIdentifier=@"OwnerCell";
    static NSString *userCellIdentifier=@"UserCell";
    static NSString *firstDetailCellIdentifier=@"firstDetailCell";
    static NSString *userPrivateIdentifier=@"firstDetailCell";
    static NSString *ownerPrivateIdentifier=@"firstDetailCell";
    static NSString *groupMemberIdentifier=@"groupMemberCell";
    
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    if ([data.groupType isEqualToString:@"1"]) {
        
        if (indexPath.row==0) {
            
            if ([gUserId isEqualToString:self.groupOwnerId]) {
                
                ownerPrivateCell = (GroupInfoOwnerPrivateTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:ownerPrivateIdentifier];
                
                
                if (Nil == ownerPrivateCell)
                {
                    ownerPrivateCell = [GroupInfoOwnerPrivateTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                
                ownerPrivateCell.accessoryType = UITableViewCellAccessoryNone;
                ownerPrivateCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                ownerPrivateCell.lblTitle.text=data.groupTitle;
                ownerPrivateCell.lblMemberCount.text=data.groupMember;
                
                NSString *imageurl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.groupImage];
                
                if (data.groupImage==nil || data.groupImage==(NSString *)[NSNull null] || [data.groupImage isEqualToString:@""]) {
                    
                    
                    
                    [ownerPrivateCell.imgView setImage:[UIImage imageNamed:@"group_logo.png"]];
                    
                }
                else
                {
                    
                    NSLog(@"%@",data.groupImage);
                    
                    if (imageurl && [imageurl length] > 0) {
                        
                        UIImage *img = [objImageCache iconForUrl:imageurl];
                        
                        if (img == Nil) {
                            
                            CGSize kImgSize_1;
                            if ([[UIScreen mainScreen] scale] == 1.0)
                            {
                                kImgSize_1=CGSizeMake(70, 70);
                            }
                            else{
                                kImgSize_1=CGSizeMake(70, 70);
                            }
                            
                            [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:indexPath];
                            
                            
                        }
                        
                        else {
                            
                            [ownerPrivateCell.imgView setImage:img];
                        }
                        
                    }
                    
                    
                    
                }
                cell=ownerPrivateCell;
                
            }
            else{
                userPrivateCell = (GroupInfoUserPrivateTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:userCellIdentifier];
                
                if (Nil == userPrivateCell)
                {
                    userPrivateCell = [GroupInfoUserPrivateTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                
                userPrivateCell.accessoryType = UITableViewCellAccessoryNone;
                userPrivateCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
                userPrivateCell.lblTitle.text=data.groupTitle;
                userPrivateCell.lblMemberCount.text=data.groupMember;
                
                NSString *imageurl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.groupImage];
                
                if (data.groupImage==nil || data.groupImage==(NSString *)[NSNull null] || [data.groupImage isEqualToString:@""]) {
                    
                    [userPrivateCell.imgView setImage:[UIImage imageNamed:@"group_logo.png"]];
                    
                }
                else
                {
                    
                    NSLog(@"%@",data.groupImage);
                    
                    if (imageurl && [imageurl length] > 0) {
                        
                        UIImage *img = [objImageCache iconForUrl:imageurl];
                        
                        if (img == Nil) {
                            
                            CGSize kImgSize_1;
                            if ([[UIScreen mainScreen] scale] == 1.0)
                            {
                                kImgSize_1=CGSizeMake(70, 70);
                            }
                            else{
                                kImgSize_1=CGSizeMake(70, 70);
                            }
                            
                            [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:indexPath];
                            
                            
                        }
                        
                        else {
                            
                            [userPrivateCell.imgView setImage:img];
                        }
                        
                    }
                    
                    
                    
                }
                cell=userPrivateCell;
                
            }
            
        }
        else
        {
            groupMemberCell = (GroupMemberTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:groupMemberIdentifier];
            
            
            if (Nil == groupMemberCell)
            {
                groupMemberCell = [GroupMemberTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            groupMemberCell.accessoryType = UITableViewCellAccessoryNone;
            groupMemberCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            NSUInteger index=indexPath.row-1;
            NSUInteger rowIndex = index*4;
            
            NSLog(@"%lu",(unsigned long)rowIndex);
            NSLog(@"%ld",(long)indexPath.row);
            
            if(rowIndex < [self.arrGroupMemberList count])
            {
                NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
                
                NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
                
                [groupMemberCell.btnImage setTitle:userId forState:UIControlStateReserved];
                
                [groupMemberCell.btnImage setTitle:userName forState:UIControlStateApplication];
                
                NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
                
                NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
                
                if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
                    
                    [groupMemberCell.btnImage setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
                else
                {
                    
                    UIImage *img = [objImageCache iconForUrl:fullUserImage];
                    
                    if (img == Nil) {
                        
                        CGSize kImgSize_1;
                        
                        kImgSize_1=CGSizeMake(130, 130);
                        
                        [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                        
                        
                    }
                    
                    else {
                        
                        [groupMemberCell.btnImage setBackgroundImage:img forState:UIControlStateNormal];
                    }
                    
                }
                
                rowIndex++;
                
            }
            if(rowIndex < [self.arrGroupMemberList count])
            {
                NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
                
                NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
                
                [groupMemberCell.btnImage1 setTitle:userId forState:UIControlStateReserved];
                
                [groupMemberCell.btnImage1 setTitle:userName forState:UIControlStateApplication];
                
                NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
                
                NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
                
                
                if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
                    
                    [groupMemberCell.btnImage1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
                else
                {
                    
                    UIImage *img = [objImageCache iconForUrl:fullUserImage];
                    
                    if (img == Nil) {
                        
                        CGSize kImgSize_1;
                        
                        kImgSize_1=CGSizeMake(130, 130);
                        
                        [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                        
                        
                    }
                    
                    else {
                        
                        [groupMemberCell.btnImage1 setBackgroundImage:img forState:UIControlStateNormal];
                    }
                    
                }
                
                rowIndex++;
                
            }
            else
            {
                [groupMemberCell.btnImage1 setHidden:TRUE];
                
            }
            if(rowIndex < [self.arrGroupMemberList count])
            {
                NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
                
                NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
                
                [groupMemberCell.btnImage2 setTitle:userId forState:UIControlStateReserved];
                
                [groupMemberCell.btnImage2 setTitle:userName forState:UIControlStateApplication];
                
                NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
                
                NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
                
                if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
                    
                    [groupMemberCell.btnImage2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
                else
                {
                    
                    UIImage *img = [objImageCache iconForUrl:fullUserImage];
                    
                    if (img == Nil) {
                        
                        CGSize kImgSize_1;
                        
                        kImgSize_1=CGSizeMake(130, 130);
                        
                        [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                        
                        
                    }
                    
                    else {
                        
                        [groupMemberCell.btnImage2 setBackgroundImage:img forState:UIControlStateNormal];
                    }
                    
                }
                
                rowIndex++;
                
            }
            else
            {
                [groupMemberCell.btnImage2 setHidden:TRUE];
                
            }
            if(rowIndex < [self.arrGroupMemberList count])
            {
                NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
                
                NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
                
                [groupMemberCell.btnImage3 setTitle:userId forState:UIControlStateReserved];
                
                [groupMemberCell.btnImage3 setTitle:userName forState:UIControlStateApplication];
                
                NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
                
                NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
                
                if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
                    
                    [groupMemberCell.btnImage3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
                else
                {
                    
                    UIImage *img = [objImageCache iconForUrl:fullUserImage];
                    
                    if (img == Nil) {
                        
                        CGSize kImgSize_1;
                        
                        kImgSize_1=CGSizeMake(130, 130);
                        
                        [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                        
                        
                    }
                    
                    else {
                        
                        [groupMemberCell.btnImage3 setBackgroundImage:img forState:UIControlStateNormal];
                    }
                    
                }
                
                rowIndex++;
                
            }
            else
            {
                [groupMemberCell.btnImage3 setHidden:TRUE];
                
            }
            cell=groupMemberCell;
            
        }
        
        
    }
    else{
        if (indexPath.row==0) {
            
            firstCell = (GroupInfoFirstTableViewCellController*)[self.tblView dequeueReusableCellWithIdentifier:userPrivateIdentifier];
            
            if (Nil == firstCell)
            {
                firstCell = [GroupInfoFirstTableViewCellController createTextRowWithOwner:self withDelegate:self];
            }
            
            
            firstCell.accessoryType = UITableViewCellAccessoryNone;
            firstCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            firstCell.lblGroupDescription.numberOfLines=0;
            firstCell.lblGroupDescription.lineBreakMode=NSLineBreakByWordWrapping;
            
            
            if ([data.groupTotalVote isEqualToString:@"0"]) {
                
                [firstCell.lblVoteCount setHidden:TRUE];
            }
            else
            {
                [firstCell.lblVoteCount setHidden:FALSE];
                
                firstCell.lblVoteCount.text=[NSString stringWithFormat:@"(%@)",data.groupTotalVote];
                
            }
            
            
            firstCell.lblGroupDescription.text= data.groupIntro;
            
            int hgt;
            
            NSString *text=@"";
            text= getStringAfterTriming(data.groupIntro);
            CGSize s = [text sizeWithFont:font constrainedToSize:CGSizeMake(271,130000)lineBreakMode:NSLineBreakByWordWrapping];
            
            hgt=s.height;
            
            [firstCell.lblGroupDescription setFrame:CGRectMake(firstCell.lblGroupDescription.frame.origin.x,firstCell.lblGroupDescription.frame.origin.y,firstCell.lblGroupDescription.frame.size.width,hgt+20)];
            
            
            // [firstCell.lblGroupDescription setBackgroundColor:[UIColor clearColor]];
            
            
            
            
            if (![self.groupOwnerId isEqualToString:gUserId]) {
                
                [firstCell.lblTapTo setHidden:TRUE];
                [firstCell.lblUploadImage setHidden:TRUE];
                
            }
            firstCell.lblGroupName.text= [data.groupTitle capitalizedString];
            
            
            [self CreateRatingVIew:firstCell AtIndex:indexPath];
            
            NSString *imageurl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.groupImage];
            
            if (data.groupImage==nil || data.groupImage==(NSString *)[NSNull null] || [data.groupImage isEqualToString:@""]) {
                
                if ([self.groupOwnerId isEqualToString:gUserId]) {
                    
                    [firstCell.lblTapTo setHidden:FALSE];
                    [firstCell.lblUploadImage setHidden:FALSE];
                    
                }
                
                [firstCell.imgView setImage:[UIImage imageNamed:@"group_logo.png"]];
                
            }
            else
            {
                [firstCell.lblTapTo setHidden:TRUE];
                [firstCell.lblUploadImage setHidden:TRUE];
                NSLog(@"%@",data.groupImage);
                
                if (imageurl && [imageurl length] > 0) {
                    
                    UIImage *img = [objImageCache iconForUrl:imageurl];
                    
                    if (img == Nil) {
                        
                        CGSize kImgSize_1;
                        if ([[UIScreen mainScreen] scale] == 1.0)
                        {
                            kImgSize_1=CGSizeMake(70, 70);
                        }
                        else{
                            kImgSize_1=CGSizeMake(70, 70);
                        }
                        
                        [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:indexPath];
                        
                        
                    }
                    
                    else {
                        
                        [firstCell.imgView setImage:img];
                    }
                    
                }
                
                
                
            }
            
            cell= firstCell;
        }
        
        else if(indexPath.row==1)
        {
            firstDetailCell = (GroupInfoFirstDetailTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:firstDetailCellIdentifier];
            
            
            if (Nil == firstDetailCell)
            {
                firstDetailCell = [GroupInfoFirstDetailTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            [firstDetailCell setBackgroundColor:[UIColor clearColor]];
            
            
            firstDetailCell.accessoryType = UITableViewCellAccessoryNone;
            firstDetailCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            firstDetailCell.lblGroupCode.text=data.groupCode;
            
            if ([data.groupCharge isEqualToString:@""]) {
                
                firstDetailCell.lblGroupCharge.text= @"FREE";
                
            }
            else{
                if ([data.groupperiodType isEqualToString:@"1"]) {
                    NSString *chargeStr=[NSString stringWithFormat:@"%@%@%@%@%@",data.groupTrialPeriod,@" MONTH TRIAL,",@"$",data.groupCharge,@" MONTHLY FEE"];
                    firstDetailCell.lblGroupCharge.text= chargeStr;
                }
                else{
                    NSString *chargeStr=[NSString stringWithFormat:@"%@%@%@%@%@",data.groupTrialPeriod,@" MONTH TRIAL,",@"$",data.groupCharge,@" ANNUAL FEE"];
                    firstDetailCell.lblGroupCharge.text= chargeStr ;
                }
            }
            
            if ([self.joinStatus isEqualToString:@"0"]) {
                
                if ([data.groupCloseStatus isEqualToString:@"1"]){
                    
                    [firstDetailCell.btnJoin setHidden:TRUE];
                    [firstDetailCell.btnShare setHidden:TRUE];
                    
                }
                else
                {
                    [firstDetailCell.btnJoin setHidden:FALSE];
                    [firstDetailCell.btnShare setHidden:FALSE];
                    
                }
                
            }
            else
            {
                [firstDetailCell.btnJoin setHidden:TRUE];
                [firstDetailCell.btnShare setHidden:TRUE];
                
            }
            
            firstDetailCell.lblConnectedMember.text= [data.groupMember capitalizedString];
            
            cell= firstDetailCell;
        }
        else if(indexPath.row==2)
        {
            if ([self.joinStatus isEqualToString:@"0"]) {
                
                groupMemberCell = (GroupMemberTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:groupMemberIdentifier];
                
                
                if (Nil == groupMemberCell)
                {
                    groupMemberCell = [GroupMemberTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                
                groupMemberCell.accessoryType = UITableViewCellAccessoryNone;
                groupMemberCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                [self CreateGroupMemberVIew:groupMemberCell AtIndex:indexPath];
                
                cell=groupMemberCell;
            }
            else
            {
                if ([gUserId isEqualToString:self.groupOwnerId]) {
                    
                    ownerCell = (GroupInfoOwnerTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:ownerCellIdentifier];
                    
                    if (Nil == ownerCell)
                    {
                        ownerCell = [GroupInfoOwnerTableViewCell createTextRowWithOwner:self withDelegate:self];
                    }
                    [ownerCell setBackgroundColor:[UIColor clearColor]];
                    
                    
                    ownerCell.accessoryType = UITableViewCellAccessoryNone;
                    ownerCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    cell=ownerCell;
                    
                    
                }
                
                else if ([self.privilageStatus isEqualToString:@"1"])
                {
                    secondCell = (GroupInfoSecondTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:secondCellIdentifier];
                    
                    if (Nil == secondCell)
                    {
                        secondCell = [GroupInfoSecondTableViewCell createTextRowWithOwner:self withDelegate:self];
                    }
                    
                    if (data.groupCharge==nil || data.groupCharge==(NSString*)[NSNull null] || [data.groupCharge isEqualToString:@""]) {
                        
                        [secondCell.btnUnSubscribe setHidden:TRUE];
                    }
                    else{
                        if ([self.subscriptionStatus isEqualToString:@"1"]) {
                            
                            [secondCell.btnUnSubscribe setTitle:@"UnSubscribe" forState:UIControlStateNormal];
                            
                            [secondCell.btnUnSubscribe setHidden:FALSE];
                        }
                        else if([self.subscriptionStatus isEqualToString:@"2"]){
                            
                            [secondCell.btnUnSubscribe setTitle:@"Subscribe" forState:UIControlStateNormal];
                            
                            [secondCell.btnUnSubscribe setHidden:FALSE];
                            
                        }
                        else
                        {
                            [secondCell.btnUnSubscribe setHidden:TRUE];
                            
                        }
                        
                    }
                    
                    
                    
                    [secondCell setBackgroundColor:[UIColor clearColor]];
                    
                    secondCell.accessoryType = UITableViewCellAccessoryNone;
                    secondCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    [self CreateUserGroupPrivilegeRatingVIew:secondCell AtIndex:indexPath];
                    [self CreateUserOwnerPrivilegeRatingVIew:secondCell AtIndex:indexPath];
                    
                    cell=secondCell;
                    
                }
                else
                {
                    userCell = (GroupInfoUserTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:userCellIdentifier];
                    
                    if (Nil == userCell)
                    {
                        userCell = [GroupInfoUserTableViewCell createTextRowWithOwner:self withDelegate:self];
                    }
                    
                    if (data.groupCharge==nil || data.groupCharge==(NSString*)[NSNull null] || [data.groupCharge isEqualToString:@""]) {
                        
                        [userCell.btnUnSubscribe setHidden:TRUE];
                    }
                    else{
                        
                        if ([self.subscriptionStatus isEqualToString:@"1"]) {
                            
                            [userCell.btnUnSubscribe setTitle:@"UnSubscribe" forState:UIControlStateNormal];
                            
                            [userCell.btnUnSubscribe setHidden:FALSE];
                        }
                        else if([self.subscriptionStatus isEqualToString:@"2"]){
                            
                            [userCell.btnUnSubscribe setTitle:@"Subscribe" forState:UIControlStateNormal];
                            
                            [userCell.btnUnSubscribe setHidden:FALSE];
                            
                        }
                        else
                        {
                            [userCell.btnUnSubscribe setHidden:TRUE];
                            
                        }
                        
                        
                    }
                    [userCell setBackgroundColor:[UIColor clearColor]];
                    
                    userCell.accessoryType = UITableViewCellAccessoryNone;
                    userCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    [self CreateUserGroupRatingVIew:userCell AtIndex:indexPath];
                    [self CreateUserOwnerRatingVIew:userCell AtIndex:indexPath];
                    
                    cell=userCell;
                    
                }
                
            }
            
            
        }
        else
        {
            groupMemberCell = (GroupMemberTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:groupMemberIdentifier];
            
            
            if (Nil == groupMemberCell)
            {
                groupMemberCell = [GroupMemberTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            groupMemberCell.accessoryType = UITableViewCellAccessoryNone;
            groupMemberCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            [self CreateGroupMemberVIew:groupMemberCell AtIndex:indexPath];
            
            cell=groupMemberCell;
            
        }
        
        
    }
    
    return cell;
}
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}
-(void)CreateGroupMemberVIew:(GroupMemberTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    NSUInteger index=0;
    
    if ([self.joinStatus isEqualToString:@"0"]) {
        
        index=indexPath.row-2;
        
    }
    else
    {
        index=indexPath.row-3;
    }
    
    
    NSUInteger rowIndex = index*4;
    
    NSLog(@"%lu",(unsigned long)rowIndex);
    NSLog(@"%ld",(long)indexPath.row);
    
    if(rowIndex < [self.arrGroupMemberList count])
    {
        NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
        
        NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
        
        [groupMemberCell.btnImage setTitle:userId forState:UIControlStateReserved];
        
        [groupMemberCell.btnImage setTitle:userName forState:UIControlStateApplication];
        
        NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
        
        NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
        
        if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
            
            [groupMemberCell.btnImage setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else
        {
            
            UIImage *img = [objImageCache iconForUrl:fullUserImage];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                
                kImgSize_1=CGSizeMake(130, 130);
                
                [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                
                
            }
            
            else {
                
                [groupMemberCell.btnImage setBackgroundImage:img forState:UIControlStateNormal];
            }
            
        }
        
        rowIndex++;
        
    }
    if(rowIndex < [self.arrGroupMemberList count])
    {
        NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
        
        NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
        
        [groupMemberCell.btnImage1 setTitle:userId forState:UIControlStateReserved];
        
        [groupMemberCell.btnImage1 setTitle:userName forState:UIControlStateApplication];
        
        NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
        
        NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
        
        
        if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
            
            [groupMemberCell.btnImage1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else
        {
            
            UIImage *img = [objImageCache iconForUrl:fullUserImage];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                
                kImgSize_1=CGSizeMake(130, 130);
                
                [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                
                
            }
            
            else {
                
                [groupMemberCell.btnImage1 setBackgroundImage:img forState:UIControlStateNormal];
            }
            
        }
        
        rowIndex++;
        
    }
    else
    {
        [groupMemberCell.btnImage1 setHidden:TRUE];
        
    }
    if(rowIndex < [self.arrGroupMemberList count])
    {
        NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
        
        NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
        
        [groupMemberCell.btnImage2 setTitle:userId forState:UIControlStateReserved];
        
        [groupMemberCell.btnImage2 setTitle:userName forState:UIControlStateApplication];
        
        NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
        
        NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
        
        if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
            
            [groupMemberCell.btnImage2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else
        {
            
            UIImage *img = [objImageCache iconForUrl:fullUserImage];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                
                kImgSize_1=CGSizeMake(130, 130);
                
                [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                
                
            }
            
            else {
                
                [groupMemberCell.btnImage2 setBackgroundImage:img forState:UIControlStateNormal];
            }
            
        }
        
        rowIndex++;
        
    }
    else
    {
        [groupMemberCell.btnImage2 setHidden:TRUE];
        
    }
    if(rowIndex < [self.arrGroupMemberList count])
    {
        NSString *userId=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_id"];
        
        NSString *userName=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"display_name"];
        
        [groupMemberCell.btnImage3 setTitle:userId forState:UIControlStateReserved];
        
        [groupMemberCell.btnImage3 setTitle:userName forState:UIControlStateApplication];
        
        NSString *userImage=[[self.arrGroupMemberList objectAtIndex:rowIndex] objectForKey:@"user_image"];
        
        NSString *fullUserImage=[NSString stringWithFormat:@"%@%@",gOriginalImageUrl,userImage];
        
        if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
            
            [groupMemberCell.btnImage3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else
        {
            
            UIImage *img = [objImageCache iconForUrl:fullUserImage];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                
                kImgSize_1=CGSizeMake(130, 130);
                
                [objImageCache startDownloadForUrl:fullUserImage withSize:kImgSize_1 forIndexPath:indexPath];
                
                
            }
            
            else {
                
                [groupMemberCell.btnImage3 setBackgroundImage:img forState:UIControlStateNormal];
            }
            
        }
        
        rowIndex++;
        
    }
    else
    {
        [groupMemberCell.btnImage3 setHidden:TRUE];
        
    }
    
}
-(void)CreateRatingVIew:(GroupInfoFirstTableViewCellController *)customCell AtIndex:(NSIndexPath *)indexPath;
{
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:indexPath.row];
    
    if ([data.groupRating isEqualToString:@""] || [data.groupRating isEqualToString:@"0"]) {
        
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([data.groupRating isEqualToString:@"1"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([data.groupRating isEqualToString:@"2"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupRating isEqualToString:@"3"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupRating isEqualToString:@"4"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupRating isEqualToString:@"5"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}
-(void)CreateUserGroupRatingVIew:(GroupInfoUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    NSLog(@"CreateUserGroupRatingVIew %@",data.groupUserRating);
    
    if ([data.groupUserRating isEqualToString:@""] || [data.groupUserRating isEqualToString:@"0"]) {
        
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([data.groupUserRating isEqualToString:@"1"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([data.groupUserRating isEqualToString:@"2"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserRating isEqualToString:@"3"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserRating isEqualToString:@"4"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserRating isEqualToString:@"5"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}

-(void)CreateUserOwnerRatingVIew:(GroupInfoUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    NSLog(@"CreateUserOwnerRatingVIew %@",data.groupUserOwnerRating);
    
    if ([data.groupUserOwnerRating isEqualToString:@""] || [data.groupUserOwnerRating isEqualToString:@"0"]) {
        
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([data.groupUserOwnerRating isEqualToString:@"1"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([data.groupUserOwnerRating isEqualToString:@"2"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserOwnerRating isEqualToString:@"3"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserOwnerRating isEqualToString:@"4"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserOwnerRating isEqualToString:@"5"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}


-(void)CreateUserGroupPrivilegeRatingVIew:(GroupInfoSecondTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    NSLog(@"CreateUserGroupRatingVIew %@",data.groupUserRating);
    
    if ([data.groupUserRating isEqualToString:@""] || [data.groupUserRating isEqualToString:@"0"]) {
        
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([data.groupUserRating isEqualToString:@"1"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([data.groupUserRating isEqualToString:@"2"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserRating isEqualToString:@"3"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserRating isEqualToString:@"4"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserRating isEqualToString:@"5"])
    {
        [customCell.btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}

-(void)CreateUserOwnerPrivilegeRatingVIew:(GroupInfoSecondTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    NSLog(@"CreateUserOwnerRatingVIew %@",data.groupUserOwnerRating);
    
    if ([data.groupUserOwnerRating isEqualToString:@""] || [data.groupUserOwnerRating isEqualToString:@"0"]) {
        
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([data.groupUserOwnerRating isEqualToString:@"1"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([data.groupUserOwnerRating isEqualToString:@"2"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserOwnerRating isEqualToString:@"3"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserOwnerRating isEqualToString:@"4"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([data.groupUserOwnerRating isEqualToString:@"5"])
    {
        [customCell.btnOwnerRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [customCell.btnOwnerRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    service=nil;
    [objImageCache cancelDownload];
    objImageCache=nil;
    tblView.delegate=nil;
    tblView.dataSource=nil;
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
    
	bubbleSize.width = 290;
	bubbleSize.height +=VertPadding*2;
    
	return bubbleSize;
}
#pragma
#pragma Tableview cell IBAction methods

-(void)ManageButtonClick:(GroupInfoSecondTableViewCell*)cellValue
{
    ManageGroupViewController *objManageGroupViewController;
    
    objManageGroupViewController=[[ManageGroupViewController alloc] initWithNibName:@"ManageGroupViewController" bundle:nil];
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    objManageGroupViewController.groupId=self.groupId;
    objManageGroupViewController.ownerId=self.groupOwnerId;
    objManageGroupViewController.userIds=self.userIds;
    objManageGroupViewController.closeStatus=data.groupCloseStatus;
    objManageGroupViewController.threadId=self.threadId;
    
    [self.navigationController pushViewController:objManageGroupViewController animated:YES];
    [objManageGroupViewController release];
}
-(void)ButtonShareClick:(GroupInfoFirstDetailTableViewCell*)cellValue
{
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
-(void)ShareButtonClick:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            /*shareAlert=[[UIAlertView alloc] initWithTitle:Nil message:@"Share group" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Share on Wellconnected", @"Share on Facebook", nil];
             [shareAlert show];
             [shareAlert release];*/
            
            /* UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
             delegate:self
             cancelButtonTitle:@"Cancel"
             destructiveButtonTitle:nil
             otherButtonTitles:@"Share on Wellconnected", @"Share on Facebook", nil];
             actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
             [actionSheet showInView:self.view];*/
            
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
            
            
            // lots of other buttons...
            
            // then right at the end you call the showInView method of your actionsheet, and set its counds based at how tall you need the actionsheet to be, as follows:
            
            [self.actionSheetView showInView:self.view];
            [self.actionSheetView setBounds:CGRectMake(0,0,320, 600)];
            
        }
        
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can share group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    
}
-(void)ShareGroupInfoUserPrivateButtonClick:(GroupInfoUserPrivateTableViewCell*)cellValue
{
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
    
    
    // lots of other buttons...
    
    // then right at the end you call the showInView method of your actionsheet, and set its counds based at how tall you need the actionsheet to be, as follows:
    
    [self.actionSheetView showInView:self.view];
    [self.actionSheetView setBounds:CGRectMake(0,0,320, 600)];
}
-(void)ShareGroupInfoOwnerPrivateButtonClick:(GroupInfoOwnerPrivateTableViewCell*)cellValue
{
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
    
    
    // lots of other buttons...
    
    // then right at the end you call the showInView method of your actionsheet, and set its counds based at how tall you need the actionsheet to be, as follows:
    
    [self.actionSheetView showInView:self.view];
    [self.actionSheetView setBounds:CGRectMake(0,0,320, 600)];
}

-(void)cancelButtonClicked:(id)sender {
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
}
-(IBAction)btnShareWellConnectedPressed:(id)sender
{
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    objAddMemberInGroupViewController =[[AddMemberInGroupViewController alloc] initWithNibName:@"AddMemberInGroupViewController" bundle:nil];
    
    objAddMemberInGroupViewController.checkContactView=@"Share Group";
    objAddMemberInGroupViewController.groupId=self.groupId;
    [self.navigationController pushViewController:objAddMemberInGroupViewController animated:YES];
    
}
-(IBAction)btnShareOnSMSPressed:(id)sender
{
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
	NSString *mailCurrentLink=@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8";
    
    
    NSString *currentTitleStr=[NSString stringWithFormat:@"I thought you would be interested to join this push-to-talk support group: %@.  First, install app WellConnected: ",data.groupTitle];
    
    NSString *postData = [NSString stringWithFormat:@"%@. %@ Then, search group #: %@", currentTitleStr,mailCurrentLink,data.groupCode];
    
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
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
	NSString *mailCurrentLink=@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8";
    
    NSString *currentTitleStr=[NSString stringWithFormat:@"Join this push-to-talk support group: %@ First, install app WellConnected: ",data.groupTitle];
    
    NSString *postData = [NSString stringWithFormat:@"%@ \n %@ Then, search group #: %@", currentTitleStr,mailCurrentLink,data.groupCode];
    
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
	GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    NSString *subject=[NSString stringWithFormat:@"Push-to-talk support group for %@",data.groupTitle];
    
	[picker setSubject:subject];
	NSArray *toRecipients = [NSArray arrayWithObject:@""];
	[picker setToRecipients:toRecipients];
	
	NSString *titleStr=[NSString stringWithFormat:@"I thought you would be interested to join this push-to-talk support group: %@ <br><br> First, install app WellConnected: ",data.groupTitle];
    
	NSString *mailCurrentLink=@"<html><body><a href=\"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8\">https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8</a></body></html>";
    
    NSString *groupCode=[NSString stringWithFormat:@"Then, search group #: %@",data.groupCode];
    
    
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
	GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    NSString *subject=[NSString stringWithFormat:@"Push-to-talk support group for %@",data.groupTitle];
    
	[picker setSubject:subject];
	NSArray *toRecipients = [NSArray arrayWithObject:@""];
	[picker setToRecipients:toRecipients];
	
	NSString *titleStr=[NSString stringWithFormat:@"I thought you would be interested to join this push-to-talk support group: %@ <br><br> First, install app WellConnected: ",data.groupTitle];
    
	NSString *mailCurrentLink=@"<html><body><a href=\"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8\">https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8</a></body></html>";
    
    NSString *groupCode=[NSString stringWithFormat:@"Then, search group #: %@",data.groupCode];
    
    
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
/*- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
 
 [actionSheet setBackgroundColor:[UIColor whiteColor]];
 
 for (UIView *subview in actionSheet.subviews) {
 if ([subview isKindOfClass:[UIButton class]]) {
 UIButton *button = (UIButton *)subview;
 button.titleLabel.textColor = [UIColor whiteColor];
 [button setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
 
 
 }
 }
 
 }*/

-(void)QuitButtonClick:(GroupInfoUserTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            quitAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to quit this group" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [quitAlert show];
            [quitAlert release];
            
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can quit group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
-(void)KickButtonClick:(GroupInfoSecondTableViewCell*)cellValue
{
    
    objKickOffMemberViewController =[[KickOffMemberViewController alloc] initWithNibName:@"KickOffMemberViewController" bundle:nil];
    
    objKickOffMemberViewController.memberIds=self.userIds;
    objKickOffMemberViewController.threadId=self.threadId;
    objKickOffMemberViewController.groupId=self.groupId;
    objKickOffMemberViewController.ownerId=self.groupOwnerId;
    objKickOffMemberViewController.checkView=@"kickoff";
    
    [self.navigationController pushViewController:objKickOffMemberViewController animated:YES];
}

-(void)ClearButtonClick:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            clearAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to clear group chat message" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [clearAlert show];
            [clearAlert release];
            
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can clear group messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)UnsubscribedPrivilageButtonClick:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.subscriptionStatus isEqualToString:@"1"]) {
        
        unsubscribeAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to unsubscribe this group." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [unsubscribeAlert show];
        [unsubscribeAlert release];
    }
    else{
        
        GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
        
        NSString *message=@"You will be charged $";
        
        NSString *msg=[NSString stringWithFormat:@"%@%@%@",message,data.groupCharge,@" each month from your account. Do you want to continue?."];
        
        subscribeAlert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [subscribeAlert show];
        [subscribeAlert release];
    }
    
    
}
-(void)UnsubscribedButtonClick:(GroupInfoUserTableViewCell*)cellValue
{
    if ([self.subscriptionStatus isEqualToString:@"1"]) {
        
        unsubscribeAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to unsubscribe this group." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [unsubscribeAlert show];
        [unsubscribeAlert release];
    }
    else{
        
        GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
        
        NSString *message=@"You will be charged $";
        
        NSString *msg=[NSString stringWithFormat:@"%@%@%@",message,data.groupCharge,@" each month from your account. Do you want to continue?."];
        
        
        subscribeAlert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [subscribeAlert show];
        [subscribeAlert release];
    }
    
}
-(void)ClearUserPrivateButtonClick:(GroupInfoUserPrivateTableViewCell*)cellValu{
    
    clearAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to clear group chat message" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [clearAlert show];
    [clearAlert release];
}
-(void)QuitUserPrivateButtonClick:(GroupInfoUserPrivateTableViewCell*)cellValue
{
    quitAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to quit this group" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [quitAlert show];
    [quitAlert release];
}
-(void)ClearOwnerPrivateButtonClick:(GroupInfoOwnerPrivateTableViewCell*)cellValue
{
    clearAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to clear group chat message" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [clearAlert show];
    [clearAlert release];
}
-(void)KickOutPrivateButtonClick:(GroupInfoOwnerPrivateTableViewCell*)cellValue
{
    objKickOffMemberViewController =[[KickOffMemberViewController alloc] initWithNibName:@"KickOffMemberViewController" bundle:nil];
    
    objKickOffMemberViewController.memberIds=self.userIds;
    objKickOffMemberViewController.threadId=self.threadId;
    objKickOffMemberViewController.groupId=self.groupId;
    objKickOffMemberViewController.ownerId=self.groupOwnerId;
    objKickOffMemberViewController.checkView=@"kickoff";
    
    [self.navigationController pushViewController:objKickOffMemberViewController animated:YES];
    
}
-(void)ButtonJoinClick:(GroupInfoFirstDetailTableViewCell*)cellValue
{
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
        
        if ([data.groupSpecialType isEqualToString:@"1"]) {
            
            
            [service SpecialGroupJoinInvocation:gUserId friendId:self.groupOwnerId groupId:self.groupId delegate:self];
            
        }
        else
        {
            [service JoinGroupInvocation:gUserId friendId:self.groupOwnerId groupId:self.groupId delegate:self];
            
        }
        
        
    }
}

-(void)ratingButonClick1:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingInvocation:gUserId groupId:self.groupId rating:@"1" delegate:self];
                
            }
            
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)ratingButonClick2:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingInvocation:gUserId groupId:self.groupId rating:@"2" delegate:self];
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)ratingButonClick3:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingInvocation:gUserId groupId:self.groupId rating:@"3" delegate:self];
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)ratingButonClick4:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingInvocation:gUserId groupId:self.groupId rating:@"4" delegate:self];
                
            }
            
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)ratingButonClick5:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingInvocation:gUserId groupId:self.groupId rating:@"5" delegate:self];
                
            }
        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)ownerRatingButonClick1:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingOwnerInvocation:gUserId ownerId:self.groupOwnerId rating:@"1" delegate:self];
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
-(void)ownerRatingButonClick2:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingOwnerInvocation:gUserId ownerId:self.groupOwnerId rating:@"2" delegate:self];
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
-(void)ownerRatingButonClick3:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingOwnerInvocation:gUserId ownerId:self.groupOwnerId rating:@"3" delegate:self];
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
-(void)ownerRatingButonClick4:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingOwnerInvocation:gUserId ownerId:self.groupOwnerId rating:@"4" delegate:self];
                
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
-(void)ownerRatingButonClick5:(GroupInfoSecondTableViewCell*)cellValue
{
    if ([self.joinStatus isEqualToString:@"1"]) {
        
        if ([subscriptionStatus isEqualToString:@"2"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Please subscribe group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service AddRatingOwnerInvocation:gUserId ownerId:self.groupOwnerId rating:@"5" delegate:self];
                
            }
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"Only group members can rate this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
-(void)btnPublicClick:(GroupInfoOwnerTableViewCell *)sender
{
    if (sender.btnPublic.selected==YES) {
        
        [sender.btnPublic setSelected:YES];
        [sender.btnPrivate setSelected:NO];
        self.groupType=@"0";
    }
    else{
        
        [sender.btnPublic setSelected:YES];
        [sender.btnPrivate setSelected:NO];
        self.groupType=@"0";
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [service GroupTypeEditInvocation:gUserId groupId:self.groupId groupType:self.groupType delegate:self];
    }
    
}
-(void)btnPrivateClick:(GroupInfoOwnerTableViewCell *)sender
{
    if (sender.btnPrivate.selected==YES) {
        
        [sender.btnPrivate setSelected:YES];
        [sender.btnPublic setSelected:NO];
        self.groupType=@"1";
    }
    else{
        
        [sender.btnPrivate setSelected:YES];
        [sender.btnPublic setSelected:NO];
        self.groupType=@"1";
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [service GroupTypeEditInvocation:gUserId groupId:self.groupId groupType:self.groupType delegate:self];
        
    }
    
}
-(void)ButtonClick:(GroupInfoFirstTableViewCellController*)cellValue
{
    if ([self.groupOwnerId isEqualToString:gUserId]) {
        
        imageAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take from camera",@"Take from library", nil];
        [imageAlert show];
    }
}
-(void)MoreButtonClick:(GroupInfoFirstTableViewCellController*)cellValue
{
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    objDisplayMoreIntroViewController=[[DisplayMoreIntroViewController alloc] init];
    objDisplayMoreIntroViewController.groupIntro=data.groupIntro;
    
    [self.navigationController pushViewController:objDisplayMoreIntroViewController animated:YES];
}
-(void)GroupMemberButtonClick:(GroupMemberTableViewCell*)cellValue
{
    NSString *userId=[cellValue.btnImage titleForState:UIControlStateReserved];
    NSString *userName=[cellValue.btnImage titleForState:UIControlStateApplication];
    
    if (![userId isEqualToString:@"1"]) {
        
        if ([userId isEqualToString:gUserId]) {
            
            objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            
            objProfileViewController.userId=userId;
            objProfileViewController.navTitle=userName;
            objProfileViewController.checkBackButton=@"Setting";
            [self.navigationController pushViewController:objProfileViewController animated:YES];
            
        }
        else
        {
            objFriendProfieView=[[FriendProfileViewController alloc] init];
            objFriendProfieView.userId=userId;
            objFriendProfieView.navTitle=userName;
            objFriendProfieView.checkView=@"Other";
            objFriendProfieView.checkChatButtonStatus=@"YES";
            
            [self.navigationController pushViewController:objFriendProfieView animated:YES];
            
        }
        
    }
    
    
}
-(void)GroupMemberButton1Click:(GroupMemberTableViewCell*)cellValue
{
    NSString *userId=[cellValue.btnImage1 titleForState:UIControlStateReserved];
    NSString *userName=[cellValue.btnImage1 titleForState:UIControlStateApplication];
    
    if (![userId isEqualToString:@"1"]) {
        
        if ([userId isEqualToString:gUserId]) {
            
            objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            
            objProfileViewController.userId=userId;
            objProfileViewController.navTitle=userName;
            objProfileViewController.checkBackButton=@"Setting";

            [self.navigationController pushViewController:objProfileViewController animated:YES];
            
        }
        else
        {
            objFriendProfieView=[[FriendProfileViewController alloc] init];
            objFriendProfieView.userId=userId;
            objFriendProfieView.navTitle=userName;
            objFriendProfieView.checkView=@"Other";
            objFriendProfieView.checkChatButtonStatus=@"YES";
            
            [self.navigationController pushViewController:objFriendProfieView animated:YES];
            
        }
        
    }
}
-(void)GroupMemberButton2Click:(GroupMemberTableViewCell*)cellValue
{
    NSString *userId=[cellValue.btnImage2 titleForState:UIControlStateReserved];
    NSString *userName=[cellValue.btnImage2 titleForState:UIControlStateApplication];
    
    if (![userId isEqualToString:@"1"]) {
        
        if ([userId isEqualToString:gUserId]) {
            
            objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            
            objProfileViewController.userId=userId;
            objProfileViewController.navTitle=userName;
            objProfileViewController.checkBackButton=@"Setting";

            [self.navigationController pushViewController:objProfileViewController animated:YES];
            
        }
        else
        {
            objFriendProfieView=[[FriendProfileViewController alloc] init];
            objFriendProfieView.userId=userId;
            objFriendProfieView.navTitle=userName;
            objFriendProfieView.checkView=@"Other";
            objFriendProfieView.checkChatButtonStatus=@"YES";
            
            [self.navigationController pushViewController:objFriendProfieView animated:YES];
            
        }
        
    }
}
-(void)GroupMemberButton3Click:(GroupMemberTableViewCell*)cellValue
{
    NSString *userId=[cellValue.btnImage3 titleForState:UIControlStateReserved];
    NSString *userName=[cellValue.btnImage3 titleForState:UIControlStateApplication];
    
    if (![userId isEqualToString:@"1"]) {
        
        if ([userId isEqualToString:gUserId]) {
            
            objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            
            objProfileViewController.userId=userId;
            objProfileViewController.navTitle=userName;
            objProfileViewController.checkBackButton=@"Setting";

            [self.navigationController pushViewController:objProfileViewController animated:YES];
            
        }
        else
        {
            objFriendProfieView=[[FriendProfileViewController alloc] init];
            objFriendProfieView.userId=userId;
            objFriendProfieView.navTitle=userName;
            objFriendProfieView.checkView=@"Other";
            objFriendProfieView.checkChatButtonStatus=@"YES";
            
            [self.navigationController pushViewController:objFriendProfieView animated:YES];
            
        }
        
    }}

#pragma mark UIActionSheetDelegate

/*- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 int i = buttonIndex;
 switch(i)
 {
 case 0:
 {
 objAddMemberInGroupViewController =[[AddMemberInGroupViewController alloc] initWithNibName:@"AddMemberInGroupViewController" bundle:nil];
 
 objAddMemberInGroupViewController.checkContactView=@"Share Group";
 objAddMemberInGroupViewController.groupId=self.groupId;
 [self.navigationController pushViewController:objAddMemberInGroupViewController animated:YES];
 }
 break;
 case 1:
 {
 [self performSelector:@selector(facebookLogin) withObject:nil afterDelay:0.2];
 
 break;
 
 }
 default:
 // Do Nothing.........
 break;
 }
 }*/

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
    
    GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
    
    // NSString *mailCurrentLink=@"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8";
    
    NSString *currentTitleStr=[NSString stringWithFormat:@"Join this push-to-talk support group: %@ First, install app WellConnected ",data.groupTitle];
    
    currentTitleStr=[currentTitleStr stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *postData = [NSString stringWithFormat:@"%@ \n Then, search group #: %@", currentTitleStr,data.groupCode];
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.groupImage];
    
    
    //UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]];
    
    // NSLog(@"%@",currentTitleStr);
    NSLog(@"%@",imageurl);
    
    
    SBJSON *jsonWriter = [SBJSON new] ;
    
    
    /* NSDictionary* imageShare = [NSDictionary dictionaryWithObjectsAndKeys:
     @"image", @"type",
     //@"http://wellconnected.ehealthme.com/Icon-72.png", @"src",
     imageurl,@"src",
     @"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8", @"href",
     nil];
     
     NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
     currentTitleStr, @"name",
     @"WellConnected", @"caption",
     @"https://itunes.apple.com/us/app/wellconnected/id747774005?ls=1&mt=8", @"href",
     [NSArray arrayWithObjects:imageShare, nil ], @"media",
     nil];*/
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [self useImage:image];
    
    [self performSelectorOnMainThread:@selector(uploadImage) withObject:nil waitUntilDone:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)uploadImage
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSArray *formfields = [NSArray arrayWithObjects:@"userId",@"groupId",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,self.groupId,nil];
    
	
    NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray *photo = [NSArray arrayWithObjects:@"myimage1.png",nil];
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
	
	
	[self performSelector:@selector(doPostWithImage:) withObject:compositeData afterDelay:0.1];
    
}
- (void) doPostWithImage: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSArray * _photo = [compositeData objectAtIndex:1];
	
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"groupEditImage"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",self.imageData.length);
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease] ;
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	
	for (int i=0; i<[_photo count]; i++) {
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"2.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[NSData dataWithData:self.imageData]];
		
		// [body appendData:[NSData dataWithData:data]];
		self.imageData=nil;
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
	for (id key in _textParams) {
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:[_textParams objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	
	NSLog(@"%@",returnString);
	
	results=[returnString JSONValue];
	
	NSLog(@"%@",results);
    
    NSDictionary *responseDic=[results objectForKey:@"response"];
	
    if ([results count]>0) {
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strMessageError=[responseDic objectForKey:@"error"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            UIAlertView *successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            [service GroupDetailInvocation:gUserId groupId:self.groupId delegate:self];
            
            
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)useImage:(UIImage*)theImage
{
    self.imageData=nil;
    
    UIImage *img=[theImage imageByScalingAndCroppingForSize:CGSizeMake(400, 400)];
    
	self.imageData = UIImageJPEGRepresentation(img, 0.1);
    
}
#pragma mark----------
#pragma Webservice delegate

-(void)GroupDetailInvocationDidFinish:(GroupDetailInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrGroupDetailData removeAllObjects];
    [self.arrGroupMemberList removeAllObjects];
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        if ([result count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"Charge",@"created",@"groupCode",@"id",@"image",@"intro",@"name",@"paidStatus",@"rating",@"status",@"type",@"ownerId",@"threadId",@"memberCount",@"user_ids",@"groupRating",@"ownerRating",@"privilege",@"transactionId",@"subscribeStatus",@"kickout",@"trial",@"closeStatus",@"numberOfUserGroupRating",@"parent_id",@"special",nil];
            
            for (NSMutableArray *arrValue in result) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                GroupDetailData  *data=[[[GroupDetailData alloc] init] autorelease];
                
                data.groupCharge=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"Charge"]];
                data.groupCreated=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"created"]];
                data.groupCode=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupCode"]];
                data.groupImage=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"image"]];
                
                data.groupIntro=[self stringByStrippingHTML:[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]]];
                
                //data.groupIntro=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];
                data.groupTitle=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"name"]];
                data.groupPaidStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"paidStatus"]];
                data.groupRating=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"rating"]];
                data.groupType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"type"]];
                data.groupMember=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"memberCount"]];
                data.groupUserRating=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupRating"]];
                data.groupUserOwnerRating=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"ownerRating"]];
                data.groupTrialPeriod=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"trial"]];
                data.groupCloseStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"closeStatus"]];
                
                data.groupTotalVote=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"numberOfUserGroupRating"]];
                self.transactionId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"transactionId"]];
                
                self.privilageStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"privilege"]];
                self.groupOwnerId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"ownerId"]];
                self.threadId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"threadId"]];
                data.groupParentId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"parent_id"]];
                data.groupSpecialType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"special"]];
                self.specialStatus=data.groupSpecialType;
                
                data.groupperiodType=[[arrValue valueForKey:@"periodType"]description];
                
                [self.arrGroupDetailData addObject:data];
                
                [self.arrGroupMemberList addObjectsFromArray:[arrValue valueForKey:@"groupUser"]];
                
                NSLog(@"%@",self.arrGroupMemberList);
                
                self.userIds=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_ids"]];
                self.subscriptionStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"subscribeStatus"]];
                self.kickOutStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"kickout"]];
                
                
                
            }
            
            [arrOfResponseField release];
        }
        
    }
    
    [self.tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([self.kickOutStatus isEqualToString:@"1"]) {
        
        kickOutAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Group owner has kicked out of you so you can't perform any antion" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [kickOutAlert show];
        [kickOutAlert release];
    }
    
    moveTabG=FALSE;
    
}

-(void)AddRatingInvocationDidFinish:(AddRatingInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
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
            [service GroupDetailInvocation:gUserId groupId:self.groupId delegate:self];
            
        }
    }
    
    
}
-(void)AddRatingOwnerInvocationDidFinish:(AddRatingOwnerInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
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
            [service GroupDetailInvocation:gUserId groupId:self.groupId delegate:self];
            
        }
    }
    
}
-(void)QuitGroupInvocationDidFinish:(QuitGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        
        NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat where GroupId= '%@'",self.groupId];
        
        NSLog(@"%@",sqlStatement);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
        }
        
        NSString *sqlStatement1=[NSString stringWithFormat:@"delete from tbl_chatUser where chatUserId='%@'",self.groupId];
        
        NSLog(@"%@",sqlStatement1);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement1 cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
        }
        quitSuccessAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [quitSuccessAlert show];
        [quitSuccessAlert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)QuitSpecialGroupInvocationDidFinish:(QuitSpecialGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        
        NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat where GroupId= '%@'",self.groupId];
        
        NSLog(@"%@",sqlStatement);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
        }
        
        NSString *sqlStatement1=[NSString stringWithFormat:@"delete from tbl_chatUser where chatUserId='%@'",self.groupId];
        
        NSLog(@"%@",sqlStatement1);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement1 cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
        }
        quitSuccessAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [quitSuccessAlert show];
        [quitSuccessAlert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void)ClearGroupMessageInvocationDidFinish:(ClearGroupMessageInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        self.arrImageAudioPath=[[NSMutableArray alloc] init];
        
        [self getAllImagePath];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
}
-(void)getAllImagePath
{
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT ImageId FROM tbl_chat where GroupId='%@' and ContentType='%@'",self.groupId,@"2"];
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            NSString *imageId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            [self.arrImageAudioPath addObject:imageId];
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
    [self getAllAudioPath];
    
    
}
-(void)getAllAudioPath
{
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT AudioId FROM tbl_chat where GroupId='%@' and ContentType='%@'",self.groupId,@"3"];
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            NSString *audioId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            [self.arrImageAudioPath addObject:audioId];
            
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
    [self removeALlImageAudioFromPlist];
}
-(void)deleteAllChat
{
    NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat where GroupId= '%@'",self.groupId];
    
    NSLog(@"%@",sqlStatement);
    
    if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
    {
        NSLog(@"success");
        
        clearSuccessAlert=[[UIAlertView alloc] initWithTitle:nil message:@"All messages has been deleted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [clearSuccessAlert show];
        [clearSuccessAlert release];
        
    }
    
    
}
-(void)removeALlImageAudioFromPlist
{
    for (int i=0; i<[self.arrImageAudioPath count]; i++) {
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString *pathOfRecording =[self.arrImageAudioPath objectAtIndex:i];
        
        NSLog(@"%@",pathOfRecording);
        
        NSError *error = nil;
        BOOL success = [fm removeItemAtPath:pathOfRecording error:&error];
        
        if (!success || error) {
            
            NSLog(@"error");
        }
    }
    
    [self deleteAllChat];
}

-(void)GroupTypeEditInvocationDidFinish:(GroupTypeEditInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)UnSubcribeInvocationDidFinish:(UnSubcribeInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        unsubscribeSuccessAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unsubscribeSuccessAlert show];
        [unsubscribeSuccessAlert release];
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
-(void)RevenueInvocationDidFinish:(RevenueInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    else
    {
        subscribeSuccessAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [subscribeSuccessAlert show];
        [subscribeSuccessAlert release];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==quitSuccessAlert || alertView==clearSuccessAlert || unsubscribeSuccessAlert || alertView==subscribeSuccessAlert || alertView==kickOutAlert) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(alertView==imageAlert)
    {
        if (buttonIndex==1) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                
                
                UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
                picker.sourceType =UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = NO;
                // [[self navigationController] presentModalViewController:picker animated:YES];
                [self presentViewController:picker animated:YES completion:nil];
                
                
            }
            else {
                
                
                UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
                picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = NO;
                // [[self navigationController] presentModalViewController:picker animated:YES];
                [self presentViewController:picker animated:YES completion:nil];
                
                
            }
            
        }
        else if(buttonIndex==2)
        {
            
            UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
            picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = NO;
            // [[self navigationController] presentModalViewController:picker animated:YES];
            
            [self presentViewController:picker animated:YES completion:nil];
            
            
        }
        
    }
    else if(alertView==quitAlert)
    {
        if (buttonIndex==1) {
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                if ([self.specialStatus isEqualToString:@"1"]) {
                    
                    [service QuitSpecialGroupInvocation:gUserId groupId:self.groupId ownerId:self.groupOwnerId type:@"0" delegate:self];
                }
                else
                {
                    [service QuitGroupInvocation:gUserId groupId:self.groupId ownerId:self.groupOwnerId type:@"0" delegate:self];
                    
                }
                
            }
            
        }
        
    }
    else if(alertView==clearAlert)
    {
        if (buttonIndex==1) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service ClearGroupMessageInvocation:gUserId groupId:self.groupId delegate:self];
                
                
            }
            
        }
        
    }
    else if(alertView==unsubscribeAlert)
    {
        if (buttonIndex==1) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [service UnSubcribeInvocation:gUserId groupId:self.groupId transactionId:self.transactionId delegate:self];
                
                
            }
            
        }
        
    }
    else if (alertView==subscribeAlert)
    {
        if (buttonIndex==1) {
            
            
            GroupDetailData *data=[self.arrGroupDetailData objectAtIndex:0];
            
            if ([data.groupCharge isEqualToString:@"1.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.onesub";
                
            }
            else if ([data.groupCharge isEqualToString:@"2.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.twosub";
                
            }
            else if ([data.groupCharge isEqualToString:@"5.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.fivesub";
                
            }
            else if ([data.groupCharge isEqualToString:@"10.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.tensub";
                
            }
            else if ([data.groupCharge isEqualToString:@"20.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.twentysub";
                
            }
            else if ([data.groupCharge isEqualToString:@"50.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.fiftysub";
                
            }
            else if ([data.groupCharge isEqualToString:@"100.00"]) {
                
                self.productId=@"com.ehealthme.wellconnected.hundredsub";
                
            }
            
            self.productPrice=data.groupCharge;
            
            NSLog(@"%@",self.productId);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:[NSString stringWithFormat:@"%@",self.productId]]];
            request.delegate = self;
            [request start];
        }
        
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
#pragma mark Store delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"productsRequest");
    
	NSArray *myProduct = response.products;
    
	NSLog(@"%@",myProduct);
	
	if (myProduct == nil || [myProduct count] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:@"Missing product from App store.\n"
													   delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		return;
	}
    
    NSLog(@"startPurchase");
    
    SKProduct *product;
	BOOL    existProduct = NO;
	for (int i=0; i<[myProduct count]; i++) {
		product = (SKProduct*)[myProduct objectAtIndex:0];
		if ([product.productIdentifier isEqualToString:self.productId]) {
			existProduct = YES;
			break;
		}
	}
	if (existProduct == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Missing product from App store.No match Identifier found.\n"
													   delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[request autorelease];
    
    [self startPurchase];
	
	
}
-(void)requestDidFinish:(SKRequest *)request
{
	//NSLog(@"requestDidFinish");
	// [request release];
}
- (void) startPurchase {
	
	//NSLog(@"startPurchase");
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:[NSString stringWithFormat:@"%@",self.productId]];
    //NSLog(@"startPurchase1");
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	//NSLog(@"startPurchase2");
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	//NSLog(@"startPurchase3");
}

/*-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
 {
 NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
 }*/
#pragma mark -
#pragma mark observer delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"paymentQueue");
	
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				NSLog(@"Success");
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				NSLog(@"Failed");
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"completeTransaction");
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
	self.strTransactionId=transaction.transactionIdentifier;
    
    [service RevenueInvocation:gUserId groupId:self.groupId transactionId:self.strTransactionId subCharge:self.productPrice delegate:self];
    
    
	/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:@"Congratulation You have subscribed successfully." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
     [alert show];
     [alert release];*/
	
	//[MBProgressHUD hideHUDForView:self.view animated:YES];
	
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:@"Congratulation You have subscribed successfully." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		NSString *stringError = [NSString stringWithFormat:@"Payment Cancelled\n\n%@", [transaction.error localizedDescription]];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:stringError delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)viewDidUnload
{
    _arrGroupDetailData=nil;
    
    self.imageData=nil;
    self.groupId=nil;
    self.groupOwnerId=nil;
    self.privilageStatus=nil;
    self.threadId=nil;
    self.userIds=nil;
    self.groupType=nil;
    self.transactionId=nil;
    self.joinStatus=nil;
    self.subscriptionStatus=nil;
    self.strTransactionId=nil;
    self.productId=nil;
    self.productName=nil;
    self.productPrice=nil;
    self.tblView=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    self.imageData=nil;
    self.groupId=nil;
    self.groupOwnerId=nil;
    self.privilageStatus=nil;
    self.threadId=nil;
    self.userIds=nil;
    self.groupType=nil;
    self.transactionId=nil;
    self.joinStatus=nil;
    self.subscriptionStatus=nil;
    self.strTransactionId=nil;
    self.productId=nil;
    self.productName=nil;
    self.productPrice=nil;
    self.tblView=nil;
    [_arrGroupDetailData release];
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
