//
//  AddContactViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddContactViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "ExistingContactListViewController.h"
#import "PhoneContactsViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation AddContactViewController


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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Add Contacts"];
    
    
    navigation=self.navigationController.navigationBar;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    
       
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    // Do any additional setup after loading the view from its
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
}

- (void)didReceiveBackgroundNotification:(NSNotification*) note
{
    
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(IBAction)btnExistingContact:(id)sender
{
    objExistingView=[[ExistingContactListViewController alloc] init];
    objExistingView.checkView=@"contact";
    [self.navigationController pushViewController:objExistingView animated:YES];
}

-(IBAction)btnphoneContact:(id)sender
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            // First time access has been granted, add the contact
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        // The user has previously given access, add the contact
    }
    else {
        
    // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }

    objPhoneContactView=[[PhoneContactsViewController alloc] init];
    [self.navigationController pushViewController:objPhoneContactView animated:YES];
    
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
