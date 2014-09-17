//
//  ChangePasswordViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "MBProgressHUD.h"

@implementation ChangePasswordViewController

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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Change Password"];
    
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    

    fieldsArray = [[NSArray alloc] initWithObjects:txtPassword,txtNewPassword,txtConpassword,nil];
    
    scrollView.backgroundColor=[UIColor clearColor];
    
    
    
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
-(void)viewWillAppear:(BOOL)animated
{
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    service=nil;
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self resignTextview];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)checkDataAndRegister{
    
    txtPassword.text= [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtNewPassword.text= [txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtConpassword.text= [txtConpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([txtPassword.text length]<=0 || txtPassword.text == nil || [txtPassword.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter existing password"];
        return NO;
    }
    if ([txtNewPassword.text length]<=0 || txtNewPassword.text == nil || [txtNewPassword.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter new password"];
        return NO;
    }
    if ([txtNewPassword.text length]<6 || [txtNewPassword.text length]>15)
    {
        [self showAlertViewWithTitel:@"" Message:@"Password should be at least 6 Characters and maximum 15 Characters"];
        return NO;
    }
    if ([txtConpassword.text length]<=0 || txtConpassword.text == nil || [txtConpassword.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter confirm password"];
        return NO;
    }
    if (![txtNewPassword.text isEqualToString: txtConpassword.text]) {
        
        [self showAlertViewWithTitel:@"" Message:@"New password  and confirm password  do not match"];
        return NO;
        
    }
     
    return YES;
    
}
-(IBAction)btnChangePassword:(id)sender
{
    BOOL isDataValid=[self checkDataAndRegister];
    
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
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if (service!=nil) {
                
                service=nil;
            }
            service=[[ConstantLineServices alloc] init];
            [service ChangePasswordInvocation:gUserId oldPass:txtPassword.text newPass:txtNewPassword.text delegate:self];
            
            }
        }
        
        
    }
    
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
    [alertView release];
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
        [textField setInputAccessoryView:keyboardtoolbar];
        
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
        [scrollView setContentOffset:CGPointMake(0, 64) animated:YES];
        [UIView commitAnimations];
	}
	return YES;
}
- (IBAction) next
{
    for (int n=0; n<[fieldsArray count]; n++) 
    {
        if ([[fieldsArray objectAtIndex:n] isEditing] && n!=[fieldsArray count]-1) 
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
    [txtPassword resignFirstResponder];
    [txtNewPassword resignFirstResponder];
    [txtConpassword resignFirstResponder];
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

#pragma -----------
#pragma web service delegate

-(void)ChangePasswordInvocationDidFinish:(ChangePasswordInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        txtPassword.text=@"";
        txtNewPassword.text=@"";
        txtConpassword.text=@"";
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
        NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]autorelease];
        
        if ([[plist_dict valueForKey:@"keepmelogin"]isEqualToString:@"yes"]) 
        {
            
            if(plist_dict == nil)
            {
                plist_dict = [[NSMutableDictionary alloc] init];
            }
            
            
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].password] forKey:@"loginpassword"];
            [plist_dict setObject:@"yes" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        else
        {
            [plist_dict setObject:@"no" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        
        successAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];
        
    }
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];  
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
