//
//  AboutUsViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Config.h"

@implementation AboutUsViewController

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
    
    
   /* webView.delegate=self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];*/
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"About Us"];

    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *backButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 44)]autorelease];
    [backButtoView addSubview:backButton];
    
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButtoView]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    navigation=self.navigationController.navigationBar;
    
  
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        moveTabG=TRUE;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        service=[[ConstantLineServices alloc] init];
        [service AboutUsInvocation:@"" delegate:self];
    }

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
    //webView.delegate=nil;
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
*/

#pragma Mark--------
#pragma Mark Webservice delegate

-(void)AboutUsInvocationDidFinish:(AboutUsInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    NSString *aboutMsg=[result objectForKey:@"message"];
    
    if (aboutMsg==nil || aboutMsg==(NSString*)[NSNull null]) {
        
        txtView.text=@"";
    }
    else
    {
        txtView.text=aboutMsg;
    }
    
    moveTabG=FALSE;
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
