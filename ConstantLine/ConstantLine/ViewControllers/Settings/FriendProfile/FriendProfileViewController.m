//
//  FriendProfileViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FriendProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "JSON.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserProfileData.h"
#import "EditProfileViewController.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "ChatViewController.h"
#import "QSStrings.h"

@implementation FriendProfileViewController

@synthesize ratingStr,userId,navTitle,checkView,checkChatButtonStatus,arrImageAudioPath;

@synthesize arrUserProfileData=_arrUserProfileData;

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
    
    if (self.arrUserProfileData!=nil) {
        
        self.arrUserProfileData=nil;
    }
    self.arrUserProfileData=[[NSMutableArray alloc] init];

    
    imgView.layer.cornerRadius =50;
    imgView.clipsToBounds = YES;
    [imgView.layer setBorderWidth:5.0];
    [imgView.layer setBorderColor:[[UIColor whiteColor] CGColor]];

    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   

    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"User Info"];
    
    imgView.layer.cornerRadius =44;
    imgView.clipsToBounds = YES;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    if ([checkChatButtonStatus isEqualToString:@"YES"]) {
        
        btnChat=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnChat setBackgroundImage:[UIImage imageNamed:@"msg_icon"] forState:UIControlStateNormal];
        [btnChat setFrame:CGRectMake(0,6, 40,40)];
        [btnChat setTitle: @"" forState:UIControlStateNormal];
        btnChat.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
        [btnChat addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *chatBtn=[[[UIBarButtonItem alloc]initWithCustomView:btnChat]autorelease];
        self.navigationItem.rightBarButtonItem=chatBtn;
        
        
        
    }
   
    
        [btnAddContacts setHidden:TRUE];
    
    if ([self.checkView isEqualToString:@"Other"]) {
        
        [btnClear setHidden:TRUE];

    }
    else{
        [btnClear setFrame:CGRectMake(btnClear.frame.origin.x, 374, btnClear.frame.size.width, btnClear.frame.size.height)];
        
        [btnClear setHidden:FALSE];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 568)];
            
            
        }
        else
        {
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 568-IPHONE_FIVE_FACTOR)];
            
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y,scrollView.frame.size.width, 480)];
            
            
        }
        else
        {
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 480-IPHONE_FIVE_FACTOR)];
            
            
            
            
        }
        
    }

    
    checkPN=@"YES";
    
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
        
        service=[[ConstantLineServices alloc] init];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [service FriendProfileInvocation:gUserId friendId:self.userId delegate:self]; 
            
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    checkPN=@"NO";
    [objImageCache cancelDownload];
    objImageCache=nil;
    service=nil;
}

-(void)setvalues
{
    UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
    lbluserName.text=data.user_name;
    lblDispName.text=data.display_name;
    lblEmail.text=data.email;
    lblPhoneNumber.text=data.phone_num;
    lblDob.text=data.dob;
    ratingStr=data.rating;
    lblNumOfGroup.text=data.num_of_groups;
    lblGender.text=[data.gender capitalizedString];
    txtIntro.text=data.intro;

    if ([data.friend_status isEqualToString:@"0"])
    {
        
        [btnAddContacts setHidden:FALSE];
        [btnAddContacts setFrame:CGRectMake(btnAddContacts.frame.origin.x, 374, btnAddContacts.frame.size.width, btnAddContacts.frame.size.height)];
        [btnClear setFrame:CGRectMake(btnClear.frame.origin.x, 427, btnClear.frame.size.width, btnClear.frame.size.height)];

    }
    else
    {
        [btnAddContacts setHidden:TRUE];
        
        [btnClear setFrame:CGRectMake(btnClear.frame.origin.x, 374, btnClear.frame.size.width, btnClear.frame.size.height)];
    }
    NSLog(@"%@",data.rating);
    
    [self setRating];
    [self setImage];
}
-(void)setRating
{
    if ([ratingStr isEqualToString:@""] || [ratingStr isEqualToString:@"0"]) {
        
        [btnRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([ratingStr isEqualToString:@"1"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([ratingStr isEqualToString:@"2"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"3"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"4"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"5"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}
-(void)setImage
{
    UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.user_image];
    
    NSLog(@"%@",imageurl);
    
    if (data.user_image==nil || data.user_image==(NSString *)[NSNull null] || [data.user_image isEqualToString:@""]) {
        
        
        [imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    } 
    else
    {        
        if (imageurl && [imageurl length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:imageurl];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(180, 180);
                }
                else{
                    kImgSize_1=CGSizeMake(180, 180);
                }
                
                [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
            }
            else {
                
                [imgView setImage:img];
            }
            
        }
        
    }
    
   
    
}
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self setImage];
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
        
}

-(IBAction)chatButtonClick:(id)sender
{
    if (moveTabG==FALSE) {
        
        UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
        
        [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";
        
        ChatViewController *objChatViewController;
        
        objChatViewController=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            
        objChatViewController.friendUserName=data.user_name;
        objChatViewController.groupType=@"0";
        objChatViewController.friendId=data.user_id;
        objChatViewController.groupId=@"0";
        objChatViewController.groupTitle=@"";

        NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.user_image];
        
        objChatViewController.friendUserImage=imageUrl;
        
        [self.navigationController pushViewController:objChatViewController animated:YES];
        
        [objChatViewController release];

    }
      
}
-(IBAction)btnAddContactPressed:(id)sender
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
-(IBAction)btnClearPressed:(id)sender
{
    clearAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want to clear all messages?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [clearAlert show];
    [clearAlert release];
}
-(IBAction)btnratingPressed1:(id)sender
{
    
}
-(IBAction)btnratingPressed2:(id)sender
{
    
}
-(IBAction)btnratingPressed3:(id)sender
{
    
}
-(IBAction)btnratingPressed4:(id)sender
{
    
}
-(IBAction)btnratingPressed5:(id)sender
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==clearAlert) {
        
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
                [service ClearIndivisualChatInvocation:gUserId friendId:self.userId delegate:self];
                
            }

        }
    }
    
    if (alertView==clearSuccessAlert) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
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
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [service AddContactListInvocation:gUserId friendId:self.userId intro:base64String delegate:self];
               
                
            }
                
            }

        }
       
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
/*- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView==addContactAlert) {
        
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
    else
    {
        return YES;
 
    }
}*/
#pragma ------------
#pragma Webservice delegate


-(void)FriendProfileInvocationDidFinish:(FriendProfileInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSDictionary *responsedic=[result objectForKey:@"response"];
    
    [self.arrUserProfileData removeAllObjects];
    
    NSString *errorStr=[responsedic objectForKey:@"error"];
    
    if (errorStr==nil || errorStr==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[responsedic objectForKey:@"success"];
        
        NSLog(@"%d",[responseArray count]);
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"display_name",@"dob",@"email",@"gender",@"no_of_groups",@"rating",@"user_id",@"user_image",@"user_name",@"phone_no",@"friend_status",@"intro",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                UserProfileData *data=[[[UserProfileData alloc] init] autorelease];
                
                data.user_id= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                data.user_name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                data.display_name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"display_name"]];
                data.email=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"email"]];   
                data.gender=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"gender"]];
                data.dob=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"dob"]];
                data.rating=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"rating"]];
                data.user_image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
                data.phone_num=[arrValue valueForKey:@"phone_no"];
                data.num_of_groups= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"no_of_groups"]];
                data.friend_status= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"friend_status"]];
                data.intro= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];

                if ([data.num_of_groups isEqualToString:@""]) {
                    
                    data.num_of_groups=@"0";
                }
                
                
                
                NSLog(@"%@",data.rating);
                
                [self.arrUserProfileData addObject:data];
            }
            
            [arrOfResponseField release];
            
            
            
        }
        
        
        [self setvalues];
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    
    
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)AddContactListInvocationDidFinish:(AddContactListInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error{
    
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

        [AppDelegate sharedAppDelegate].friendStatus=@"1";
        
        [btnAddContacts setHidden:TRUE];
        [btnClear setFrame:CGRectMake(btnClear.frame.origin.x, 374, btnClear.frame.size.width, btnClear.frame.size.height)];

    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)ClearIndivisualChatInvocationDidFinish:(ClearIndivisualChatInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error{
    
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        self.arrImageAudioPath=[[NSMutableArray alloc] init];
        
        [self getAllImagePath];

        clearSuccessAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [clearSuccessAlert show];
        [clearSuccessAlert release];
        
        
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)getAllImagePath
{
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT ImageId FROM tbl_chat where ZChatId='%@' and ContentType='%@'",self.threadId,@"2"];
    
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
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT AudioId FROM tbl_chat where ZChatId='%@' and ContentType='%@'",self.threadId,@"3"];
    
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
    NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat where ZChatId='%@'",self.threadId];
    
    NSLog(@"%@",sqlStatement);
    
    if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
    {
        NSLog(@"success");
        
        
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

#pragma mark ------------Delegate-----------------
#pragma mark Sqlite method



- (void)viewDidUnload
{
    _arrUserProfileData=nil;
    self.ratingStr=nil;
    self.userId=nil;
    self.navTitle=nil;
    self.checkView=nil;
    self.checkChatButtonStatus=nil;
    self.threadId=nil;
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    self.ratingStr=nil;
    self.userId=nil;
    self.navTitle=nil;
    self.checkView=nil;
    self.checkChatButtonStatus=nil;
    self.threadId=nil;
    [_arrUserProfileData release];
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
