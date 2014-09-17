//
//  StartGroupViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "StartGroupViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "Config.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "SubscriptionPlanViewController.h"
#import "AddMemberInGroupViewController.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "UIImageExtras.h"
#import "QSStrings.h"

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation StartGroupViewController

@synthesize localImageName,imageData,groupUniqueMember,groupId;

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
    
    [imgGroup.layer setBorderWidth:2.0];
    [imgGroup.layer setBorderColor:[[UIColor grayColor] CGColor]];


    imgPopOverView.layer.cornerRadius =5;
    imgPopOverView.clipsToBounds = YES;

    [imgBackPopOverView setAlpha:0.4];
   
    txtMemberShip.text=@"Paid";
    
    groupStatus=@"0";
    
    [lblMemberSelected setHidden:TRUE];
    
    gSubscriptionPlan=@"0";
    gSubscriptionCharge=@"0";
    gFeetype=@"1";
    
    txtTrialPeriod.text=[NSString stringWithFormat:@"%@%@",gSubscriptionPlan,@" Month"];
    
    txtSubscription.text=@"Monthly";
    
    txtcharge.text=[NSString stringWithFormat:@"$%@",gSubscriptionCharge];
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Start Group"];
    
    [AppDelegate sharedAppDelegate].arrSelectedContactList=[[NSMutableArray alloc] init];
    [AppDelegate sharedAppDelegate].selectedMembers=@"";
    
    if (pickerArray!=nil) {
        pickerArray=nil;
    }
    
    pickerArray=[[NSMutableArray alloc] init];
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
  
    
    imgGroup.layer.cornerRadius =44;
    imgGroup.clipsToBounds = YES;
    
    scrollView.backgroundColor=[UIColor clearColor];
    
    if ([gCheckStartGroup isEqualToString:@"Menu"]) {
        
        UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [menuButton setFrame:CGRectMake(0,0, 25,29)];
        [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem=left;
    }
    else
    {
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0,0, 53,53)];
        [backButton setTitle: @"" forState:UIControlStateNormal];
        backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
        self.navigationItem.leftBarButtonItem=leftBtn;

    }
   
    
    /*UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:[UIImage imageNamed:@"done_btn.png"] forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(0,7, 50,29)];
    [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *doneButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)]autorelease];
    [doneButtoView addSubview:doneButton];
    
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:doneButtoView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;*/
    
    
    
    
    if (pickerView==nil) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 408, 320, 160)];
                
                toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 368, 320, 40)];

            }
            else
            {
                pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 408-IPHONE_FIVE_FACTOR, 320, 160)];
                
                toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 368-IPHONE_FIVE_FACTOR, 320, 40)];

                
            }
            
            
            toolBar.barStyle=UIBarStyleDefault;
            pickerView.backgroundColor=[UIColor whiteColor];
            
        }
        else{
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 320, 320, 160)];
                
                toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 280, 320, 40)];

            }
            else
            {
                pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 320-IPHONE_FIVE_FACTOR, 320, 160)];
                
                toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 280-IPHONE_FIVE_FACTOR, 320, 40)];

                
            }
            
            
        }
        
        [pickerView setDelegate:self];
        [pickerView setShowsSelectionIndicator:TRUE];
        [self.view addSubview:pickerView];
    }
	
    [toolBar setHidden:TRUE];
	[pickerView setHidden:TRUE];
    
    
    UIBarButtonItem *btnAccessDone4 = [[[UIBarButtonItem alloc]
                                        initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnPickerDonePressed:)]autorelease];
	
	
	UIBarButtonItem *btnFlex4=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]autorelease];
    
    [toolBar setBackgroundColor:[UIColor blackColor]];
    [toolBar setItems:[NSArray arrayWithObjects:btnFlex4,btnAccessDone4,nil]];
    [toolBar setTintColor:[UIColor blackColor]];
    
    [self.view addSubview:toolBar];

    
       // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.imageData==Nil) {
        
        [lblTapTo setHidden:FALSE];
        [lblUploadImage setHidden:FALSE];

    }
    else{
        
        [lblUploadImage setHidden:TRUE];
        [lblTapTo setHidden:TRUE];
    }
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [scrollView setContentSize:CGSizeMake(320, 568)];

    }
    else
    {
        [scrollView setContentSize:CGSizeMake(320, 480)];

    }

 
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

-(IBAction)cancelButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDetailsPressed:(id)sender
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [popOverView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
        else
        {
            [popOverView setFrame:CGRectMake(0, 50, 320, self.view.frame.size.height)];
            
        }
        
     
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [popOverView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
        else
        {
            [popOverView setFrame:CGRectMake(0, 50, 320, self.view.frame.size.height)];
            
        }
        
        
    }


     [self.view addSubview:popOverView];
}
-(IBAction)btnOkPressed:(id)sender
{
    [popOverView removeFromSuperview];
}
-(IBAction)btnCancelPressed:(id)sender
{

    gSubscriptionPlan=@"0";
    gSubscriptionCharge=@"0";
    gFeetype=@"1";
    
    txtTrialPeriod.text=[NSString stringWithFormat:@"%@%@",gSubscriptionPlan,@" Month"];
    
    txtSubscription.text=@"Monthly";
    
    txtcharge.text=[NSString stringWithFormat:@"$%@",gSubscriptionCharge];

    [popOverView removeFromSuperview];

}
-(BOOL)checkGroupData
{
    
    txtTitle.text= [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtView.text= [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([txtTitle.text length]<=0 || txtTitle.text == nil || [txtTitle.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter group title"];
        return NO;
    }
    if ([txtView.text length]<=0 || txtView.text == nil || [txtView.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter group intro"];
        return NO;
    }
    if ([txtTitle.text length]<4 || [txtTitle.text length]>40)
    {
        [self showAlertViewWithTitel:@"" Message:@"Group title should be at least 4 Characters and maximum 40 Characters"];
        return NO;
    }
    
   /* if ([[AppDelegate sharedAppDelegate].arrSelectedContactList count]<=0)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please select members for group"];
        return NO;
    }*/
    
    return YES;
    
}
-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    [alertView release];
}
-(IBAction)doneButtonClick:(id)sender
{        
    BOOL isDataValid=[self checkGroupData];
    
    if(isDataValid){
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            NSDateFormatter *dateForMater=[[[NSDateFormatter alloc] init] autorelease];
            dateForMater.dateStyle = NSDateFormatterMediumStyle;
            [dateForMater setDateFormat:@"yyyy-MM-dd"];
            groupCreatedDate=[dateForMater stringFromDate:[NSDate date]];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if (self.imageData==nil) {
                
                [self performSelector:@selector(uploadData) withObject:nil afterDelay:0.1];
                
            }
            else
            {
                [self performSelector:@selector(uploadImage) withObject:nil afterDelay:0.1];
                
            }
        }
        
    }
}
-(IBAction)btnAddMembersPressed:(id)sender
{
    AddMemberInGroupViewController *objAddMember;
    
    objAddMember=[[AddMemberInGroupViewController alloc] initWithNibName:@"AddMemberInGroupViewController" bundle:nil];
    objAddMember.checkContactView=@"Create Group";
    [self.navigationController pushViewController:objAddMember animated:YES];
    [objAddMember release];
}
-(IBAction)btnSubscriptionPressed:(id)sender
{
    [pickerView removeFromSuperview];
    [toolBar removeFromSuperview];
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [self.view setFrame:CGRectMake(0, 0, 320, 568)];
            [pickerView setFrame:CGRectMake(0, 408, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368, 320, 40)];

            
            
        }
        else
        {
            [self.view setFrame:CGRectMake(0, 0, 320, 568-IPHONE_FIVE_FACTOR)];

            [pickerView setFrame:CGRectMake(0, 408-IPHONE_FIVE_FACTOR, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368-IPHONE_FIVE_FACTOR, 320, 40)];
            
            
        }
        
        
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [self.view setFrame:CGRectMake(0, 0, 320, 480+IPHONE_FIVE_FACTOR)];

            [pickerView setFrame:CGRectMake(0, 320, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280, 320, 40)];

            
        }
        else
        {
            [self.view setFrame:CGRectMake(0, 0, 320, 480)];

            [pickerView setFrame:CGRectMake(0, 320-IPHONE_FIVE_FACTOR, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280-IPHONE_FIVE_FACTOR, 320, 40)];
            
            
        }
        
        
    }

    
    [self.view addSubview:pickerView];
    [self.view addSubview:toolBar];
    
    [pickerArray removeAllObjects];
    
    [self scrollViewToCenterOfScreen:imgMemberShip];
    
    checkPickerView=@"Membership";
    
    [pickerArray addObject:@"Paid"];
    [pickerArray addObject:@"Free"];
   
    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    [pickerView reloadAllComponents];

    
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    imageAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take from camera",@"Take from library", nil];
    [imageAlert show];
}
-(IBAction)btnTrialPressed:(id)sender
{
    [pickerView removeFromSuperview];
    [toolBar removeFromSuperview];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [pickerView setFrame:CGRectMake(0, 408, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368, 320, 40)];
            
            
            
        }
        else
        {
            
            [pickerView setFrame:CGRectMake(0, 408-IPHONE_FIVE_FACTOR-50, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368-IPHONE_FIVE_FACTOR-50, 320, 40)];
            
            
        }
        
        
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [pickerView setFrame:CGRectMake(0, 320, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280, 320, 40)];
            
            
        }
        else
        {
            
            [pickerView setFrame:CGRectMake(0, 320-IPHONE_FIVE_FACTOR-50, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280-IPHONE_FIVE_FACTOR-50, 320, 40)];
            
            
        }
        
        
    }
    
    
    
    [popOverView addSubview:pickerView];
    [popOverView addSubview:toolBar];

    [pickerArray removeAllObjects];
    
    [self scrollViewToCenterOfScreen:imgTrial];
    
    checkPickerView=@"Period";
    
    for (int i=0; i<=12; i++) {
        
       [pickerArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    [pickerView reloadAllComponents];
}
-(IBAction)btnMonthlyFeePressed:(id)sender
{
    [pickerView removeFromSuperview];
    [toolBar removeFromSuperview];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [pickerView setFrame:CGRectMake(0, 408, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368, 320, 40)];
            
            
            
        }
        else
        {
            
            [pickerView setFrame:CGRectMake(0, 408-IPHONE_FIVE_FACTOR-50, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368-IPHONE_FIVE_FACTOR-50, 320, 40)];
            
            
        }
        
        
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [pickerView setFrame:CGRectMake(0, 320, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280, 320, 40)];
            
            
        }
        else
        {
            
            [pickerView setFrame:CGRectMake(0, 320-IPHONE_FIVE_FACTOR-50, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280-IPHONE_FIVE_FACTOR-50, 320, 40)];
            
            
        }
        
        
    }
    

    
    [popOverView addSubview:pickerView];
    [popOverView addSubview:toolBar];
    
    [self scrollViewToCenterOfScreen:imgMonthly];

    checkPickerView=@"Fee";
    
    [pickerArray removeAllObjects];
    
    [pickerArray addObject:@"Monthly"];
    [pickerArray addObject:@"Annual"];
   
    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    [pickerView reloadAllComponents];
}

-(IBAction)btnchargePressed:(id)sender
{
    
    [pickerView removeFromSuperview];
    [toolBar removeFromSuperview];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [pickerView setFrame:CGRectMake(0, 408, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368, 320, 40)];
            
            
            
        }
        else
        {
            
            [pickerView setFrame:CGRectMake(0, 408-IPHONE_FIVE_FACTOR-50, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 368-IPHONE_FIVE_FACTOR-50, 320, 40)];
            
            
        }
        
        
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [pickerView setFrame:CGRectMake(0, 320, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280, 320, 40)];
            
            
        }
        else
        {
            
            [pickerView setFrame:CGRectMake(0, 320-IPHONE_FIVE_FACTOR-50, 320, 160)];
            [toolBar setFrame:CGRectMake(0, 280-IPHONE_FIVE_FACTOR-50, 320, 40)];
            
            
        }
        
        
    }
    
    

    [popOverView addSubview:pickerView];
    [popOverView addSubview:toolBar];
    
    [self scrollViewToCenterOfScreen:imgPrice];
    
    checkPickerView=@"Charge";
    
    [pickerArray removeAllObjects];
    
    [pickerArray addObject:@"0"];
    [pickerArray addObject:@"1"];
    [pickerArray addObject:@"2"];
    [pickerArray addObject:@"5"];
    [pickerArray addObject:@"10"];
    [pickerArray addObject:@"20"];
    [pickerArray addObject:@"50"];
    [pickerArray addObject:@"100"];
    
    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    [pickerView reloadAllComponents];
}


#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    [self scrollViewToCenterOfScreen:textField];
    
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
    
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
    CGFloat availableHeight = applicationFrame.size.height - 245;           	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
    [popOverScroll setContentOffset:CGPointMake(0, y) animated:YES];

}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField) {
		
        [textField resignFirstResponder];
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
	}
	return YES;
}
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"input %d chars", newText.length);
    
    int totChatCount=400-newText.length;

    if (totChatCount>=0 && totChatCount<=400) {

        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            
            if (![myCharSet characterIsMember:c]) {
                
                if ([string isEqualToString:@" "]) {
                    
                }
                else
                {
                    return NO;
                }
                
            }
        }

    }
    else
    {
        return NO;
    }
    
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollViewToCenterOfScreen:textView];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    /*  if (range.length==0) 
     {
     
     if ([text isEqualToString:@"\n"])
     {                
     [textView resignFirstResponder];
     [textView resignFirstResponder];
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: 0.25];
     [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
     [UIView commitAnimations];
     
     return YES;
     
     }
     
     }
     return YES;
     */
    
  
        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSLog(@"input %d chars", newText.length);
        
        totalCharacterCout=400-newText.length;

        if (totalCharacterCout>=0 && totalCharacterCout<=400) {
            
            if ([text isEqualToString:@"\n"])
            {   
                [textView resignFirstResponder];
                [textView resignFirstResponder];
                [UIView beginAnimations: @"anim" context: nil];
                [UIView setAnimationBeginsFromCurrentState: YES];
                [UIView setAnimationDuration: 0.25];
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [UIView commitAnimations];
                
            }
            return YES;
            
        }else{
            if ([text isEqualToString:@"\n"])
            {            
                
                [textView resignFirstResponder];
                [textView resignFirstResponder];
                [UIView beginAnimations: @"anim" context: nil];
                [UIView setAnimationBeginsFromCurrentState: YES];
                [UIView setAnimationDuration: 0.25];
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [UIView commitAnimations];
                
                
            }
            return NO;
        }
        
		
	return YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView==imageAlert)
    {
        if (buttonIndex==1) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                
               
                    UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
                    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    //[[self navigationController] presentModalViewController:picker animated:YES];
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
              //  [[self navigationController] presentModalViewController:picker animated:YES];
                
            [self presentViewController:picker animated:YES completion:nil];

            
        }
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [self useImage:image];
    [imgGroup setImage:image];
    [lblUploadImage setHidden:TRUE];
    [lblTapTo setHidden:TRUE];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)useImage:(UIImage*)theImage
{
    self.imageData=nil;
    
    UIImage *img=[theImage imageByScalingAndCroppingForSize:CGSizeMake(400, 400)];
    
	self.imageData = UIImageJPEGRepresentation(img, 0.1);
	
}	

-(void)uploadData
{
    groupStatus=@"0";
    
    if ([gSubscriptionCharge isEqualToString:@"0"]) {
        
        gSubscriptionCharge=@"";
    }
    if ([gSubscriptionPlan isEqualToString:@"0"]) {
        
        gSubscriptionPlan=@"";
    }

   
    NSString * base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)txtView.text,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                   kCFStringEncodingUTF8 )autorelease];
    NSString *chatId=[self genRandStringLength:40];

    NSArray *formfields = [NSArray arrayWithObjects:@"userId",@"groupTitle",@"groupIntro",@"subscriptionCharge",@"subscriptionPeriod",@"groupMember",@"threadId",@"groupType",@"periodType",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,txtTitle.text,base64String,gSubscriptionCharge,gSubscriptionPlan,[AppDelegate sharedAppDelegate].selectedMembers,chatId,groupStatus,gFeetype,nil];
	NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,nil ];
	
	[self performSelectorOnMainThread:@selector(doPostWithText:) withObject:compositeData waitUntilDone:YES];
    
}
- (void) doPostWithText: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
    
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"create_group"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",self.imageData.length);
    
    
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease] ;
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
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
            [imgGroup setImage:[UIImage imageNamed:@"group_pic"]];
            txtTitle.text=@"";
            txtView.text=@"";
            
            
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            self.groupId=[responseDic objectForKey:@"groupId"];
            self.groupUniqueMember=[responseDic objectForKey:@"groupCode"];
            
            self.localImageName=@"";
            
            //[self performSelectorOnMainThread:@selector(saveGroupDetailOnLocalDB) withObject:nil waitUntilDone:YES];
            
            successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            
            
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)uploadImage
{
    groupStatus=@"0";
    
    if ([gSubscriptionCharge isEqualToString:@"0"]) {
        
        gSubscriptionCharge=@"";
    }
    if ([gSubscriptionPlan isEqualToString:@"0"]) {
        
        gSubscriptionPlan=@"";
    }

    NSString * base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)txtView.text,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                   kCFStringEncodingUTF8 )autorelease];
    NSString *chatId=[self genRandStringLength:40];
    
    
    NSArray *formfields = [NSArray arrayWithObjects:@"userId",@"groupTitle",@"groupIntro",@"subscriptionCharge",@"subscriptionPeriod",@"groupMember",@"threadId",@"groupType",@"periodType",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,txtTitle.text,base64String,gSubscriptionCharge,gSubscriptionPlan,[AppDelegate sharedAppDelegate].selectedMembers,chatId,groupStatus,gFeetype, nil];
    
	
    NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray *photo = [NSArray arrayWithObjects:@"myimage1.png",nil];
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
	
	
	[self performSelectorOnMainThread:@selector(doPostWithImage:) withObject:compositeData waitUntilDone:YES];
    
}
- (void) doPostWithImage: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSArray * _photo = [compositeData objectAtIndex:1];
	
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"create_group"];
    
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
            [imgGroup setImage:[UIImage imageNamed:@"group_pic"]];
            
            txtTitle.text=@"";
            txtView.text=@"";
            
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            self.groupId=[responseDic objectForKey:@"groupId"];
            NSString *image=[responseDic objectForKey:@"groupImage"];
            self.groupUniqueMember=[responseDic objectForKey:@"groupCode"];
            
            self.localImageName=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,image];
            
            //[self performSelectorOnMainThread:@selector(saveGroupDetailOnLocalDB) withObject:nil waitUntilDone:YES];
            
            successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            
            
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
#pragma mark----------------
#pragma sqlite methods

-(void)saveGroupDetailOnLocalDB
{
    NSString *idStr=@"";
    NSString *groupType=@"";
    
    if ([gSubscriptionCharge isEqualToString:@""]) {
        
        groupType=@"0";
    }
    else
    {
        groupType=@"1";
    }
    
    
    const char *sqlStatement = "Insert into tbl_group (groupId,groupName,groupIconId,groupIntro,groupCreated,groupRating,groupSubCharge,groupSubPeriod,groupType,groupUniqueDeg,OwnerId) values(?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        
        
        sqlite3_bind_text( compiledStatement, 1, [self.groupId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 2, [txtTitle.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 3, [self.localImageName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 4, [txtView.text  UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 6, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text( compiledStatement, 7, [gSubscriptionCharge UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 8, [gSubscriptionPlan UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text( compiledStatement, 9, [groupType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 10, [self.groupUniqueMember UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 11, [gUserId UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
        
        NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        
    } else {
        
        NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
        idStr=[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database)];
        
    }
    sqlite3_finalize(compiledStatement);
    
    
    if (![idStr isEqualToString:@""]) {
        
        [self saveGroupMemberOnLocalDB];
    }
    
}
-(void)saveGroupMemberOnLocalDB
{
    for (int i=0; i<[[AppDelegate sharedAppDelegate].arrSelectedContactList count]; i++) {
        
        NSString *memberId=[[AppDelegate sharedAppDelegate].arrSelectedContactList objectAtIndex:i];
        
        const char *sqlStatement = "Insert into tbl_group_member (groupId,memberId) values(?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            sqlite3_bind_text( compiledStatement, 1, [self.groupId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [memberId UTF8String], -1, SQLITE_TRANSIENT);                
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        } 
        else {
            
            NSLog( @"Insert into row id = %lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            
        }
        sqlite3_finalize(compiledStatement);
        
    }
}

#pragma Picker delegate

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen
{
    NSString *titleStr=@"";
    
    if ([checkPickerView isEqualToString:@"Period" ]) {
        
        NSString *str=[pickerArray objectAtIndex:row];
        
        if ([str isEqualToString:@"Select"]) {
            
            titleStr=str;
        }
        else
        {
            str=[str stringByAppendingFormat:@" Month"];
            titleStr=str;
        }
        
        
    }
    else if ([checkPickerView isEqualToString:@"Charge"]) {
        
        NSString *str=[pickerArray objectAtIndex:row];
        
        if ([str isEqualToString:@"Select"]) {
            
            titleStr=str;
        }
        else
        {
            titleStr=[NSString stringWithFormat:@"$%@",str];
        }

    }
    else if ([checkPickerView isEqualToString:@"Membership"]){
    
        titleStr=[pickerArray objectAtIndex:row];

    }
    else
    {
        NSString *str=[pickerArray objectAtIndex:row];
        
        if ([str isEqualToString:@"Select"]) {
            
            titleStr=str;
        }
        else
        {
            titleStr=str;
            
        }
        
    }
    
    return titleStr;
}
-(IBAction)btnPickerDonePressed:(id)sender
{
    [pickerView removeFromSuperview];
    [toolBar removeFromSuperview];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [popOverScroll setContentOffset:CGPointMake(0, 0) animated:YES];

    [UIView commitAnimations];

    NSString *selectedStr=[pickerArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    [pickerView setHidden:TRUE];
    [toolBar setHidden:TRUE];
    
    if ([checkPickerView isEqualToString:@"Period"]) {
        
        txtTrialPeriod.text=[NSString stringWithFormat:@"%@%@",selectedStr,@" Month"];
            
        gSubscriptionPlan=[selectedStr retain];
            
    }
    else if ([checkPickerView isEqualToString:@"Charge"]) {
        
        txtcharge.text=[NSString stringWithFormat:@"$%@",selectedStr];
         gSubscriptionCharge=[selectedStr retain];
        
    }
    else if ([checkPickerView isEqualToString:@"Membership"]) {
        
        txtMemberShip.text=selectedStr;
        
    }
    else
    {
        txtSubscription.text=selectedStr;
        
        if ([selectedStr isEqualToString:@"Monthly"]) {
            
             gFeetype=@"1";
        }
        else{
            gFeetype=@"2";
        }
        
    }
    
    NSLog(@"%@",gSubscriptionPlan);
    NSLog(@"%@",gSubscriptionCharge);

}

- (void)viewDidUnload
{
    self.localImageName=nil;
    self.imageData=nil;
    self.groupUniqueMember=nil;
    self.groupId=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    self.localImageName=nil;
    self.imageData=nil;
    self.groupUniqueMember=nil;
    self.groupId=nil;

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
