//
//  PhoneContactsViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PhoneContactsViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "ContactTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation PhoneContactsViewController

@synthesize tblView,phoneNumList,friendId;

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
    self.arrContactList=[[NSMutableArray alloc] init];

    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Phone Contacts"];
    
    //[[UIApplication sharedApplication] openURL: @"sms:12345678"];
    //http://blog.mugunthkumar.com/coding/iphone-tutorial-how-to-send-in-app-sms/
    
    // Do any additional setup after loading the view from its nib.
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=leftBtn;
    [leftBtn release];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    [self.tblView setContentOffset:CGPointMake(0, 0)];
    
    self.tblView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"list_divider.png"]];
    
    if(status==0)
    {        
        self.tblView.delegate=self;
        self.tblView.dataSource=self;
        
        NSMutableArray *responseArray=[[NSMutableArray alloc] init];
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                
                // First time access has been granted, add the contact
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            
            NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            NSLog(@"%d",[thePeople count]);
            
            for (id person in thePeople)
            {
                
                NSString *strFirstName1 = (NSString *)ABRecordCopyCompositeName(person);
                
                NSLog(@"%@",strFirstName1);
                
                ABMultiValueRef phone=ABRecordCopyValue(person, kABPersonPhoneProperty);
                
                if (ABMultiValueGetCount(phone) > 0) {
                    {
                        NSString *phoneNumber = (NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                        
                        [responseArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:strFirstName1,@"display_name",phoneNumber,@"phone_no",nil]];
                        
                        [phoneNumber release];
                    }
                }
                [strFirstName1 release];
                CFRelease(phone);
                
            }
            
            if ([responseArray count]>0) {
                
                
                NSSortDescriptor *firstDescriptor =[[[NSSortDescriptor alloc] initWithKey:@"display_name"
                                                                                ascending:YES
                                                                                 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
                
                NSArray *descriptors = [NSArray arrayWithObjects: firstDescriptor, nil];
                NSArray *sortedArray = [responseArray sortedArrayUsingDescriptors:descriptors];
                
                
                NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"display_name",@"phone_no",nil];
                
                for (NSMutableArray *arrValue in sortedArray) {
                    
                    for (int i=0;i<[arrOfResponseField count];i++) {
                        
                        if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                            
                            [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                        }
                    }
                    
                    ContactListData *data=[[ContactListData alloc] init] ;
                    
                    data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"display_name"]];
                    data.phoneNo=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"phone_no"]];
                    
                    [self.arrContactList addObject:data];
                    [data release];
                    
                }
                
                [arrOfResponseField release];
                
                self.arrSearchContactList=[[NSMutableArray alloc] init];
                [self.arrSearchContactList addObjectsFromArray:self.arrContactList];
                
                
            }
            
            [responseArray release];
                       // The user has previously given access, add the contact
        }
        else {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:Nil message:@"You don't have permission of access contacts" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            NSLog(@"ddddddddddd");

            
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
        }
        
        
    }
    
    else
    {
        moveTabG=FALSE;
    }
    
    if ([self.arrContactList count]>0) {
        
        [lblNoResult setHidden:TRUE];
    }
    else
    {
        [lblNoResult setHidden:FALSE];
    }

    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

    // Do any additional setup after loading the view from its
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
        
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    [lblNoResult setHidden:TRUE];
    
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
    
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (RecommandedTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (Nil == cell) 
    {
        cell = [RecommandedTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.btnAddFriend setHidden:TRUE];
    
    ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
    
    cell.lblName.text=data.name;
    [cell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
    [cell.btnAddFriend setTitle:@"Invite" forState:UIControlStateNormal];
    
    [cell.btnAddFriend setFrame:CGRectMake(250, cell.btnAddFriend.frame.origin.y, 60, cell.btnAddFriend.frame.size.height)];
    
    [cell.btnAddFriend setTitle:data.phoneNo forState:UIControlStateReserved];
    
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
    
    phoneNum=data.phoneNo;
    userName=data.name;
    
    phoneAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want to add this member in your contact list" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [phoneAlert show];
    
}
-(void) buttonAddFriend:(ContactTableViewCell*)cellValue
{    
    phoneNum=[NSString stringWithFormat:@"%@",[cellValue.btnAddFriend titleForState:UIControlStateReserved]];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
    if (service!=nil) {
        
        service=nil;
    }
    
    service=[[ConstantLineServices alloc] init];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [service SendPhoneContactsInvocation:gUserId phoneList:phoneNum userName:userName delegate:self];
    
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==phoneAlert) {
        
        if (buttonIndex==1) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
            if (service!=nil) {
                
                service=nil;
            }
            
            service=[[ConstantLineServices alloc] init];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSLog(@"%@",userName);
            NSLog(@"%@",phoneNum);
            
            [service SendPhoneContactsInvocation:gUserId phoneList:phoneNum userName:userName delegate:self];
            
            }
        }
    }
    
    if (alertView==addContactAlert) {
        
        if (buttonIndex==1) {
            
           // NSString *inputText = [[addContactAlert textFieldAtIndex:0] text];
            NSString *inputText = alertTextField.text;

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
                [service AddContactListInvocation:gUserId friendId:self.friendId intro:base64String delegate:self];
                
            }
                
                
            }
        }
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
            NSLog(@"failed");
            
            UIAlertView *failedAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Invitation failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failedAlert show];
            [failedAlert release];
			
            break;
		case MessageComposeResultSent:
            NSLog(@"sent");
            
            UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Invitation has been sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
            [successAlert release];
            
            
			break;
		default:
			break;
	}
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
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
    
    [searchBar resignFirstResponder];
    [lblNoResult setHidden:TRUE];
	[searchBar1 resignFirstResponder];
	searchBar1.text = @"";
    
    if (self.arrContactList.count>0) {
        [self.arrContactList removeAllObjects];
    }
    for(int i=0;i<self.arrSearchContactList.count;i++){
        
        [self.arrContactList addObject:[self.arrSearchContactList objectAtIndex:i]];
    }
    
    
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
    //service=nil;
    
    [searchBar resignFirstResponder];
    //tblView.delegate=nil;
    //tblView.dataSource=nil;
}

#pragma --------------
#pragma Webservice delegate

/*-(void)SendPhoneContactsInvocationDidFinish:(SendPhoneContactsInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
 {
 NSDictionary *responsedic=[result objectForKey:@"response"];
 
 NSString *errorStr=[responsedic objectForKey:@"error"];
 
 if (errorStr==nil || errorStr==(NSString*)[NSNull null]) {
 
 NSMutableArray *responseArray=[responsedic objectForKey:@"success"];
 
 NSLog(@"%d",[responseArray count]);
 
 if ([responseArray count]>0) {
 
 NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"display_name",@"dob",@"email",@"gender",@"no_of_groups",@"rating",@"user_id",@"user_image",@"user_name",@"phone_no",nil];
 
 for (NSMutableArray *arrValue in responseArray) {
 
 for (int i=0;i<[arrOfResponseField count];i++) {
 
 if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
 
 [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
 }
 }
 
 ContactListData *data=[[ContactListData alloc] init];
 
 data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
 data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"display_name"]];
 data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
 data.phoneNo=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"phone_no"]];   
 
 }
 
 }
 
 
 }
 else {
 UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
 [alert show];
 
 }
 
 }*/

-(void)SendPhoneContactsInvocationDidFinish:(SendPhoneContactsInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    NSDictionary *responsedic=[result objectForKey:@"response"];
    
    NSString *errorStr=[responsedic objectForKey:@"error"];
    self.friendId=[responsedic objectForKey:@"success"];
    
    
    if (errorStr==nil || errorStr==(NSString*)[NSNull null]) {
        
        
        
    }
    else
    {
        if (self.friendId==nil || self.friendId==(NSString*)[NSNull null] || [self.friendId isEqualToString:@""]) {
            
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"Hello from WellConnected";
                controller.recipients = [NSArray arrayWithObjects:phoneNum, nil];
                controller.messageComposeDelegate = self;
                
                [self presentViewController:controller animated:YES completion:nil];

            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
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
                [alertTextField setFont:[UIFont systemFontOfSize:15]];

                alertTextField.delegate=self;
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
        
        
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        
    }
    return YES;
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


-(void)viewDidUnload
{
    _arrContactList=nil;
    _arrSearchContactList=nil;
    self.tblView=nil;
    self.phoneNumList=nil;
}
-(void)dealloc
{
    [_arrContactList release];
    [_arrSearchContactList release];
    self.tblView=nil;
    self.phoneNumList=nil;
    
    [super dealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
