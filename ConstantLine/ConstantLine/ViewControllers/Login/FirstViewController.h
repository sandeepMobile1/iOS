//
//  FirstViewController.h
//  ConstantLine
//
//  Created by Shweta Sharma on 20/02/14.
//
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@class RegistrationViewController;
@class HelpViewController;
@class LoginViewController;

@interface FirstViewController : UIViewController
{
    HelpViewController *objHelpViewController;
    LoginViewController *objLoginViewController;
    RegistrationViewController *objRegistrationViewController;
    
    IBOutlet UINavigationBar *navigation;
    
    IBOutlet UIButton *btnTerms;
    IBOutlet UIButton *btnPrivacy;
    IBOutlet UIButton *btnskip;
    IBOutlet UILabel *lblcopyright;

    IBOutlet UIImageView *backImgView;
    
}
-(IBAction)btnLoginPressed:(id)sender;
-(IBAction)btnRegisterPressed:(id)sender;
-(IBAction)btnTermsPressed:(id)sender;
-(IBAction)btnPrivacyPressed:(id)sender;
-(IBAction)btnSkipPressed:(id)sender;

@end
