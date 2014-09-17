//
//  UserProfileViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "UserProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "JSON.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserProfileData.h"
#import "EditProfileViewController.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "ChatViewController.h"

@implementation UserProfileViewController

@synthesize ratingStr,userId,navTitle,checkBackButton;

@synthesize arrUserProfileData = _arrUserProfileData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


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
    
    [scrollView setContentSize:CGSizeMake(320, 520)];
    
    if (self.arrUserProfileData==nil) {
        
        self.arrUserProfileData=[[NSMutableArray alloc] init];
    }
    imgView.layer.cornerRadius =50;
    imgView.clipsToBounds = YES;
    [imgView.layer setBorderWidth:5.0];
    [imgView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }

    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:navTitle];

    
    if ([self.checkBackButton isEqualToString:@"Setting"]) {
        
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0,0, 53,53)];
        [backButton setTitle: @"" forState:UIControlStateNormal];
        backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
        self.navigationItem.leftBarButtonItem=leftBtn;
    }
    else
    {
        UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [menuButton setFrame:CGRectMake(0,0, 25,29)];
        [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem=left;

    }
    
        
    btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setFrame:CGRectMake(0,6, 45,29)];
    [btnEdit setTitle: @"Edit" forState:UIControlStateNormal];
    btnEdit.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:18];
    [btnEdit addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editBtn=[[[UIBarButtonItem alloc]initWithCustomView:btnEdit]autorelease];
    self.navigationItem.rightBarButtonItem=editBtn;
    [btnAddContacts setHidden:TRUE];
        
      // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 568)];
            
            
        }
        else
        {
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 568-IPHONE_FIVE_FACTOR)];
            
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y,scrollView.frame.size.width, 480)];
            
            
        }
        else
        {
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 480-IPHONE_FIVE_FACTOR)];
            
            
            
            
        }
        
    }
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        moveTabG=TRUE;
        
        if (service!=nil) {
            service=nil;
        }
        if (objImageCache!=nil) {
            objImageCache=nil;
        }
        objImageCache=[[ImageCache alloc] init];
        objImageCache.delegate=self;
        
        service=[[ConstantLineServices alloc] init];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
        [service UserProfileInvocation:self.userId delegate:self]; 
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [objImageCache cancelDownload];
    objImageCache=nil;

    service=nil;
}

-(void)setvalues
{
    UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
    lblDispName.text=data.display_name;
    lblEmail.text=data.email;
    lblContactEmail.text=data.contact_email;
    lblDob.text=data.dob;
    lblPassword.text=data.password;

    txtIntro.text=data.intro;
    ratingStr=data.rating;
    lblNumOfGroup.text=data.num_of_groups;
    lblGender.text=[data.gender capitalizedString];
    
    if ([data.friend_status isEqualToString:@"0"])
    {
        
        [btnAddContacts setHidden:FALSE];
        
    }
    else
    {
        [btnAddContacts setHidden:TRUE];
    }
    NSLog(@"%@",data.rating);
    
    [self setRating];
    [self setImage];
}
-(void)setRating
{
    if ([ratingStr isEqualToString:@""] || [ratingStr isEqualToString:@"0"]) {
        
        [btnRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([ratingStr isEqualToString:@"1"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([ratingStr isEqualToString:@"2"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"3"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"4"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"5"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}
-(void)setImage
{
    UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
   
   NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.user_image];
    
    NSLog(@"%@",imageurl);
    
    if (data.user_image==nil || data.user_image==(NSString *)[NSNull null] || [data.user_image isEqualToString:@""]) {
        
        
        [imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    } 
    else
    {        
        if (imageurl && [imageurl length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:imageurl];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(200, 200);
                }
                else{
                    kImgSize_1=CGSizeMake(200, 200);
                }
                
                [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
            }
            else {
                
                [imgView setImage:img];
            }
            
        }
        
    }
    
}
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self setImage];
}
-(void)backButtonClick:(UIButton *)sender{
    
    if (moveTabG==FALSE) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }
}
-(IBAction)editButtonClick:(id)sender
{
    if (moveTabG==FALSE) {
        
        EditProfileViewController *objEditProfileViewController;
        objEditProfileViewController=[[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
        
        [self.navigationController pushViewController:objEditProfileViewController animated:YES];
        
        [objEditProfileViewController release];

    }
    
}


-(IBAction)btnratingPressed1:(id)sender
{
    
}
-(IBAction)btnratingPressed2:(id)sender
{
    
}
-(IBAction)btnratingPressed3:(id)sender
{
    
}
-(IBAction)btnratingPressed4:(id)sender
{
    
}
-(IBAction)btnratingPressed5:(id)sender
{
    
}


#pragma ------------
#pragma Webservice delegate

-(void)UserProfileInvocationDidFinish:(UserProfileInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSDictionary *responsedic=[result objectForKey:@"response"];
    
    [self.arrUserProfileData removeAllObjects];
    
    NSString *errorStr=[responsedic objectForKey:@"error"];
    
    if (errorStr==nil || errorStr==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[responsedic objectForKey:@"success"];
        
        NSLog(@"%d",[responseArray count]);
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"display_name",@"dob",@"email",@"gender",@"no_of_groups",@"rating",@"user_id",@"user_image",@"user_name",@"contactEmail",@"password",@"intro",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                UserProfileData *data=[[[UserProfileData alloc] init] autorelease];
                
                data.user_id= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                data.user_name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                data.display_name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"display_name"]];
                data.email=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"email"]];   
                data.gender=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"gender"]];
                data.dob=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"dob"]];
                data.rating=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"rating"]];
                data.user_image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
                
                gUserImage=data.user_image;
                
                data.contact_email=[arrValue valueForKey:@"contactEmail"];
                data.password=[arrValue valueForKey:@"password"];

                data.num_of_groups= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"no_of_groups"]];
                data.intro= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];

                if ([data.num_of_groups isEqualToString:@""]) {
                    
                    data.num_of_groups=@"0";
                }
                
                NSLog(@"%@",data.rating);
                
                [self.arrUserProfileData addObject:data];
            }
            
            [arrOfResponseField release];      
                       
            
        }
        
        
        [self setvalues];

        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    
    
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



- (void)viewDidUnload
{
    
    
    _arrUserProfileData=nil;
    self.ratingStr=nil;
    self.userId=nil;
    self.navTitle=nil;

    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrUserProfileData release];
    self.ratingStr=nil;
    self.userId=nil;
    self.navTitle=nil;
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
