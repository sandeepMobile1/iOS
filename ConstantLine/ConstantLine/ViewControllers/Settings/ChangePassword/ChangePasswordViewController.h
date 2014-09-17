//
//  ChangePasswordViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantLineServices.h"
#import "ChangePasswordInvocation.h"

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,ChangePasswordInvocationDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConpassword;
    IBOutlet UITextField *txtNewPassword;

    UIAlertView *successAlert;
    
    ConstantLineServices *service;

    IBOutlet UIToolbar *keyboardtoolbar;
	NSArray				*fieldsArray;
	IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
	int movementDistance;
	float movementDuration;
    IBOutlet UINavigationBar *navigation;
    
    IBOutlet UIImageView *backImageView;

}
-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message;

-(IBAction)btnChangePassword:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextview;
-(BOOL)checkDataAndRegister;


@end
