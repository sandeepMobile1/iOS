//
//  FirstViewController.m
//  ConstantLine
//
//  Created by Shweta Sharma on 20/02/14.
//
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "HelpViewController.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "DEMOLeftMenuViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

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
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   
    [self.navigationController.navigationBar setHidden:TRUE];
    
    btnTerms=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTerms setTitle:@"" forState:UIControlStateNormal];
    [btnTerms addTarget:self action:@selector(btnTermsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnTerms setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:btnTerms];
    
    btnPrivacy=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPrivacy setTitle:@"" forState:UIControlStateNormal];
    [btnPrivacy addTarget:self action:@selector(btnPrivacyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnPrivacy setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btnPrivacy];
    
    // NSString *myString = [NSString stringWithUTF8String:"0xF09F948A"];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [btnTerms setFrame:CGRectMake(90, 370+IPHONE_FIVE_FACTOR, 70, 30)];
            [btnPrivacy setFrame:CGRectMake(180, 370+IPHONE_FIVE_FACTOR,70, 30)];
            
            [backImgView setFrame:CGRectMake(backImgView.frame.origin.x, backImgView.frame.origin.y, backImgView.frame.size.width, 568)];
            
            
            [lblcopyright setFrame:CGRectMake(69, 396+IPHONE_FIVE_FACTOR,202, 32)];
            
            [btnskip setFrame:CGRectMake(0, 435+IPHONE_FIVE_FACTOR,320, 45)];
            
        }
        else
        {
            
            [btnTerms setFrame:CGRectMake(90, 370, 70, 30)];
            [btnPrivacy setFrame:CGRectMake(180, 370,70, 30)];
            [btnskip setFrame:CGRectMake(0, 435,320, 45)];
            [lblcopyright setFrame:CGRectMake(69, 396,202, 32)];
            [backImgView setFrame:CGRectMake(backImgView.frame.origin.x, backImgView.frame.origin.y, backImgView.frame.size.width, 568-IPHONE_FIVE_FACTOR)];
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            NSLog(@"kDeviceTypeTalliPhone");
            
            [btnTerms setFrame:CGRectMake(90, 370+IPHONE_FIVE_FACTOR, 70, 30)];
            [btnPrivacy setFrame:CGRectMake(180, 370+IPHONE_FIVE_FACTOR,70, 30)];
            [btnskip setFrame:CGRectMake(0, 435+IPHONE_FIVE_FACTOR,320, 45)];
            [lblcopyright setFrame:CGRectMake(69, 396+IPHONE_FIVE_FACTOR,202, 32)];
            [backImgView setFrame:CGRectMake(backImgView.frame.origin.x, backImgView.frame.origin.y, backImgView.frame.size.width, 480+IPHONE_FIVE_FACTOR)];
        }
        else
        {
            
            [btnTerms setFrame:CGRectMake(90, 370, 70, 30)];
            [btnPrivacy setFrame:CGRectMake(180, 370,70, 30)];
            [btnskip setFrame:CGRectMake(0, 435,320, 45)];
            [lblcopyright setFrame:CGRectMake(69, 396,202, 32)];
            [backImgView setFrame:CGRectMake(backImgView.frame.origin.x, backImgView.frame.origin.y, backImgView.frame.size.width, 480)];
            
        }
        
    }
    
}
-(IBAction)btnLoginPressed:(id)sender
{
    objLoginViewController =[[LoginViewController alloc] init];
    [self.navigationController pushViewController:objLoginViewController animated:YES];
}
-(IBAction)btnRegisterPressed:(id)sender
{
    objRegistrationViewController=[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    
    [self.navigationController pushViewController:objRegistrationViewController animated:YES];
}
-(IBAction)btnTermsPressed:(id)sender
{
    objHelpViewController=[[HelpViewController alloc] init];
    objHelpViewController.urlStr=@"http://wellconnected.ehealthme.com/terms_condition";
    objHelpViewController.titleStr=@"Terms of Service";
    
    [self.navigationController pushViewController:objHelpViewController animated:YES];
}
-(IBAction)btnPrivacyPressed:(id)sender
{
    objHelpViewController=[[HelpViewController alloc] init];
    objHelpViewController.urlStr=@"http://wellconnected.ehealthme.com/privacy_policy";
    objHelpViewController.titleStr=@"Privacy Policy";
    [self.navigationController pushViewController:objHelpViewController animated:YES];
    
}
-(IBAction)btnSkipPressed:(id)sender
{
    [[AppDelegate sharedAppDelegate] createTabBar];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:FALSE];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
