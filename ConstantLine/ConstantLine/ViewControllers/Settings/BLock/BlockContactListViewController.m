//
//  BlockContactListViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BlockContactListViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "RecommandedTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"
#import "UserProfileViewController.h"

@implementation BlockContactListViewController

@synthesize tblView;

@synthesize arrBlockList=_arrBlockList;

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
    
    if (self.arrBlockList!=nil) {
        
        self.arrBlockList=nil;
    }
    self.arrBlockList=[[NSMutableArray alloc] init];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Block Contacts"];
    
    // Do any additional setup after loading the view from its nib.
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [tblView setFrame:CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y, tblView.frame.size.width, 568)];
            
        }
        else
        {
            [tblView setFrame:CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y, tblView.frame.size.width, 568-IPHONE_FIVE_FACTOR)];
            
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            
            [tblView setFrame:CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y, tblView.frame.size.width, 480+IPHONE_FIVE_FACTOR-10)];
            
            
        }
        else
        {
            
            [tblView setFrame:CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y, tblView.frame.size.width, 480-10)];
            
            
            
            
        }
        
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
        
        [tblView setHidden:TRUE];
        
        
        service=[[ConstantLineServices alloc] init];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service BlockListInvocation:gUserId delegate:self];
        
    }
}

#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrBlockList count];
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    height=60;
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",self.arrBlockList);
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (RecommandedTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (Nil == cell) 
    {
        cell = [RecommandedTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.btnAddFriend setHidden:FALSE];
    
    ContactListData *data=[self.arrBlockList objectAtIndex:indexPath.row];
    
    
    
    [cell.btnAddFriend setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    
    [cell.btnAddFriend setTitle:@"" forState:UIControlStateNormal];
    
    
    cell.lblName.text= data.name;    
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
    
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        
        [cell.imgView setImage:[UIImage imageNamed:@""]];
        
    } 
    else 
    {
        NSLog(@"%@",data.image);
        
        if (imageurl && [imageurl length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:imageurl];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(35, 35);
                }
                else{
                    kImgSize_1=CGSizeMake(35*2, 35*2);
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
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactListData *data=[self.arrBlockList objectAtIndex:indexPath.row];
    
    if ([data.userId isEqualToString:gUserId]) {
        
            objUserProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            
        objUserProfileViewController.userId=data.userId;
        objUserProfileViewController.navTitle=data.name;
        
        [self.navigationController pushViewController:objUserProfileViewController animated:YES];
    }
    else
    {
       
            objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
            
        objFriendProfileViewController.userId=data.userId;
        objFriendProfileViewController.navTitle=data.name;
        objFriendProfileViewController.checkView=@"Other";
        objFriendProfileViewController.checkChatButtonStatus=@"YES";

        [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
    }
    
    
}
-(void) buttonAddFriend:(ContactTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ContactListData *data=[self.arrBlockList objectAtIndex:indexPath.row];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service BlockInvocation:gUserId friendId:data.userId blockType:@"0" delegate:self];
    
}
#pragma ----------
#pragma web service delegate

-(void)BlockListInvocationDidFinish:(BlockListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    
    [self.arrBlockList removeAllObjects];
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"BlockUser"];
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"id",@"image",@"user_id",@"username",@"displayName",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                ContactListData *data=[[[ContactListData alloc] init] autorelease];
                
                data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"image"]];
                data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"displayName"]];
                
                [self.arrBlockList addObject:data];
            }
            [arrOfResponseField release];
        }
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    
    [self.tblView reloadData];
    [self.tblView setHidden:FALSE];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    moveTabG=FALSE;
}

-(void)BlockInvocationDidFinish:(BlockInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            [service BlockListInvocation:gUserId delegate:self];
            
        }
        
        
        
        
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    service=nil;
    // [objImageCache cancelDownload];
    // objImageCache=nil;
    tblView.delegate=nil;
    tblView.dataSource=nil;
}
- (void)viewDidUnload
{
    _arrBlockList=nil;
    self.tblView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrBlockList release];
    self.tblView=nil;
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
