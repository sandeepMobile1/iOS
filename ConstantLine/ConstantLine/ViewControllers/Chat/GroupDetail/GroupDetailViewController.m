//
//  GroupDetailViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "JSON.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserProfileData.h"
#import "EditProfileViewController.h"
#import "GroupDetailData.h"

@implementation GroupDetailViewController

@synthesize ratingStr,groupId;

@synthesize arrGroupDetail=_arrGroupDetail;

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
    NSLog(@"groupdetailviewcontroller");
    
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

    
    imgGroupView.layer.cornerRadius =44;
    imgGroupView.clipsToBounds = YES;
    
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
-(void)viewWillAppear:(BOOL)animated
{
    
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
        [service GroupDetailInvocation:gUserId groupId:self.groupId delegate:self]; 
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[objImageCache cancelDownload];
    // objImageCache=nil;
    
    service=nil;
    
    
}

-(void)setvalues
{
    GroupDetailData *data=[self.arrGroupDetail objectAtIndex:0];
    
    lblGroupTitle.text=data.groupTitle;
    lblGroupOwner.text=data.groupOwner;
    lblCreated.text=data.groupCreated;
    lblSubscriptionCharge.text=data.groupCharge;
    lblConnectedMembers.text=data.groupMember;
    ratingStr=data.groupRating;
    txtgroupDescription.text=data.groupIntro;
    
    
    NSLog(@"%@",data.groupRating);
    
    [self setRating];
    [self setImage];
}

-(void)setScrollFrame
{
    
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
    GroupDetailData *data=[self.arrGroupDetail objectAtIndex:0];
    
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gLargeImageUrl,data.groupImage];
    
    NSLog(@"%@",imageurl);
    
    if (data.groupImage==nil || data.groupImage==(NSString *)[NSNull null] || [data.groupImage isEqualToString:@""]) {
        
        
        [imgGroupView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    } 
    else
    {        
        if (imageurl && [imageurl length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:imageurl];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(80, 80);
                }
                else{
                    kImgSize_1=CGSizeMake(80*2, 80*2);
                }
                
                
                
                [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
                
            }
            
            else {
                
                [imgGroupView setImage:img];
            }
            
        }
        
        
        
    }
    
}
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self setImage];
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -------
#pragma Web service delegate

-(void)GroupDetailInvocationDidFinish:(GroupDetailInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSDictionary *responsedic=[result objectForKey:@"response"];
    
    if (self.arrGroupDetail!=nil) {
        
        self.arrGroupDetail=nil;
    }
    self.arrGroupDetail=[[NSMutableArray alloc] init];
    
    NSString *errorStr=[responsedic objectForKey:@"error"];
    
    if (errorStr==nil || errorStr==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[responsedic objectForKey:@"success"];
        
        NSLog(@"%d",[responseArray count]);
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"title",@"owner",@"rating",@"created",@"charge",@"rating",@"connected_member",@"intro",@"image",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                GroupDetailData *data=[[[GroupDetailData alloc] init] autorelease];
                
                data.groupTitle= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"title"]];
                data.groupOwner= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"owner"]];
                data.groupRating= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"rating"]];
                data.groupCreated= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"created"]];
                data.groupCharge= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"charge"]];
                data.groupMember= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"connected_member"]];
               
                data.groupIntro=[self stringByStrippingHTML:[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]]];

               // data.groupIntro= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];
                data.groupImage= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"image"]];
                
                [self.arrGroupDetail addObject:data];
            }
            
            [arrOfResponseField release];
            
            [self setvalues];
            
            
        }
        
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(NSString *) stringByStrippingHTML:(NSString*)intro {
    NSRange r;
    while ((r = [intro rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        intro = [intro stringByReplacingCharactersInRange:r withString:@""];
    
    intro= [intro stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    return intro;
}

- (void)viewDidUnload
{
    _arrGroupDetail=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrGroupDetail release];
    
     [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
