//
//  LoginViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "Config.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "QSStrings.h"
#import <CFNetwork/CFNetwork.h>

//static NSString* kAppId = @"833209056698618";
static NSString* kAppId = @"639892319392066";

@implementation LoginViewController

@synthesize btnRemember;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize txtForgotPassword;
@synthesize imgLogo;

@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize posting = _posting;
@synthesize fbUserDetails,FBUserID,FBUserName, FBToken,facebook,dic_facebookdata,imageData;


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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Login"];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    fieldsArray = [[NSArray alloc] initWithObjects:self.txtUsername,self.txtPassword,nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLoginNotification:) name:@"RemoteNotificationReceivedWhileLogin" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLoginProgressNotification:) name:@"RemoteNotificationReceivedWhileLoginProgress" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLoginErrorNotification:) name:@"RemoteNotificationReceivedError" object:Nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    navigation=self.navigationController.navigationBar;
    [self.navigationController.navigationBar setHidden:FALSE];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }

    NSLog(@"%@",gUserEmail);
    if (![gUserEmail isEqualToString:@""]) {
        
        self.txtUsername.text=[gUserEmail retain];
        self.txtPassword.text=@"";
    }
    if (service!=nil) {
        service=nil;
    }
    service=[[ConstantLineServices alloc] init];
    
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
    NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]autorelease];
    
    if ([[plist_dict valueForKey:@"keepmelogin"]isEqualToString:@"yes"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            [AppDelegate sharedAppDelegate].checkForground=TRUE;
            
            self.txtUsername.text=[plist_dict valueForKey:@"loginusernane"];
            self.txtPassword.text=[plist_dict valueForKey:@"loginpassword"];
            
           // NSString *checkFBLogin=[plist_dict valueForKey:@"fblogin"];

            btnRemember.tag=1;
            
            [AppDelegate sharedAppDelegate].chatDetailType=@"old";
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            /*if ([checkFBLogin isEqualToString:@"no"]) {
                
                [service LoginInvocation:txtUsername.text password:txtPassword.text delegate:self];

            }
            else
            {*/
                [service FBLoginInvocation:txtUsername.text password:txtPassword.text delegate:self];

            //}
            
            
        }
        
        
        if (btnRemember.tag==1) {
            
            [btnRemember setSelected:YES];
        }
        else
        {
            [btnRemember setSelected:NO];
        }
        
    }
    
   // txtUsername.text=@"shweta.sharma@octalsoftware.net";
  //  txtPassword.text=@"123456";
    
     //txtUsername.text=@"support@ehealthme.com";
    // txtPassword.text=@"abcdef";

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:FALSE];
    
}
- (void)didReceiveLoginNotification:(NSNotification*) note
{
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
    service=[[ConstantLineServices alloc] init];
      
        [service LoginInvocation:txtUsername.text password:txtPassword.text delegate:self];
        
    }
}
- (void)didReceiveLoginProgressNotification:(NSNotification*) note
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.txtPassword.text=@"";
    self.txtUsername.text=@"";
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Email or password is incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)didReceiveLoginErrorNotification:(NSNotification*) note
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.txtPassword.text=@"";
    self.txtUsername.text=@"";
    
}
-(IBAction)keepMeLoginButtonClick:(UIButton *)sender
{
    if (!sender.selected) {
        
        [sender setSelected:YES];
    }
    else
    {
        [sender setSelected:NO];
    }    
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag==1)
    {
        btn.tag=0;
        
    }
    else
    {
        btn.tag=1;
        
    }
    
}
-(IBAction)btnLoginPressed:(id)sender
{
    if (self.txtUsername.text.length==0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please enter Email Id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if(self.txtPassword.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please enter passsword" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [AppDelegate sharedAppDelegate].chatDetailType=@"new";
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [txtPassword resignFirstResponder];
            [txtUsername resignFirstResponder];
            [self.imgLogo setHidden:FALSE];
            [service LoginInvocation:txtUsername.text password:txtPassword.text delegate:self];
            
        }
    }
    
}
-(IBAction)btnRegisterPressed:(id)sender
{
    
    objRegistrationView=[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];

    [self.navigationController pushViewController:objRegistrationView animated:NO];
}
-(IBAction)btnForgotPasswordPressed:(id)sender
{
   
    
    forgotPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Enter your email Id"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Continue", nil];
    [forgotPasswordAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [forgotPasswordAlert show];
    [forgotPasswordAlert release];

    
}

#pragma mark Facebook Post delegates

-(IBAction)btnFBLoginPressed:(id)sender
{    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        
        if (facebook!=nil) {
            facebook=nil;
        }
        
        facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
        facebook.sessionDelegate = self;
        
        
        permissions =  [NSArray arrayWithObjects:
                        @"email",@"read_stream",@"user_birthday",
                        @"user_about_me",@"offline_access",@"publish_stream", nil] ;
        [self login];
        
    }
}
- (void)fbDidLogin {
	
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[delegate facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[delegate facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self getUserInfo:self];
		
}

- (void)login {
	
	AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate =[defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![[delegate facebook] isSessionValid]) {
        
        [delegate facebook].sessionDelegate = self;
        
        [[delegate facebook] authorize:permissions];
        
    } else {
		
        [self getUserInfo:self];
	}
	
}

- (void)getUserInfo:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"name,picture.type(large),first_name,last_name,email",@"fields,gender,dob",
								   nil];
    
	[[delegate facebook] requestWithGraphPath:@"me" andParams:params andDelegate:self];
    
    
}

-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}
- (void)request:(FBRequest *)request didLoad:(id)result {
    
	NSLog(@"%@", result);
    
    self.dic_facebookdata=result;
    
	if ([result isKindOfClass:[NSArray class]]) {
		
        result = [result objectAtIndex:0];
	}
	if ([result isKindOfClass:[NSDictionary class]]){
        
        [self uploadImage];
        
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

/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        if (txtForgotPassword.text.length>0) {
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service ForgotPasswordInvocation:txtForgotPassword.text delegate:self];
                
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Enter email id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==forgotPasswordAlert) {
        if (buttonIndex==1) {
            
            NSString *inputText = [[forgotPasswordAlert textFieldAtIndex:0] text];
            
            if ([inputText length]>0) {
                
                int status=[[AppDelegate sharedAppDelegate] netStatus];
                
                if(status==0)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [service ForgotPasswordInvocation:inputText delegate:self];
                    
                }
            
            
            NSLog(@"mukesh2345");
            
            }
        }
    }
}

-(void)whenKeyBoardWillShow:(NSNotification *)notificationInfo{
    
   
        CGRect baseViewtempFrame = scrollView.frame;
        float diff=self.txtPassword.frame.origin.y+self.txtPassword.frame.size.height;
        
        diff=160-diff-self.txtPassword.frame.size.height;
        
        baseViewtempFrame.origin.y=diff;
        
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [UIView setAnimationDuration:0.25];
        
        scrollView.frame = baseViewtempFrame;
        
        [UIView commitAnimations];
    
	    
}
-(void)whenKeyBoardWillHide:(NSNotification *)notificationInfo{
    
   
        if(scrollView.frame.origin.y!=0)
        {
            
            CGRect baseViewtempFrame = scrollView.frame;
            baseViewtempFrame.origin.y=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.25];
            scrollView.frame = baseViewtempFrame;
            [UIView commitAnimations];
        }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        [self.imgLogo setHidden:FALSE];
        
        if(scrollView.frame.origin.y!=0)
        {
            CGRect baseViewtempFrame = scrollView.frame;
            baseViewtempFrame.origin.y=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.25];
            scrollView.frame = baseViewtempFrame;
            [UIView commitAnimations];
        }

    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        keyboardtoolbar.barStyle = UIBarStyleDefault;
    }
    
        CGRect baseViewtempFrame = scrollView.frame;
        
        float diff=self.txtPassword.frame.origin.y+self.txtPassword.frame.size.height;    
        diff=160-diff-self.txtPassword.frame.size.height;
        baseViewtempFrame.origin.y=diff;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        scrollView.frame = baseViewtempFrame;
        [UIView commitAnimations];
        
        
        if (textField==txtForgotPassword) {
            
            for (int n=0; n<[fieldsArray count]; n++) 
            {
                if ([fieldsArray objectAtIndex:n]==textField) 
                {
                    if (n==[fieldsArray count]-1) 
                    {
                        [barButton setStyle:UIBarButtonItemStyleDone];
                    }
                }
            }
        }
        else
        {            
            
            if (textField==txtUsername) {
                
                [prevButton setEnabled:FALSE];
                [nextButton setEnabled:TRUE];
                
            }
            if (textField==txtPassword) {
                
                [prevButton setEnabled:TRUE];
                [nextButton setEnabled:FALSE];
            }
            [textField setInputAccessoryView:keyboardtoolbar];
            
            
        }

   
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.imgLogo setHidden:TRUE];

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
		if ([[fieldsArray objectAtIndex:n] isEditing] && n!=0)
		{
			[[fieldsArray objectAtIndex:n-1] becomeFirstResponder];
			[barButton setTitle:@"Done"];
			[barButton setStyle:UIBarButtonItemStyleDone];
			break;
		}
	}
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
	if(value == 1){
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


- (IBAction) dismissKeyboard:(id)sender{
    
    [self.imgLogo setHidden:FALSE];

    if(scrollView.frame.origin.y!=0)
    {
        CGRect baseViewtempFrame = scrollView.frame;
        baseViewtempFrame.origin.y=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        scrollView.frame = baseViewtempFrame;
        [UIView commitAnimations];
    }
    
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    
}
-(void)uploadImage
{
    
    NSString *fbId=[self.dic_facebookdata objectForKey:@"id"];
    
    NSString *screenName=[self.dic_facebookdata objectForKey:@"name"];
    
    NSString *emailStr=[self.dic_facebookdata objectForKey:@"email"];
    NSString *gender=[self.dic_facebookdata objectForKey:@"gender"];
    
    NSString *dob=[self.dic_facebookdata objectForKey:@"birthday"];
    
    NSString *imageStr=[NSString stringWithFormat:@"%@%@%@",@"http://graph.facebook.com/",fbId,@"/picture?width=600&height=600"];
    
    NSLog(@"%@",imageStr);
    
    self.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    
    
        results=[[NSMutableDictionary alloc] init];
    
        
        NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
        urlString=[urlString stringByAppendingFormat:@"registration_upload"];
        
        NSLog(@"%@",urlString);
        NSLog(@"%d",self.imageData.length);
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"2.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:self.imageData]];
            
            // [body appendData:[NSData dataWithData:data]];
            self.imageData=nil;
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
    
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
        
        NSLog(@"%@",returnString);
        
        results=[returnString JSONValue];
        
        NSLog(@"%@",results);
        
        NSDictionary *responseDic=[results objectForKey:@"response"];
        
        
        if ([results count]>0) {
            
                NSString *image=[responseDic objectForKey:@"userImage"];
                
                
                if(image==nil || image==(NSString*)[NSNull null])
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    moveTabG=FALSE;
                    
                   
                }
                else
                {
                    
                    [service FacebookLoginInvocation:fbId email:emailStr display_name:screenName dob:dob gender:gender image:image delegate:self];
                 
                    
                }
            
        }
    
}
#pragma mark TextFieldDelegate
#pragma webservice delegate

-(void)loginInvocationDidFinish:(LoginInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{

    NSLog(@"loginInvocationDidFinish");
    
    if (result==nil || result==(NSString*)[NSNull null]) {
        
        self.txtPassword.text=@"";
        self.txtUsername.text=@"";
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else
    {

        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
        NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]autorelease];
        
        [AppDelegate sharedAppDelegate].rememberTag=btnRemember.tag;
        
        if(btnRemember.tag==1)
        {
            if(plist_dict == nil)
            {
                plist_dict = [[NSMutableDictionary alloc] init];
            }
           // [AppDelegate sharedAppDelegate].email=self.txtUsername.text;
           // [AppDelegate sharedAppDelegate].password=self.txtPassword.text;
            
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].email] forKey:@"loginusernane"];
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].password] forKey:@"loginpassword"];
            
            [plist_dict setObject:@"no" forKey:@"fblogin"];

            [plist_dict setObject:@"yes" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        else
        {
            [plist_dict setObject:@"no" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        
        self.txtUsername.text=@"";
        self.txtPassword.text=@"";
        
        [[AppDelegate sharedAppDelegate] createTabBar];

        [self.txtUsername resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.imgLogo setHidden:FALSE];

}

-(void)FBLoginInvocationDidFinish:(FBLoginInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    
    NSLog(@"loginInvocationDidFinish");
    
    if (result==nil || result==(NSString*)[NSNull null]) {
        
        self.txtPassword.text=@"";
        self.txtUsername.text=@"";
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else
    {
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
        NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]autorelease];
        
        [AppDelegate sharedAppDelegate].rememberTag=btnRemember.tag;
        
        if(btnRemember.tag==1)
        {
            if(plist_dict == nil)
            {
                plist_dict = [[NSMutableDictionary alloc] init];
            }
          //  [AppDelegate sharedAppDelegate].email=self.txtUsername.text;
          //  [AppDelegate sharedAppDelegate].password=self.txtPassword.text;
            
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].email] forKey:@"loginusernane"];
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].password] forKey:@"loginpassword"];
            
            
            [plist_dict setObject:@"yes" forKey:@"fblogin"];
            
            [plist_dict setObject:@"yes" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        else
        {
            [plist_dict setObject:@"no" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        
        self.txtUsername.text=@"";
        self.txtPassword.text=@"";
        
        [[AppDelegate sharedAppDelegate] createTabBar];
        
        [self.txtUsername resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.imgLogo setHidden:FALSE];
    
}

-(void)FacebookLoginInvocationDidFinish:(FacebookLoginInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    
    NSLog(@"loginInvocationDidFinish");
    
    if (result==nil || result==(NSString*)[NSNull null]) {
        
        self.txtPassword.text=@"";
        self.txtUsername.text=@"";
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else
    {
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
        NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]autorelease];
        [AppDelegate sharedAppDelegate].rememberTag=btnRemember.tag;
        
        if(btnRemember.tag==1)
        {
            if(plist_dict == nil)
            {
                plist_dict = [[NSMutableDictionary alloc] init];
            }
            
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].email] forKey:@"loginusernane"];
            [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].password] forKey:@"loginpassword"];
            [plist_dict setObject:@"yes" forKey:@"keepmelogin"];
            [plist_dict setObject:@"yes" forKey:@"fblogin"];

            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        else
        {
            [plist_dict setObject:@"no" forKey:@"keepmelogin"];
            [plist_dict writeToFile:plistPath atomically:YES];
            
        }
        
        self.txtUsername.text=@"";
        self.txtPassword.text=@"";
        
        [[AppDelegate sharedAppDelegate] createTabBar];
        
        [self.txtUsername resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.imgLogo setHidden:FALSE];
    
}
-(void)ForgotPasswordInvocationDidFinish:(ForgotPasswordInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"%@",result);
    NSLog(@"%@",msg);
    
    if (result==nil || result==(NSString*)[NSNull null]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
    }
    
}


- (void)viewDidUnload
{
    self.txtUsername=nil;
    self.txtPassword=nil;
    self.txtForgotPassword=nil;
    self.imgLogo=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    self.txtUsername=nil;
    self.txtPassword=nil;
    self.txtForgotPassword=nil;
    self.imgLogo=nil;

    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
    
