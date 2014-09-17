//
//  SubscriptionPlanViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionPlanViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "Config.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@implementation SubscriptionPlanViewController

@synthesize planStr,chargeStr;

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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Subscription"];
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
 
    
    UIButton *CancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [CancelButton setImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
    [CancelButton setFrame:CGRectMake(0,7, 55,29)];
    [CancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *cancelButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 44)]autorelease];
    [cancelButtoView addSubview:CancelButton];
    
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:cancelButtoView]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:[UIImage imageNamed:@"done_btn.png"] forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(0,7, 50,29)];
    [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *doneButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)]autorelease];
    [doneButtoView addSubview:doneButton];
    
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:doneButtoView] autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;
    if (pickerArray!=nil) {
        pickerArray=nil;
    }
    
    pickerArray=[[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIBarButtonItem *btnAccessDone4 = [[[UIBarButtonItem alloc]
                                        initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnPickerDonePressed:)]autorelease];
	
	
	UIBarButtonItem *btnFlex4=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]autorelease];
    
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 150+IPHONE_FIVE_FACTOR, 320, 40)];
            
        }
        else
        {
            toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 150, 320, 40)];
            
        }
    
    
    [toolBar setBackgroundColor:[UIColor blackColor]];
    [toolBar setItems:[NSArray arrayWithObjects:btnFlex4,btnAccessDone4,nil]];
    [toolBar setTintColor:[UIColor blackColor]];
    
    [self.view addSubview:toolBar]; 	
    
    if (pickerView==nil) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 190+IPHONE_FIVE_FACTOR, 320, 200)];
                }
                else
                {
                    pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 190, 320, 200)];
                    
                }
            
 
            toolBar.barStyle=UIBarStyleDefault;
            pickerView.backgroundColor=[UIColor whiteColor];

        }
        else{
            
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 190+IPHONE_FIVE_FACTOR, 320, 200)];
                }
                else
                {
                    pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 190, 320, 200)];
                    
                }
            
 
        }

        [pickerView setDelegate:self];
        [pickerView setShowsSelectionIndicator:TRUE];
        [self.view addSubview:pickerView]; 
    }
	
    [toolBar setHidden:TRUE];
	[pickerView setHidden:TRUE];
    
    NSLog(@"gSubscriptionPlan %@",gSubscriptionPlan);
    NSLog(@"gSubscriptionCharge %@",gSubscriptionCharge);
    
    if ([gSubscriptionCharge isEqualToString:@""] || [gSubscriptionPlan isEqualToString:@""]) {
        
        lblSubscriptionPeriod.text=@"Select";
        lblCharge.text=@"Select";
    }
    else
    {
        self.planStr=gSubscriptionPlan;
        self.chargeStr=gSubscriptionCharge;
        
        [lblSubscriptionPeriod setText:[NSString stringWithFormat:@"%@ Month",gSubscriptionPlan]];
        [lblCharge setText:[NSString stringWithFormat:@"$%@",gSubscriptionCharge]];
        
                
    }
	
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(IBAction)cancelButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)doneButtonClick:(id)sender
{
    if ([lblCharge.text isEqualToString:@"Select"] || [lblSubscriptionPeriod.text isEqualToString:@"Select"]) {
        
        gSubscriptionPlan=@"";
        gSubscriptionCharge=@"";
        
    }
    else
    {
        if ([self.planStr length]<=0) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Select trail period" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else if ([self.chargeStr length]<=0)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Select subscription charge" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];

        }
        else
        {
            gSubscriptionPlan=[self.planStr retain];
            gSubscriptionCharge=[self.chargeStr retain];
        }
       
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(IBAction)btnSubscriptionPressed:(id)sender
{
    [pickerArray removeAllObjects];
    
    checkPickerView=@"Period";
    
    for (int i=0; i<=13; i++) {
        
        if (i==0) {
            
            [pickerArray addObject:[NSString stringWithFormat:@"%@",@"Select"]];
            
        }
        else
        {
            int month=i-1;
            
            [pickerArray addObject:[NSString stringWithFormat:@"%d",month]];
            
        }
        
    }

    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    [pickerView reloadAllComponents];
    
    
}
-(IBAction)btnChargePressed:(id)sender
{
    checkPickerView=@"Charge";
    
    [pickerArray removeAllObjects];
    
    [pickerArray addObject:@"Select"];
    [pickerArray addObject:@"1"];
    [pickerArray addObject:@"2"];
    [pickerArray addObject:@"5"];
    [pickerArray addObject:@"10"];
    [pickerArray addObject:@"20"];
    [pickerArray addObject:@"50"];
    [pickerArray addObject:@"100"];

    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    [pickerView reloadAllComponents];
}

#pragma Picker delegate

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen
{
    NSString *titleStr=@"";
    
    if ([checkPickerView isEqualToString:@"Period" ]) {
        
        NSString *str=[pickerArray objectAtIndex:row];
        
        if ([str isEqualToString:@"Select"]) {
            
            titleStr=str;
        }
        else
        {
            str=[str stringByAppendingFormat:@" Month"];
            titleStr=str;
        }
        
       
    }
    else
    {
        NSString *str=[pickerArray objectAtIndex:row];
        
        if ([str isEqualToString:@"Select"]) {
            
            titleStr=str;
        }
        else
        {
        titleStr=[NSString stringWithFormat:@"$ %@",str];
            
        }

    }
    
    return titleStr;
}
-(IBAction)btnPickerDonePressed:(id)sender
{
    NSString *selectedStr=[pickerArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    [pickerView setHidden:TRUE];
    [toolBar setHidden:TRUE];
    
    if ([checkPickerView isEqualToString:@"Period"]) {
        
       // gSubscriptionPlan=[selectedStr retain];

        self.planStr=selectedStr;
        
        if ([selectedStr isEqualToString:@"Select"]) {

          lblSubscriptionPeriod.text=[selectedStr retain];  

        }
        else
        {
            lblSubscriptionPeriod.text=[NSString stringWithFormat:@"%@%@",selectedStr,@" Month"];  

        }
    }
    else
    {
        self.chargeStr=selectedStr;
        
        //gSubscriptionCharge=selectedStr;

        if ([selectedStr isEqualToString:@"Select"]) {
            
            lblCharge.text=selectedStr;  

        }
        else
        {
            lblCharge.text=[NSString stringWithFormat:@"$%@",selectedStr];  

        }
        
    }
    
    
    
}

// Do any additional setup after loading the view from its nib.
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
