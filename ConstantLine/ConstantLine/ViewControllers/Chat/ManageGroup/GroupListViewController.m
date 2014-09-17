//
//  GroupListViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupListViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "GroupListData.h"
#import "MBProgressHUD.h"
#import "GroupInfoViewController.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "QSStrings.h"
#import "ChatViewController.h"
#import "ChatListData.h"
#import "StartGroupViewController.h"

@implementation GroupListViewController

@synthesize tblView,totalRecord,page;

@synthesize arrGroupList=_arrGroupList;

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
    
    self.page=1;

    [imgBottomView setAlpha:0.9];

    if (self.arrGroupList!=nil) {
        
        self.arrGroupList=nil;
    }
    self.arrGroupList=[[NSMutableArray alloc] init];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"My Groups"];
    
    
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton setFrame:CGRectMake(0,0, 25,29)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=left;
    
    UIButton *startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"New" forState:UIControlStateNormal];
    [startButton setFrame:CGRectMake(0,8, 45,29)];
    [startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    [startButton addTarget:self action:@selector(stratGroupPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIView *startButtonView=[[[UIView alloc] initWithFrame:CGRectMake(0, 1, 45, 43)]autorelease];
    [startButtonView addSubview:startButton];
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:startButtonView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;

    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

}
-(IBAction)stratGroupPressed:(id)sender
{
        objStartGroupView=[[StartGroupViewController alloc] initWithNibName:@"StartGroupViewController" bundle:nil];
        
        [self.navigationController pushViewController:objStartGroupView animated:YES];
    
}

-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 450)];
            
        }
        else
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 450-IPHONE_FIVE_FACTOR)];
            
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 370+IPHONE_FIVE_FACTOR)];
            
            
        }
        else
        {
            
            [self.tblView setFrame:CGRectMake(0, self.tblView.frame.origin.y, self.tblView.frame.size.width, 370)];
            
        }
        
    }
    

    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
  

    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        moveTabG=TRUE;
   
    if (service==nil) {
        
        service=[[ConstantLineServices alloc] init];
    }
        tblView.delegate=self;
        tblView.dataSource=self;
        
        if (objImageCache==nil) {
            
            objImageCache=[[ImageCache alloc] init];
            objImageCache.delegate=self;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.page=1;
        
        NSString *pageStr=[NSString stringWithFormat:@"%d",page];
        
        checkPaging=FALSE;
   
        [service ManageGroupListInvocation:gUserId page:pageStr searchText:@"" delegate:self];

    }
 }
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}


#pragma mark ---------------
#pragma mark table view delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=10;
    
     rowCount=[self.arrGroupList count];
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier=@"Cell";
   // static NSString *unpaidCellIdentifier=@"UnpaidCell";
    
    ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",data.paidStatus);
    
    
    
    //if ([data.paidStatus isEqualToString:@"1"]) {
        
        cell = (ChatListTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (Nil == cell) 
        {
            cell = [ChatListTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.lblName.text= data.name;
        cell.lblMessage.text=data.message;
        cell.lblDate.text=data.date;
        cell.lblFee.text=[NSString stringWithFormat:@"Monthly fee: $%@",data.charge];
        
        [cell.btnAccept setHidden:TRUE];
        [cell.btnReject setHidden:TRUE];
        
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
            [cell.imgStatus setImage:[UIImage imageNamed:@"v"]];
        }
    }
    
    
        if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
            [cell.imgView setImage:[UIImage imageNamed:@"group_pic.png"]];
        } 
        else 
        {     
            NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.image];
            
            
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
                
                [cell.imgView setImage:img];
            }
            
        }
        
        
        return cell;
        
    //}
    
   /* else
    {
        
        unpaidCell = (ChatListUnpaidTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:unpaidCellIdentifier];
        
        if (Nil == unpaidCell) 
        {
            unpaidCell = [ChatListUnpaidTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        
        [unpaidCell setBackgroundColor:[UIColor clearColor]];

        unpaidCell.accessoryType = UITableViewCellAccessoryNone;
        unpaidCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        unpaidCell.lblName.text= data.name;
        unpaidCell.lblMessage.text=data.message;
        unpaidCell.lblDate.text=data.date;
        
        [unpaidCell.btnAccept setHidden:TRUE];
        [unpaidCell.btnReject setHidden:TRUE];
        
        if ([data.readStatus isEqualToString:@"read"]) {
            
            [unpaidCell.imgStatus setImage:[UIImage imageNamed:@"grey_bullet.png"]];
        }
        else
        {
            [unpaidCell.imgStatus setImage:[UIImage imageNamed:@"blue_bullet"]];
        }
        
        [unpaidCell.lblDate setHidden:TRUE];
        
        [unpaidCell.btnAccept setFrame:CGRectMake(unpaidCell.btnAccept.frame.origin.x,17, unpaidCell.btnAccept.frame.size.width, unpaidCell.btnAccept.frame.size.height)];
        
        [unpaidCell.btnReject setFrame:CGRectMake(unpaidCell.btnReject.frame.origin.x,43, unpaidCell.btnReject.frame.size.width, unpaidCell.btnReject.frame.size.height)];

        if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
            [unpaidCell.imgView setImage:[UIImage imageNamed:@"group_pic.png"]];
        } 
        else 
        {     
            NSString *imageUrl=@"";
           
                imageUrl=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,data.image];
            
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
    }*/
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    objGroupInfoViewController=[[GroupInfoViewController alloc] initWithNibName:@"GroupInfoViewController" bundle:nil];
    
    ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
    
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
    
    objGroupInfoViewController.joinStatus=@"1";

    [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;

    [self.navigationController pushViewController:objGroupInfoViewController animated:YES];
}                                                                                                                                                            


-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}

-(void)ManageGroupListInvocationDidFinish:(ManageGroupListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    if (checkPaging==FALSE) {
        
        [self.arrGroupList removeAllObjects];
        
    }
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"GroupDetail"];
        
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
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"friend_id",@"Chattype",@"friend_name",@"friend_image",@"message",@"msgId",@"status",@"date",@"groupId",@"groupImage",@"groupName",@"groupType",@"paidStatus",@"subCharge",@"request_status",@"groupOwnerId",@"groupUserTableId",@"static",@"threadId",@"parent_id",@"special",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                ChatListData *data=[[[ChatListData alloc] init] autorelease] ;
                
                data.groupType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupType"]];
                data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupId"]];
                data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupImage"]];
                data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"groupName"]];
                data.readStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"status"]];
                data.zChatId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"threadId"]];
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
                
                [self.arrGroupList addObject:data];
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
    
    if (self.totalRecord>[self.arrGroupList count]) {
        
        [BottomView removeFromSuperview];
        [BottomView setFrame:CGRectMake(0, self.view.frame.size.height-BottomView.frame.size.height, BottomView.frame.size.width, BottomView.frame.size.height)];
        
        [self.view addSubview:BottomView];
    }
    else
    {
        [BottomView removeFromSuperview];
    }

    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    moveTabG=FALSE;
}
-(NSString *) stringByStrippingHTML:(NSString*)intro {
    NSRange r;
    while ((r = [intro rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        intro = [intro stringByReplacingCharactersInRange:r withString:@""];
    
    intro= [intro stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    return intro;
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
    
	searchBar.text = @"";
    
    [self.arrGroupList removeAllObjects];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.page=1;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    checkPaging=FALSE;
    
    [service ManageGroupListInvocation:gUserId page:pageStr searchText:searchBar.text delegate:self];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    
    if (searchTerm.length>0) {
        
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
            
            
            [service ManageGroupListInvocation:gUserId page:pageStr searchText:searchBar.text delegate:self];
        }
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	 
        NSInteger count=[self.arrGroupList count];
        
        if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height) {
            
            if (count < totalRecord)
            {
                page=page+1;
                
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                NSLog(@"%@",pageStr);
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                checkPaging=TRUE;
                
                [service ManageGroupListInvocation:gUserId page:pageStr searchText:searchBar.text delegate:self];
                
                
                
            }
        }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
}
-(void)viewWillDisappear:(BOOL)animated
{    
    
    [objImageCache cancelDownload];
    objImageCache=nil;
    
    service=nil;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    self.tblView.delegate=nil;
    self.tblView.dataSource=nil;
}

- (void)viewDidUnload
{
    _arrGroupList=nil;
    self.tblView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrGroupList release];
    self.tblView=nil;
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
