//
//  KickOffMemberViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

//1.groupRating
//fields:userId,groupId,rating
//
//2.groupOwnerRating
//fields:userId,ownerId,rating

#import "KickOffMemberViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "AddMembersTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation KickOffMemberViewController

@synthesize kickOffUserId,memberIds,threadId,groupId,checkView,ownerId;

@synthesize arrMemberList=_arrMemberList;

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
    
    
    self.arrMemberList=[[NSMutableArray alloc] init];
    
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
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)backButtonClick:(UIButton *)sender{
    
    if ([self.checkView isEqualToString:@"chat"]) {
        
        [AppDelegate sharedAppDelegate].addressContactId=@"";
        [AppDelegate sharedAppDelegate].addressContactName=@"";
        [AppDelegate sharedAppDelegate].checkaddressContact=@"YES";
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
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
    
    if(status==0)
    {
    if (objImageCache==nil) {
        
        objImageCache=[[ImageCache alloc] init];
    }
    objImageCache.delegate=self;
   
    if (service==nil) {
        
        service=[[ConstantLineServices alloc] init];
    }
    
        moveTabG=TRUE;
        
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service GroupMemberListInvocation:self.memberIds groupId:self.groupId delegate:self];

    
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

    
    [tblView setContentOffset:CGPointMake(0, 0)];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [objImageCache cancelDownload];
    objImageCache=nil;
}
#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrMemberList count];
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    height=60;
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",self.arrMemberList);
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (AddMembersTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (Nil == cell) 
    {
        cell = [AddMembersTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    ContactListData *data=[self.arrMemberList objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.btnSelectFriend setHidden:TRUE];
       
    cell.lblName.text= data.userName;
    
    
    if (data.image==nil ||data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        [cell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
    } 
    else 
    {         
        NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
        
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

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [tblView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    ContactListData *data=[self.arrMemberList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",data.userId);
    
    self.kickOffUserId=data.userId;
    
    NSLog(@"kickOffUserId %@",self.kickOffUserId);
     NSLog(@"ownerId %@",self.ownerId);
    
    if ([self.checkView isEqualToString:@"kickoff"]) {
         
        if ([self.ownerId isEqualToString:self.kickOffUserId]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You can't kickout group owner" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            kickOffAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want to kick out this member" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [kickOffAlert show];
            [kickOffAlert release];
        }
       
    }
    else if ([self.checkView isEqualToString:@"chat"]) {
        
        ContactListData *data=[self.arrMemberList objectAtIndex:indexPath.row];
        [AppDelegate sharedAppDelegate].addressContactId=data.userId;
        [AppDelegate sharedAppDelegate].addressContactName=data.userName;
        [AppDelegate sharedAppDelegate].checkaddressContact=@"YES";
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        privilageAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want give privilege to this member" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [privilageAlert show];
        [privilageAlert release];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==kickOffAlert) {
        
        if (buttonIndex==1) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSLog(@"%@",self.threadId);
            
            [service KickOffMemberInvocation:gUserId friendId:self.kickOffUserId threadId:self.threadId groupId:self.groupId delegate:self];
                
            }
        }
    }
    else if(alertView==privilageAlert)
    {
        if (buttonIndex==1) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSLog(@"%@",self.threadId);
            
            [service AddPrivillegeInvocation:gUserId groupId:self.groupId friendId:self.kickOffUserId delegate:self];
                
            }
        }
    }
}

#pragma mark----------------
#pragma Webservice delegate

-(void)GroupMemberListInvocationDidFinish:(GroupMemberListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrMemberList removeAllObjects];
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"GroupUser"];
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"user_id",@"user_image",@"user_name",@"displayname",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                ContactListData *data=[[[ContactListData alloc] init] autorelease];
                
                data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
                data.userName=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                
                [self.arrMemberList addObject:data];
            }
            
            [arrOfResponseField release];
            
        }
        
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    [tblView reloadData];
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)KickOffMemberInvocationDidFinish:(KickOffMemberInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
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
        [service GroupMemberListInvocation:self.memberIds groupId:self.groupId delegate:self];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];  
        [alert release];
        
    }
    

}

-(void)AddPrivillegeInvocationDidFinish:(AddPrivillegeInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
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
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
        [service GroupMemberListInvocation:self.memberIds groupId:self.groupId delegate:self];
        
        }
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];  
        [alert release];
        
    }
    

}
- (void)viewDidUnload
{
    _arrMemberList=nil;
    self.kickOffUserId=nil;
    self.memberIds=nil;
    self.threadId=nil;
    self.groupId=nil;
    self.ownerId=nil;
    self.checkView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    self.kickOffUserId=nil;
    self.memberIds=nil;
    self.threadId=nil;
    self.groupId=nil;
    self.ownerId=nil;
    self.checkView=nil;
    [_arrMemberList release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
