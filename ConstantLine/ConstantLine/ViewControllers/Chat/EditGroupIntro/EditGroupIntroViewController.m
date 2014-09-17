//
//  EditGroupIntroViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EditGroupIntroViewController.h"
#import "Config.h"
#import "JSON.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "GroupDetailData.h"
#import "QSStrings.h"

@implementation EditGroupIntroViewController

@synthesize groupId;

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
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Group Detail"];
    
    
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
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        moveTabG=TRUE;
        
        if (service!=nil) {
            service=nil;
        }
        service=[[ConstantLineServices alloc] init];
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          [service GroupDetailInvocation:gUserId groupId:self.groupId delegate:self]; 
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    service=nil;
}

-(IBAction)btnEditIntroPressed:(id)sender
{
    
    txtView.text= [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([txtView.text length]>0) {
       
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            
            
            
            NSString * base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                           NULL,
                                                                                           (CFStringRef)txtView.text,
                                                                                           NULL,
                                                                                           (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                           kCFStringEncodingUTF8 )autorelease];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [service EditIntroOfGroupInvocation:gUserId groupId:self.groupId intro:base64String delegate:self];
        }

    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please fill intro" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

#pragma Mark
#pragma webservice delegate
-(void)GroupDetailInvocationDidFinish:(GroupDetailInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        if ([result count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"Charge",@"created",@"groupCode",@"id",@"image",@"intro",@"name",@"paidStatus",@"rating",@"status",@"type",@"ownerId",@"threadId",@"memberCount",@"user_ids",@"groupRating",@"ownerRating",nil];
            
            for (NSMutableArray *arrValue in result) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
               // txtView.text=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];

               txtView.text=[self stringByStrippingHTML:[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]]];

                
            }
            
            [arrOfResponseField release];
        } 
        
        
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(NSString *) stringByStrippingHTML:(NSString*)intro {
    NSRange r;
    while ((r = [intro rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        intro = [intro stringByReplacingCharactersInRange:r withString:@""];
    
    intro= [intro stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    return intro;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)EditIntroOfGroupInvocationDidFinish:(EditIntroOfGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        
        successAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];
    }
    
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
    
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
    CGFloat availableHeight = applicationFrame.size.height - 310;           	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
	
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollViewToCenterOfScreen:textView];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   /* if (range.length==0) 
	{
		if ([text isEqualToString:@"\n"])
		{
			[textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
			return NO;
		}
		
	}
	return YES;*/
    
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSLog(@"input %d chars", newText.length);
    
    totalCharacterCout=400-newText.length;
    
    if (totalCharacterCout>=0 && totalCharacterCout<=400) {
        
        
        if ([text isEqualToString:@"\n"])
        {   
            [textView resignFirstResponder];
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
        }
        return YES;
        
    }else{
        if ([text isEqualToString:@"\n"])
        {            
            
            [textView resignFirstResponder];
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            
        }
        return NO;
    }
    
    return YES;
}


- (void)viewDidUnload
{
    self.groupId=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    self.groupId=nil;
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
