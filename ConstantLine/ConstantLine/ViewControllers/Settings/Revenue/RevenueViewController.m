//
//  RevenueViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 11/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RevenueViewController.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import "AppConstant.h"
#import "AppDelegate.h"
#import "Config.h"
#import "MBProgressHUD.h"

@implementation RevenueViewController

@synthesize strTransactionId,productId,productName,productPrice,groupId;

static NSString        *ALERT_TITLE            = @"Purchase Upgrade";

SKProductsRequest *request;

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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Revenue"];
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;

    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;

    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnPurchasePressed:(id)sender
{
    service=[[ConstantLineServices alloc] init];
    [service RevenueInvocation:gUserId groupId:self.groupId transactionId:@"45676962345" subCharge:@"10" delegate:self];

}
#pragma mark -
#pragma mark Store delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"productsRequest");
	
	NSArray *myProduct = response.products;
	
	NSLog(@"%@",myProduct);
	
	if (myProduct == nil || [myProduct count] == 0) 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:@"Missing product from App store.\n"
													   delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		return;
	}
		[self startPurchase];
	
	
}
-(void)requestDidFinish:(SKRequest *)request  
{  
	NSLog(@"requestDidFinish");
	
    [request release];  
}
- (void) startPurchase {
	
	NSLog(@"startPurchase");
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:[NSString stringWithFormat:@"%@",self.productId]];
	NSLog(@"startPurchase1");
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self]; 
	NSLog(@"startPurchase2");
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	NSLog(@"startPurchase3");
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error  
{  
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);  
} 
#pragma mark -
#pragma mark observer delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"paymentQueue");
	
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				NSLog(@"Success");
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				NSLog(@"Failed");
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"completeTransaction");
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
	self.strTransactionId=transaction.transactionIdentifier;
    
    [service RevenueInvocation:gUserId groupId:self.groupId transactionId:self.strTransactionId subCharge:self.productId delegate:self];
    

		
	NSString *successMsg=@"Congratulation You have just bought ";
	successMsg=[successMsg stringByAppendingFormat:@"%@%@%@",self.productName,@" for ",self.productPrice];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:successMsg delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{ 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:@"Purchase success." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		NSString *stringError = [NSString stringWithFormat:@"Payment Cancelled\n\n%@", [transaction.error localizedDescription]];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:stringError delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma --------------------------
#pragma Webservice delegate

-(void)RevenueInvocationDidFinish:(RevenueInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
