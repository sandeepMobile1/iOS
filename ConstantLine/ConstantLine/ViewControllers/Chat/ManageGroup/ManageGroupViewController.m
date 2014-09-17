//
//  ManageGroupViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ManageGroupViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "EditGroupIntroViewController.h"
#import "KickOffMemberViewController.h"

@implementation ManageGroupViewController

@synthesize groupId,checkUser,ownerId,userIds,closeStatus,threadId;

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
    
        if (service!=nil) {
            
            service=nil;
        }
                
        service=[[ConstantLineServices alloc] init];
       
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Manage Group"];
    
    // Do any additional setup after loading the view from its nib.
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;


    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    if ([self.closeStatus isEqualToString:@"1"]) {
        
        [lblCloseGroup setText:@"Open Group"];
        [lblCloseGroupDesc setText:@"Group will be re-opened for new members"];
    }
    else
    {
        [lblCloseGroup setText:@"Close Group"];
        [lblCloseGroupDesc setText:@"Group will not accept new member and display 'Closed for new member' status on the search result."];
    }
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   
    
}
-(IBAction)btnCloseGroupPressed:(id)sender
{
    int status=[[AppDelegate sharedAppDelegate] netStatus];
        
    if(status==0)
    {
        moveTabG=TRUE;

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([self.closeStatus isEqualToString:@"1"]) {
            
            [service CloseGroupInvocation:self.groupId groupStatus:@"0" userId:gUserId threadId:self.threadId delegate:self];
            
        }
        else
        {
            [service CloseGroupInvocation:self.groupId groupStatus:@"1" userId:gUserId threadId:self.threadId delegate:self];
            
            
        }
        
    }

    
}
-(IBAction)btnEditGroupPressed:(id)sender
{
    EditGroupIntroViewController *objEditGroupIntroView;
    
     objEditGroupIntroView=[[EditGroupIntroViewController alloc] initWithNibName:@"EditGroupIntroViewController" bundle:nil];

    
    objEditGroupIntroView.groupId=self.groupId;
    [self.navigationController pushViewController:objEditGroupIntroView animated:YES];
    [objEditGroupIntroView release];

}
-(IBAction)btnPrivilegeGroupPressed:(id)sender
{
    if ([self.ownerId isEqualToString:gUserId]) {
        
       
            objKickofmember=[[KickOffMemberViewController alloc] initWithNibName:@"KickOffMemberViewController" bundle:nil];

        objKickofmember.memberIds=self.userIds;
        objKickofmember.threadId=@"";
        objKickofmember.groupId=self.groupId;
        objKickofmember.ownerId=self.ownerId;
        objKickofmember.checkView=@"privilege";
        
        [self.navigationController pushViewController:objKickofmember animated:YES];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Only owner can assign privilege" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(IBAction)btnQuitGroupPressed:(id)sender
{
    if ([self.ownerId isEqualToString:gUserId]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You can not quit this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [service QuitGroupInvocation:gUserId groupId:self.groupId ownerId:self.ownerId type:@"1" delegate:self];
            
        }
 
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
#pragma mark
#pragma Webservice delegate


-(void)CloseGroupInvocationDidFinish:(CloseGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        if ([self.closeStatus isEqualToString:@"1"]) {
            
            self.closeStatus=@"0";
            
            [lblCloseGroup setText:@"Close Group"];
            [lblCloseGroupDesc setText:@"Group will not accept new member and display 'Closed for new member' status on the search result."];
            
        }
        else
        {
            self.closeStatus=@"1";

            [lblCloseGroup setText:@"Open Group"];
            [lblCloseGroupDesc setText:@"Group will be re-opened for new members"];
        }
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)QuitGroupInvocationDidFinish:(QuitGroupInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        
        NSString *sqlStatement=[NSString stringWithFormat:@"delete from tbl_chat where GroupId= '%@'",self.groupId];
        
        NSLog(@"%@",sqlStatement);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
            
            
        }
        successAlert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    self.groupId=nil;
    self.ownerId=nil;
    self.userIds=nil;
    self.checkUser=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    self.groupId=nil;
    self.ownerId=nil;
    self.userIds=nil;
    self.checkUser=nil;
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
