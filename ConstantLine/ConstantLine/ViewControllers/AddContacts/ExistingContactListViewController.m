//
//  ExistingContactListViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ExistingContactListViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "ContactTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"
#import "UserProfileViewController.h"
#import "QSStrings.h"

@implementation ExistingContactListViewController

@synthesize tblView,checkView,friendId;

@synthesize arrContactList=_arrContactList;
@synthesize arrSearchContactList=_arrSearchContactList;

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
    
    if (self.arrContactList!=nil) {
        
        self.arrContactList=nil;
    }
    
    if (self.arrSearchContactList!=nil) {
        
        self.arrSearchContactList=nil;
    }
    self.arrContactList=[[NSMutableArray alloc] init];
    
    self.arrSearchContactList=[[NSMutableArray alloc] init];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"WellConnected Users"];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftBtn;
    [leftBtn release];

    // Do any additional setup after loading the view from its nib.
  /*  UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton setFrame:CGRectMake(0,0, 25,29)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=left;*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    
    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
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
        [service ExistingAppUsersListInvocation:gUserId searchString:@"" delegate:self];
        
    }

}
- (void)didReceiveBackgroundNotification:(NSNotification*) note
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)backButtonClick:(UIButton *)sender{
   
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [lblNoResult setHidden:TRUE];
    
    if (objImageCache!=nil) {
        
        objImageCache=nil;
    }
    objImageCache=[[ImageCache alloc] init];
    objImageCache.delegate=self;

    self.tblView.delegate=self;
    self.tblView.dataSource=self;
    
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
   
    [self.tblView setContentOffset:CGPointMake(0, 0)];

   }
#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrContactList count];
    
    //rowCount=10;
    
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
    
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
   
    [cell.btnAddFriend setTitle:data.userId forState:UIControlStateReserved];
    
     NSLog(@"data.status %@",data.status);
    
    if ([checkView isEqualToString:@"namecard"]) {

        [cell.btnAddFriend setHidden:TRUE];

    }
    else{
        if ([data.status isEqualToString:@"0"]) {
            
            [cell.btnAddFriend setHidden:FALSE];
            
        }
        else{
            [cell.btnAddFriend setHidden:TRUE];
            
        }

    }
    
    
    cell.lblName.text= data.name;
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
    
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        
        [cell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
    
    if ([checkView isEqualToString:@"namecard"]) {
        
        [AppDelegate sharedAppDelegate].nameCardId=data.userId;
        [AppDelegate sharedAppDelegate].checkNameCard=@"YES";
        [AppDelegate sharedAppDelegate].nameCardName=data.userName;
        
        NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
        [AppDelegate sharedAppDelegate].nameCardImage=imageurl;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";

        if ([data.userId isEqualToString:gUserId]) {
            
          
                objUserProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];

            objUserProfileViewController.userId=data.userId;
            objUserProfileViewController.navTitle=data.userName;
            [self.navigationController pushViewController:objUserProfileViewController animated:YES];
        }
        else
        {
           
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];

            objFriendProfileViewController.userId=data.userId;
            objFriendProfileViewController.navTitle=data.userName;
            objFriendProfileViewController.checkView=@"Other";
            objFriendProfileViewController.checkChatButtonStatus=@"YES";

            [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
        }
        

              
    }
    
}
-(void) buttonAddFriend:(ContactTableViewCell*)cellValue
{
   /*

    addContactAlert = [[UIAlertView alloc] initWithTitle:@"Enter message !"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Continue", nil];
    [addContactAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField * alertTextField = [addContactAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    [addContactAlert show];
    [addContactAlert release];*/
    
    self.friendId=[NSString stringWithFormat:@"%@",[cellValue.btnAddFriend titleForState:UIControlStateReserved]];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
    addContactAlert = [[UIAlertView alloc] initWithTitle:@"Tell your new friend why you 2 should be connected"
                                                     message:Nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Continue", nil];
    
    alertTextField = [[UITextView alloc]
                              initWithFrame:CGRectMake(20.0, 30.0, 245.0, 60.0)];
    [alertTextField setBackgroundColor:[UIColor whiteColor]];
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        alertTextField.keyboardType=UIKeyboardTypeDefault;
        alertTextField.delegate=self;
        [alertTextField setFont:[UIFont systemFontOfSize:15]];

    [addContactAlert setValue:alertTextField forKey:@"accessoryView"];
    [alertTextField release];
    [addContactAlert show];
    [addContactAlert release];
    
}
    else
    {
        
        addContactAlert = [[UIAlertView alloc] initWithTitle:@"Tell your new friend why you 2 should be connected" message:@"                                                                                    " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        
        [addContactAlert setFrame:CGRectMake(addContactAlert.frame.origin.x, addContactAlert.frame.origin.y, addContactAlert.frame.size.width, 400)];
        
        alertTextField= [[UITextView alloc] initWithFrame:CGRectMake(20.0, 60, 245.0, 40.0)];
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        alertTextField.keyboardType=UIKeyboardTypeDefault;
        alertTextField.delegate=self;
        [alertTextField setBackgroundColor:[UIColor whiteColor]];
        [alertTextField setFont:[UIFont systemFontOfSize:15]];

        [addContactAlert addSubview:alertTextField];
        [addContactAlert show];
        [addContactAlert release];
    }

    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range1 replacementText:(NSString *)text
{
    
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range1 withString:text];
    
    NSLog(@"input %d chars", newText.length);
    
    totalCharacterCount=80-newText.length;
    
    if (totalCharacterCount>=0 && totalCharacterCount<=80) {
        
        if ([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
           
            
        }
        return YES;
        
    }else{
        if ([text isEqualToString:@"\n"])
        {
            
            [textView resignFirstResponder];
            
            
        }
        return NO;
    }
    
    
	return YES;
    
}
#pragma mark Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==addContactAlert) {
        
        if (buttonIndex==1) {
            
           // NSString *inputText = [[addContactAlert textFieldAtIndex:0] text];
           NSString *inputText = alertTextField.text;
            
            NSLog(@"%@",inputText);
            
            if ([inputText length]>0) {
                
                int status=[[AppDelegate sharedAppDelegate] netStatus];
                    
                    if(status==0)
                    {
                        
                        NSString *base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                      NULL,
                                                                                                      (CFStringRef)inputText,
                                                                                                      NULL,
                                                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                      kCFStringEncodingUTF8 ) autorelease];
                        
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [service AddContactListInvocation:gUserId friendId:self.friendId intro:base64String delegate:self];
                        
                        
                    }

                }
                
            }
        
    }

}
/*- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 && [inputText length]<=80)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
*/
#pragma mark Textfield delegate


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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [service ExistingAppUsersListInvocation:gUserId searchString:searchBar.text delegate:self];
    
	//[self handleSearchForTerm:searchBar.text];
}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    searchBar1.showsCancelButton = YES;
    //[self handleSearchForTerm:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
    [lblNoResult setHidden:TRUE];
    [searchBar resignFirstResponder];
    
	[searchBar1 resignFirstResponder];
	searchBar1.text = @"";
    
    if (self.arrContactList.count>0) {
        [self.arrContactList removeAllObjects];
        [self.arrSearchContactList removeAllObjects];
    }
    /*for(int i=0;i<self.arrSearchContactList.count;i++){
        
        [self.arrContactList addObject:[self.arrSearchContactList objectAtIndex:i]];
    }*/
    
    
    [self.tblView reloadData];
    
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    
    if ([searchTerm length] != 0)
	{
        [self.arrContactList removeAllObjects];
        
        for (int i=0; i<[self.arrSearchContactList count]; i++)
		{
            ContactListData *data=[self.arrSearchContactList objectAtIndex:i];
			
            NSLog(@"%@",data.name);
            
            NSRange r=[data.name rangeOfString:searchTerm options:NSCaseInsensitiveSearch];
            
            if(r.location != NSNotFound)
			{
                [self.arrContactList addObject:data];
            }
			
		}
	}else{
        if (self.arrContactList.count>0) {
            
            [self.arrContactList removeAllObjects];
        }
        for(int i=0;i<self.arrSearchContactList.count;i++){
            
            [self.arrContactList addObject:[self.arrSearchContactList objectAtIndex:i]];
        }
        
        
    }
    
    if ([self.arrContactList count]>0) {
        
        [lblNoResult setHidden:TRUE];
    }
    else
    {
        [lblNoResult setHidden:FALSE];
    }
    
	[self.tblView reloadData];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    service=nil;
    [objImageCache cancelDownload];
    objImageCache=nil;
    [searchBar resignFirstResponder];
    tblView.delegate=nil;
    tblView.dataSource=nil;
}


-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}

#pragma ----------
#pragma web service delegate

-(void)ExistingAppUsersListInvocationDidFinish:(ExistingAppUsersListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrContactList removeAllObjects];
    [self.arrSearchContactList removeAllObjects];
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"existingusers"];
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"user_id",@"user_image",@"user_name",@"status",@"displayname",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                ContactListData *data=[[[ContactListData alloc] init] autorelease];
                
                data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
                data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                data.userName=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                
                data.status=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"status"]];               
                [self.arrContactList addObject:data];
            }
            
            [arrOfResponseField release];
            
            [self.arrSearchContactList addObjectsFromArray:self.arrContactList];
        }
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    if ([self.arrContactList count]>0) {
        
        [lblNoResult setHidden:TRUE];
    }
    else
    {
        [lblNoResult setHidden:FALSE];
    }

    [self.tblView reloadData];
    [self.tblView setHidden:FALSE];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    moveTabG=FALSE;
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
        [service ExistingAppUsersListInvocation:gUserId searchString:searchBar.text delegate:self];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];   
        [alert release];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    moveTabG=FALSE;
}


- (void)viewDidUnload
{
    _arrContactList=nil;
    _arrSearchContactList=nil;
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrSearchContactList release];
    [_arrContactList release];
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
