//
//  FinsGroupViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FinsGroupViewController.h"
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
#import "QSStrings.h"

@implementation FinsGroupViewController

@synthesize tblView;

@synthesize arrGroupList=_arrGroupList;
@synthesize arrSearchGroupList=_arrSearchGroupList;

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
    
    if (self.arrGroupList!=nil) {
        
        self.arrGroupList=nil;
    }
    self.arrGroupList=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Find Groups"];
    
    // Do any additional setup after loading the view from its nib.
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    // Do any additional setup after loading the view from its nib.
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
           
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 460-50)];
                
            
        }
        else
        {
           
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 460-50-IPHONE_FIVE_FACTOR)];
                
            
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 340+IPHONE_FIVE_FACTOR)];
        }
        else
        {
            
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 340)];
                
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
   
    searchBar.text=@"";
    [searchBar resignFirstResponder];   
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
     
    [self.tblView setContentOffset:CGPointMake(0, 0)];
    
    if(status==0)
    {
        moveTabG=TRUE;
      
        if (service==nil) {
            
            service=[[ConstantLineServices alloc] init];
        }
        if (objImageCache==nil) {
            
            objImageCache=[[ImageCache alloc] init];
            objImageCache.delegate=self;
        }
              
        tblView.delegate=self;
        tblView.dataSource=self;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service FindGroupInvocation:gUserId searchCriteria:searchBar.text pageString:@"" delegate:self];
        
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
    
    return 80;    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    static NSString *unpaidCellIdentifier=@"UnpaidCell";
    
    ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
    
    NSLog(@"data.paidStatus %@",data.paidStatus);
    
    if ([data.paidStatus isEqualToString:@"1"]) {
        
        cell = (ChatListTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (Nil == cell) 
        {
            cell = [ChatListTableViewCell createTextRowWithOwner:self withDelegate:self];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.lblName.text= data.name;
        cell.lblMessage.text=[data.message capitalizedString];
        cell.lblDate.text=data.date;
        cell.lblFee.text=[NSString stringWithFormat:@"Monthly fee: $%@",data.charge];
        
        [cell.btnAccept setHidden:TRUE];
        [cell.btnReject setHidden:TRUE];
        
        [cell.imgStatus setImage:[UIImage imageNamed:@"grey_bullet.png"]];
       
        if ([data.subscribeStatus isEqualToString:@"0"]) {
            
            cell.lblMessage.text=@"";
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
        
    }
    
    else
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
        unpaidCell.lblMessage.text=[data.message capitalizedString];
        unpaidCell.lblDate.text=data.date;
        
        [unpaidCell.btnAccept setHidden:TRUE];
        [unpaidCell.btnReject setHidden:TRUE];
        
        [unpaidCell.imgStatus setImage:[UIImage imageNamed:@"grey_bullet.png"]];
       
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
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
    
    if ([data.groupJoinStatus isEqualToString:@"1"]) {
        
        if ([data.paidStatus isEqualToString:@"1"]) {
            
            if ([data.subscribeStatus isEqualToString:@"1"]) {
                
                ChatViewController *objChatViewController;
                
                objChatViewController=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                
                objChatViewController.friendUserName=data.name;
                objChatViewController.groupType=@"1";
                objChatViewController.groupId=data.userId;
                objChatViewController.friendId=@"0";
                objChatViewController.groupTitle=data.name;

                [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
                objChatViewController.threadId=data.zChatId;

                [self.navigationController pushViewController:objChatViewController animated:YES];
                [objChatViewController release];
                
            }
            else
            {
                GroupInfoViewController *objGroupInfoViewController=[[GroupInfoViewController alloc] initWithNibName:@"GroupInfoViewController" bundle:nil];
                
                ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
                
                objGroupInfoViewController.groupId=data.userId;
                objGroupInfoViewController.joinStatus=data.groupJoinStatus;
                
                [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
                
                [self.navigationController pushViewController:objGroupInfoViewController animated:YES];
                [objGroupInfoViewController release];
                
            }

        }
        else
        {
            ChatViewController *objChatViewController;
            
            objChatViewController=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            
            objChatViewController.friendUserName=data.name;
            objChatViewController.groupType=@"1";
            objChatViewController.groupId=data.userId;
            objChatViewController.friendId=@"0";
            objChatViewController.threadId=data.zChatId;
            objChatViewController.groupTitle=data.name;

            [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
            
            [self.navigationController pushViewController:objChatViewController animated:YES];
            [objChatViewController release];
        }
        
    }
    else
    {
        GroupInfoViewController *objGroupInfoViewController=[[GroupInfoViewController alloc] initWithNibName:@"GroupInfoViewController" bundle:nil];
        
        ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
        
        objGroupInfoViewController.groupId=data.userId;
        objGroupInfoViewController.joinStatus=data.groupJoinStatus;
        
        [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=data.groupType;
        
        [self.navigationController pushViewController:objGroupInfoViewController animated:YES];
        [objGroupInfoViewController release];
    }
}

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}

-(void) buttonAcceptClick:(ChatListTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service JoinGroupInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];
       
    }
    
}
-(void) buttonUnpaidAcceptClick:(ChatListUnpaidTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatListData *data=[self.arrGroupList objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [service JoinGroupInvocation:gUserId friendId:data.groupOwnerId groupId:data.userId delegate:self];

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
        
        [service FindGroupInvocation:gUserId searchCriteria:searchBar.text pageString:@"" delegate:self];

    }
    
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    
    if (searchTerm.length>0) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service FindGroupInvocation:gUserId searchCriteria:searchBar.text pageString:@"" delegate:self];
            
        }
    }
      
}
#pragma mark Delegate
#pragma mark Webservide Delegate

-(void)FindGroupInvocationDidFinish:(FindGroupInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrGroupList removeAllObjects];
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"GroupDetail"];
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"friend_id",@"Chattype",@"friend_name",@"friend_image",@"message",@"msgId",@"status",@"date",@"groupId",@"groupImage",@"groupName",@"groupType",@"paidStatus",@"subCharge",@"request_status",@"groupOwnerId",@"groupUserTableId",@"static",@"join",@"threadId",nil];
            
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
                NSString *msg=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"message"]];
                
                NSString *result=@"";
                
                result=msg;
                
                NSLog(@"result %@",result);
                
                data.message=result;
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
    self.tblView=nil;
    _arrGroupList=nil;
    _arrSearchGroupList=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    self.tblView=nil;
    [_arrGroupList release];
    [_arrSearchGroupList release];
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
