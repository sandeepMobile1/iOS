//
//  HelpViewController.m
//  ConstantLine
//
//  Created by Shweta Sharma on 27/01/14.
//
//

#import "HelpViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

@synthesize urlStr,titleStr;

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
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:titleStr];

    if ([self.titleStr isEqualToString:@"Help"]) {
        
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
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    objWebView.delegate=self;
    objWebView.backgroundColor=[UIColor clearColor];
    objWebView.hidden=YES;
    [objWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    objWebView.hidden=NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Web page is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
	[self.navigationController.navigationBar setUserInteractionEnabled:TRUE];
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
