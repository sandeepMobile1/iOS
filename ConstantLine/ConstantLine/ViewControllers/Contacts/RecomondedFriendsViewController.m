//
//  RecomondedFriendsViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RecomondedFriendsViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "JSON.h"

@implementation RecomondedFriendsViewController

@synthesize arrRecommandFriendList,tblView;

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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Friends"];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    NSLog(@"%d",[self.arrRecommandFriendList count]);
    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
   
    objImageCache=[[ImageCache alloc] init];
    objImageCache.delegate=self;
    
    navigation=self.navigationController.navigationBar;
    
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
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }

    
}
-(void)backButtonClick:(UIButton *)sender{
    
           [self.navigationController popViewControllerAnimated:YES];
        
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}

#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrRecommandFriendList count];
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    height=60;
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (RecommandedTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (Nil == cell) 
    {
        cell = [RecommandedTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.btnAddFriend setHidden:FALSE];
    
    NSString *name=[[self.arrRecommandFriendList objectAtIndex:indexPath.row] objectForKey:@"user_name"];
    
    NSString *userId=[[self.arrRecommandFriendList objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    
    NSString *status=[[self.arrRecommandFriendList objectAtIndex:indexPath.row] objectForKey:@"status"];
    
    if ([status isEqualToString:@"0"]) {
        [cell.btnAddFriend setTitle:@"Add" forState:UIControlStateNormal];
        [cell.btnAddFriend setBackgroundImage:[UIImage imageNamed:@"VoiceBtn_Black"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnAddFriend setTitle:@"Added" forState:UIControlStateNormal];
        [cell.btnAddFriend setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    NSString *userImage=[[self.arrRecommandFriendList objectAtIndex:indexPath.row] objectForKey:@"user_image"];
    
    cell.lblName.text=name;
    
    [cell.btnAddFriend setTitle:userId forState:UIControlStateReserved];
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,userImage];
    
    
    if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
        
        
        [cell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
        
    } 
    else 
    {
        NSLog(@"%@",userImage);
        
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
-(void) buttonAddFriend:(ContactTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [self.tblView indexPathForCell:cellValue];
    deletedRow=indexPath.row;
    
    
    NSString *status=[[self.arrRecommandFriendList objectAtIndex:deletedRow] objectForKey:@"status"];
    
    if ([status isEqualToString:@"0"]) {
        
        NSString *friendId=[NSString stringWithFormat:@"%@",[cellValue.btnAddFriend titleForState:UIControlStateReserved]];
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
        service=[[ConstantLineServices alloc] init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service AddContactListInvocation:gUserId friendId:friendId intro:@"" delegate:self];
        
        }
        
    }
}

-(void)AddContactListInvocationDidFinish:(AddContactListInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
