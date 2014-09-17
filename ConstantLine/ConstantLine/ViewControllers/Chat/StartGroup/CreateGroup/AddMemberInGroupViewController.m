//
//  AddMemberInGroupViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddMemberInGroupViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "AddMembersTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "sqlite3.h"
#import "CommonFunction.h"



@implementation AddMemberInGroupViewController

@synthesize tblView,checkContactView,groupId,friendId;

@synthesize arrContactList=_arrContactList;

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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Contacts"];
    
      
    UIButton *CancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[CancelButton setImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
    [CancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [CancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    [CancelButton setFrame:CGRectMake(0,7, 75,29)];
    [CancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *cancelButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 44)] autorelease];
    [cancelButtoView addSubview:CancelButton];
    
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:cancelButtoView]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
       
    if (![self.checkContactView isEqualToString:@"Share Group"]) {

        UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
       // [doneButton setImage:[UIImage imageNamed:@"done_btn.png"] forState:UIControlStateNormal];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        [doneButton setFrame:CGRectMake(0,7, 50,29)];
        [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *doneButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)]autorelease];
        [doneButtoView addSubview:doneButton];
        
        UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:doneButtoView]autorelease];
        self.navigationItem.rightBarButtonItem=rightBtn;

    }
        
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];
    
    self.arrContactList=[[NSMutableArray alloc] init];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        
        moveTabG=TRUE;
        
    service=[[ConstantLineServices alloc] init];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service ContactListInvocation:gUserId delegate:self];
    
    }
    //[self displayContactsFromLocalDatabase];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)cancelButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)doneButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
        
    NSString *membersList=@"";
    
    if ([[AppDelegate sharedAppDelegate].arrSelectedContactList count]>0) {
        
        membersList=[[AppDelegate sharedAppDelegate].arrSelectedContactList objectAtIndex:0];
        for (int i=1; i<[[AppDelegate sharedAppDelegate].arrSelectedContactList count]; i++) 
        {
            membersList=[membersList stringByAppendingFormat:@"%@",@","];
            
            membersList=[membersList stringByAppendingFormat:@"%@",[[AppDelegate sharedAppDelegate].arrSelectedContactList objectAtIndex:i]];
        }
        
        [AppDelegate sharedAppDelegate].selectedMembers=membersList;
    }

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
    
    rowCount=[self.arrContactList count];
    
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    height=60;
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",self.arrContactList);
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (AddMembersTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (Nil == cell) 
    {
        cell = [AddMembersTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSString *userName=[[self.arrContactList objectAtIndex:indexPath.row] objectForKey:@"user_name"];
    NSString *userImage=[[self.arrContactList objectAtIndex:indexPath.row] objectForKey:@"user_image"];
    
    cell.lblName.text= userName;    
        
    
    if (userImage==nil || userImage==(NSString *)[NSNull null] || [userImage isEqualToString:@""]) {
        [cell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
    } 
    else 
    {         
        NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,userImage];

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
    
    if ([self.checkContactView isEqualToString:@"Share Group"]) {
      
        [cell.btnSelectFriend setHidden:TRUE];
    }
    
    else
    {
        
        BOOL checkMarkFlag=TRUE;
        
        NSString *fId=[[self.arrContactList objectAtIndex:indexPath.row]objectForKey:@"user_id"];
        
        for (int i=0; i<[[AppDelegate sharedAppDelegate].arrSelectedContactList count]; i++) {
            
            NSString *selectedFriendId=[[AppDelegate sharedAppDelegate].arrSelectedContactList objectAtIndex:i];
            
            if([selectedFriendId isEqualToString:fId])
            {
                
                checkMarkFlag=FALSE;
                break;
                
            }
            else {
                
                
                checkMarkFlag=TRUE;
            }
            
        }
        
        NSLog(@"%d",[[AppDelegate sharedAppDelegate].arrSelectedContactList count]);
        
        if (checkMarkFlag==FALSE) {
            
            [cell.btnSelectFriend setTitle:@"1" forState:UIControlStateReserved];    
            
            cell.btnSelectFriend.tag=1;
            [cell.btnSelectFriend setSelected:YES];
            
        }
        else
        {
            cell.btnSelectFriend.tag=0;
            [cell.btnSelectFriend setTitle:@"0" forState:UIControlStateReserved];    
            
            [cell.btnSelectFriend setSelected:NO];
            
        }
        
        if ([fId isEqualToString:@"100"]) {
            
            [cell.btnSelectFriend setHidden:TRUE];

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
    if ([self.checkContactView isEqualToString:@"Share Group"]) {
        
        self.friendId=[[self.arrContactList objectAtIndex:indexPath.row] objectForKey:@"user_id"];
        
        if (![self.friendId isEqualToString:@"100"]) {
            

            shareAlert = [[UIAlertView alloc] initWithTitle:@"Enter Group Number !"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Continue", nil];
            [shareAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField * alertTextField = [shareAlert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            alertTextField.text=@"#";
            [shareAlert show];
            [shareAlert release];

        }

        
        /*shareAlert = [[UIAlertView alloc] initWithTitle:@"Enter Group Code !" message:@"  " delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Send", nil];
        txtShareGroup = [[UITextField alloc] initWithFrame:CGRectMake(12.0, -35, 260.0, 25.0)];
        [txtShareGroup setBackgroundColor:[UIColor whiteColor]];
        CGAffineTransform myTrans = CGAffineTransformMakeTranslation(0.0, 80.0);
        [txtShareGroup setTransform:myTrans];
        txtShareGroup.delegate=self;
        [txtShareGroup setKeyboardType:UIKeyboardTypeNumberPad];
        [shareAlert addSubview:txtShareGroup];
        [shareAlert show];
        [shareAlert release];*/
    }
    else if ([self.checkContactView isEqualToString:@"Create Group"])
    {
        
    }
   
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void) buttonSelectFriend:(AddMembersTableViewCell *)cellValue
{    
    NSLog(@"%d",[[AppDelegate sharedAppDelegate].arrSelectedContactList count]);
    NSIndexPath * indexPath = [self.tblView indexPathForCell:cellValue];
    
    NSString *status=[cellValue.btnSelectFriend titleForState:UIControlStateReserved];
    NSString *fId=[[self.arrContactList objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    
    NSLog(@"%d",cellValue.tag);
    
    
    if ([status isEqualToString:@"0"]) {
        
        [cellValue.btnSelectFriend setTag:1];
        [cellValue.btnSelectFriend setSelected:YES];
        
        [[AppDelegate sharedAppDelegate].arrSelectedContactList addObject:fId];
    }
    
    else
    {
        [cellValue.btnSelectFriend setTag:0];
        [cellValue.btnSelectFriend setSelected:NO];
        [[AppDelegate sharedAppDelegate].arrSelectedContactList removeObject:fId];
        
    }
    
    [self.tblView reloadData];
}
#pragma mark------------------
#pragma Webservice methods

-(void)ContactListInvocationDidFinish:(ContactListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    
    [self.arrContactList removeAllObjects];
    
    NSLog(@"%@",msg);
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        if ([result count]>0) {
            
            NSMutableArray *responseArray=[result objectForKey:@"contacts"];

            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"user_id",@"user_name",@"user_image",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
            
                if (![[arrValue valueForKey:@"user_id"] isEqualToString:@"100"]) {
                    
                    NSString * contactId=[arrValue valueForKey:@"user_id"];
                    NSString * contactName=[arrValue valueForKey:@"user_name"];
                    NSString * contactImage=[arrValue valueForKey:@"user_image"];
                    
                    [self.arrContactList addObject:[NSDictionary dictionaryWithObjectsAndKeys:contactName,@"user_name",contactId,@"user_id",contactImage,@"user_image",nil]];
                }
               

                
            }
            
            [arrOfResponseField release];
        }
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    
    moveTabG=FALSE;
    
    [self.tblView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)ShareGroupInvocationDidFinish:(ShareGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
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

#pragma mark-----------
#pragma UIAlertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==shareAlert) {
        
        /*if (buttonIndex==1) {
            
            if ([txtShareGroup.text length]>0) {
                
                int status=[[AppDelegate sharedAppDelegate] netStatus];
                
                if(status==0)
                {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [service ShareGroupInvocation:gUserId groupId:self.groupId friendId:self.friendId groupCode:txtShareGroup.text delegate:self];
                }

            }
            
                   
        }*/
        
        if (buttonIndex==1) {
            
            NSString *inputText = [[shareAlert textFieldAtIndex:0] text];
            
            if ([inputText length]>0) {
                
                int status=[[AppDelegate sharedAppDelegate] netStatus];
                
                if(status==0)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [service ShareGroupInvocation:gUserId groupId:self.groupId friendId:self.friendId groupCode:inputText delegate:self];
                    
                }
                
                
                NSLog(@"mukesh2345");
                
            }
        }
    }
}

- (void)viewDidUnload
{
    _arrContactList=nil;
    self.checkContactView=nil;
    self.groupId=nil;
    self.friendId=nil;
    self.tblView=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    self.checkContactView=nil;
    self.groupId=nil;
    self.friendId=nil;
    self.tblView=nil;

    [_arrContactList release];
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
