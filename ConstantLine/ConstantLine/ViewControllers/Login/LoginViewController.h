//
//  LoginViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInvocation.h"
#import "ConstantLineServices.h"
#import "ForgotPasswordInvocation.h"
#import "Facebook.h"
#import <CoreData/CoreData.h>
#import "FacebookLoginInvocation.h"
#import "FBLoginInvocation.h"

@class FBSession;

@class RegistrationViewController;

@interface LoginViewController : UIViewController <LoginInvocationDelegate,UITextFieldDelegate,UIAlertViewDelegate,ForgotPasswordInvocationDelegate,FBSessionDelegate, FBRequestDelegate,LoginInvocationDelegate,FacebookLoginInvocationDelegate,FBLoginInvocationDelegate>
{

    UIAlertView *forgotPasswordAlert;
    ConstantLineServices *service;
    
    IBOutlet UIScrollView *scrollView;
    
    Facebook *facebook;
    
    NSArray *permissions;

     
    IBOutlet UIButton *btnForgotPassword;
    
    IBOutlet UIToolbar *keyboardtoolbar;
	NSArray				*fieldsArray;
	IBOutlet	UIBarButtonItem		*barButton;
    IBOutlet	UIBarButtonItem		*nextButton;
    IBOutlet	UIBarButtonItem		*prevButton;
    
    int value;
	int movementDistance;
	float movementDuration;
    
    IBOutlet UINavigationBar *navigation;
    RegistrationViewController *objRegistrationView;
    UITextField *txtForgotPassword;
    NSMutableDictionary *results;


}
@property(nonatomic,retain) NSData *imageData;

@property(nonatomic,retain) IBOutlet UIButton *btnRemember;
@property(nonatomic,retain)IBOutlet UITextField *txtUsername;
@property(nonatomic,retain)IBOutlet UITextField *txtPassword;
@property(nonatomic,retain)IBOutlet UITextField *txtForgotPassword;
@property(nonatomic,retain)IBOutlet UIImageView *imgLogo;


@property (nonatomic, strong)NSString *FBUserName;
@property (nonatomic, strong) FBLoginDialog *loginDialog;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, assign) BOOL posting;
@property (nonatomic, strong)NSDictionary *fbUserDetails;
@property (nonatomic, strong)NSString *FBUserID;
@property(nonatomic,strong)	NSString *FBToken;
@property (nonatomic,strong) Facebook *facebook;
@property(nonatomic,strong)NSDictionary *dic_facebookdata;

-(IBAction)keepMeLoginButtonClick:(UIButton *)sender;
-(IBAction)btnLoginPressed:(id)sender;
-(IBAction)btnRegisterPressed:(id)sender;
-(IBAction)btnForgotPasswordPressed:(id)sender;
-(IBAction)btnFBLoginPressed:(id)sender;
-(IBAction) dismissKeyboard:(id)sender;
-(IBAction) next;
-(IBAction) previous;
-(IBAction) slideFrameDown;
-(void) slideFrame:(BOOL) up;
- (void) uploadImage;

@end
