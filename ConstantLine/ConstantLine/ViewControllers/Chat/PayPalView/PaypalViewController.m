//
//  PaypalViewController.m
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
// 7 in-app purchases: $1, 2, 5, 10, 20, 50, 100 monthly subscription fee

#import "PaypalViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "Config.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "sqlite3.h"
#import "CommonFunction.h"
#import "QSStrings.h"
#import "UIImageExtras.h"

@interface PaypalViewController ()

@end

@implementation PaypalViewController

@synthesize groupOwnerId,groupUserTableId,userId,type,groupId,checkAcceptRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Register"];
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
  
    
    fieldsArray = [[NSArray alloc] initWithObjects:txtCreditCardName,txtCrediCardAccount,txtCreditCardType,txtCrnNumber,txtCreditTypeExpiryDate,nil];
    
    scrollView.backgroundColor=[UIColor clearColor];
    
    dateForMater=[[NSDateFormatter alloc] init];
    dateForMater.dateStyle = NSDateFormatterMediumStyle;
    [dateForMater setDateFormat:@"yyyy-MM-dd"];
    
    //  [dateForMater setDateFormat:@"MM-dd-yyyy"];
    
    
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    
    if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone) {
        
        datePicker.frame=CGRectMake(0, 155+IPHONE_FIVE_FACTOR, 320, 216);
    }
    else{
        [datePicker setFrame:CGRectMake(0, 155, 320, datePicker.frame.size.height)];
    }
    
    
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self resignTextview];
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(BOOL)checkCreditCardDaTa
{
    
    txtCreditCardName.text= [txtCreditCardName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtCrediCardAccount.text= [txtCrediCardAccount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtCreditCardType.text= [txtCreditCardType.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtCreditTypeExpiryDate.text= [txtCreditTypeExpiryDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtCrnNumber.text= [txtCrnNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if ([txtCreditCardName.text length]<=0 || txtCreditCardName.text == nil || [txtCreditCardName.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter credit card name"];
        return NO;
    }
    
    if ([txtCrediCardAccount.text length]<=0 || txtCrediCardAccount.text == nil || [txtCrediCardAccount.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter credit card account number "];
        return NO;
    }
    if ([txtCreditCardType.text length]<=0 || txtCreditCardType.text == nil || [txtCreditCardType.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter credit card type"];
        return NO;
    }
    if ([txtCrnNumber.text length]<=0 || txtCrnNumber.text == nil || [txtCrnNumber.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter crn number"];
        return NO;
    }
    if ([txtCreditTypeExpiryDate.text length]<=0 || txtCreditTypeExpiryDate.text == nil || [txtCreditTypeExpiryDate.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter credit card expiry date"];
        return NO;
    }
    
    return YES;
    
}
-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message{
    
    [self resignTextview];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}
-(IBAction)btnSubmitPressed:(id)sender
{
    BOOL isDataValid=[self checkCreditCardDaTa];
    
    if(isDataValid){
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            [self resignTextview];
            
            service=[[ConstantLineServices alloc] init];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service SendCreditCardDetailInvocation:gUserId cardname:txtCreditCardName.text account_number:txtCrediCardAccount.text card_type:txtCreditCardType.text expiry_date:txtCreditTypeExpiryDate.text crn_number:txtCrnNumber.text groupId:self.groupId delegate:self];

        }
        
        
    }
    
}
-(void)showDatePicker{
    
    [self resignTextview];
    
    if (!datePicker.isOpen) {
        
        CGRect datePickerFrame;
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            datePicker=[[DatePickerController alloc] initWithFrame:CGRectMake(0,getFloatY(IPHONE_FOUR_HEIGHT),getFloatY(320),216)];
            datePicker.delegate=self;
            
            datePickerFrame = datePicker.frame;
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                
                datePickerFrame.origin.y =160+IPHONE_FIVE_FACTOR+40;
            else
            {
                
                datePickerFrame.origin.y =160+40;
            }
            
            
            
            datePicker.toolBar.barStyle=UIBarStyleDefault;
            datePicker.backgroundColor=[UIColor whiteColor];
        }
        else{
            datePicker=[[DatePickerController alloc] initWithFrame:CGRectMake(0,getFloatY(IPHONE_FOUR_HEIGHT),getFloatY(320),216)];
            [datePicker.pickerView setMaximumDate:[NSDate date]];
            datePicker.delegate=self;
            
            datePickerFrame = datePicker.frame;
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                
                datePickerFrame.origin.y =160+IPHONE_FIVE_FACTOR;
            else
            {
                
                datePickerFrame.origin.y =160;
            }
        }
        
        datePicker.delegate=self;
        datePicker.isOpen=YES;
        [datePicker setHidden:FALSE];
        [self.view addSubview:datePicker];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [datePicker setFrame:datePickerFrame];
        [UIView commitAnimations];
        
        [self scrollViewToCenterOfScreen:txtCreditTypeExpiryDate];
        
        
    }
    
    
    
}

-(void)hideDatePicker
{
    
    CGRect datePickerFrame = datePicker.frame;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone) {
            
            datePickerFrame.origin.y =480+IPHONE_FIVE_FACTOR;
        }
        else{
            datePickerFrame.origin.y =480;
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone) {
            
            datePickerFrame.origin.y =480+IPHONE_FIVE_FACTOR;
        }
        else{
            datePickerFrame.origin.y =480;
        }
        
    }
    
    datePicker.isOpen=NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [datePicker setFrame:datePickerFrame];
    [UIView commitAnimations];
    
}
-(void)hideKeyBoard:(UITextField *)sender{
    [sender resignFirstResponder];
}

#pragma mark DatePickerController Delegate

-(void)GetDate:(NSDate *)Selected_DOB{
    
    txtCreditTypeExpiryDate.text=[dateForMater stringFromDate:Selected_DOB];
    
}
-(void)hideToolBar_With_Done{
    
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideDatePicker) withObject:nil afterDelay:0.1];
    
    if ([txtCreditTypeExpiryDate.text isEqualToString:@""]) {
        
        txtCreditTypeExpiryDate.text=[dateForMater stringFromDate:[NSDate date]];
        
    }
    
}
-(void)hideToolBar_With_Cancel{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideDatePicker) withObject:nil afterDelay:0.1];
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
    if (textField==txtCreditTypeExpiryDate) {
        
        [self performSelector:@selector(showDatePicker) withObject:nil afterDelay:0.01];
        
    }
    else
    {
        [self hideDatePicker];
        [self scrollViewToCenterOfScreen:textField];
        [textField setInputAccessoryView:keyboardtoolbar];
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            keyboardtoolbar.barStyle = UIBarStyleDefault;
        }
        for (int n=0; n<[fieldsArray count]; n++)
        {
            if ([fieldsArray objectAtIndex:n]==textField)
            {
                if (n==[fieldsArray count]-2)
                {
                    [barButton setStyle:UIBarButtonItemStyleDone];
                }
            }
        }
    }
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==txtCreditTypeExpiryDate) {
        
        [self performSelector:@selector(showDatePicker) withObject:nil afterDelay:0.01];
        return NO;
    }
    else
    {
        [self hideDatePicker];
        return YES;
    }
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
    
    return YES;
}
- (IBAction) next
{
	for (int n=0; n<[fieldsArray count]; n++)
	{
		if ([[fieldsArray objectAtIndex:n] isEditing] && n!=[fieldsArray count]-1)
		{
            
            if (n==[fieldsArray count]-2) {
                
                [self performSelector:@selector(showDatePicker) withObject:nil afterDelay:0.01];
                break;
            }
            
            
            else
            {
                [[fieldsArray objectAtIndex:n+1] becomeFirstResponder];
				
				if (n+1==[fieldsArray count]-1)
				{
					[barButton setTitle:@"Done"];
					[barButton setStyle:UIBarButtonItemStyleDone];
				}else
				{
					[barButton setTitle:@"Done"];
					[barButton setStyle:UIBarButtonItemStyleDone];
				}
				
				break;
                
                
            }
			
            
		}
		
    }
}

- (IBAction) previous
{
	for (int n=0; n<[fieldsArray count]; n++)
	{
        
		if ([[fieldsArray objectAtIndex:n] isEditing]&& n!=0)
		{
            
            [[fieldsArray objectAtIndex:n-1] becomeFirstResponder];
            [barButton setTitle:@"Done"];
            [barButton setStyle:UIBarButtonItemStyleDone];
            
            break;
		}
        
	}
}
-(void)resignTextview
{
    [txtCreditCardName resignFirstResponder];
    [txtCrediCardAccount resignFirstResponder];
    [txtCreditCardType resignFirstResponder];
    [txtCreditTypeExpiryDate resignFirstResponder];
    [txtCrnNumber resignFirstResponder];
    
    
}

- (IBAction) dismissKeyboard:(id)sender
{
	
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextview];
    
}

-(IBAction) slideFrameUp:(UITextField *)textField
{
	if (textField.tag == 3) {
		value = 1;
	}
	else if(textField.tag == 4) {
		value = 2;
	}
	else if(textField.tag == 5) {
		value = 3;
	}
	[self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
	[self slideFrame:NO];
}
-(void) slideFrame:(BOOL) up
{
    NSLog(@"11111");
    
	if(value == 1){
        
        NSLog(@"2222");
        
        
		movementDistance = 70;
		movementDuration = 0.3f;
	}
	else if(value == 2) {
		movementDistance = 120;
		movementDuration = 0.3f;
	}
	else if(value == 3){
		movementDistance = 210;
		movementDuration = 0.3f;
	}
	int movement = (up ? -movementDistance : movementDistance);
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
	self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	[UIView commitAnimations];
}

#pragma mark Delegate
#pragma mark Webservide Delegate

-(void)SendCreditCardDetailInvocationDidFinish:(SendCreditCardDetailInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    else
    {
        
        
        if ([self.checkAcceptRequest isEqualToString:@"NO"]) {
            
            [service AcceptRejectGroupChatInvocation:gUserId groupId:self.userId groupUserTableId:self.groupUserTableId groupOwnerId:self.groupOwnerId status:@"2" delegate:self];

        }
        else{
            
            successAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
            [successAlert release];
        }
        


    }
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)AcceptRejectGroupChatInvocationDidFinish:(AcceptRejectGroupChatInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    else
    {
        successAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
