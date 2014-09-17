//
//  GallaryViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GallaryViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"

@implementation GallaryViewController

@synthesize arrImageList;

const CGFloat kScrollObjHeight	= 460.0;
const CGFloat kScrollObjWidth	= 320.0;


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
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    
    [self CreateGalleryView];
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)CreateGalleryView
{
	
    NSLog(@"%d",[arrImageList count]);
    
    [scrollView setBackgroundColor:[UIColor colorWithRed:0.89803921568 green:0.89803921568 blue:0.89803921568 alpha:1.0]];
    [scrollView setCanCancelContentTouches:NO];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.clipsToBounds = YES;		
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
	
    
	if([self.arrImageList count]>0)
	{
		NSUInteger i;
        for (i = 0; i <[self.arrImageList count]; i++)
        {
			UIImageView *galleryImgView=[[[UIImageView alloc] initWithFrame:CGRectMake((i*320), 0, 320, 460)] autorelease];
			[galleryImgView setHidden:FALSE];
			
			NSString *imageStr=[self.arrImageList objectAtIndex:i];
			
            [galleryImgView setImage:[UIImage imageWithContentsOfFile:imageStr]];
            
			[scrollView addSubview:galleryImgView];
            
        }
	}  
	
	
    [self layoutScrollImages];
	[self layoutScrollText];
	
}


- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 15;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 20);
			view.frame = frame;
            curXLoc += (kScrollObjWidth);
			
            
			
		}
	}
	
    [scrollView setContentSize:CGSizeMake((([self.arrImageList count]) * kScrollObjWidth), [scrollView bounds].size.height)];
    
	
}


- (void)layoutScrollText
{
	UILabel *lblView = nil;
	
	NSArray *lblSubviews = [scrollView subviews];
	CGFloat curXLoc = 10;
	
	for (lblView in lblSubviews) {
		if ([lblView isKindOfClass:[UILabel class]] && lblView.tag > 0)
		{
			CGRect textFrame = lblView.frame;
			textFrame.origin = CGPointMake(curXLoc + 10, 90);
			lblView.frame = textFrame;
            
            curXLoc += (kScrollObjWidth);
			
            
		}
		
	}
	
    
    [scrollView setContentSize:CGSizeMake((([self.arrImageList count]) * kScrollObjWidth-50),[scrollView bounds].size.height)];
	
	
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
