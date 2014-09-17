//
//  MWPhotoBrowser.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "MWPhotoBrowser.h"
#import "ZoomingScrollView.h"
#import "Config.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"

#define PADDING 10

// Handle depreciations and supress hide warnings
@interface UIApplication (DepreciationWarningSuppresion)
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end

// MWPhotoBrowser
@implementation MWPhotoBrowser
@synthesize titleArr,creditArr,titilelabl,titleview,arrImageList,currentPageIndex;
-(id)init {
	if ((self = [super init])) {
		
		// Store photos
		//	photos = [photosArray retain];
		
        // Defaults
		self.wantsFullScreenLayout = YES;
        //self.hidesBottomBarWhenPushed = YES;
		currentPageIndex = 0;
		performingLayout = NO;
		rotating = NO;
		
	}
	return self;
}


#pragma mark -
#pragma mark Memory


#pragma mark -
#pragma mark View

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	titleview=[[UIView alloc]initWithFrame:CGRectMake(0, 345, 320, 55)];
	[titleview setBackgroundColor:[UIColor grayColor]];
	
	titilelabl=[[UILabel alloc]initWithFrame:CGRectMake(20, 380,300 ,50)];
	[titilelabl setBackgroundColor:[UIColor clearColor]];
	[titilelabl setTextColor:[UIColor whiteColor]];
	titilelabl.lineBreakMode=2;
	
	photos=[[NSMutableArray alloc]init];
	
	creditArr=[[NSMutableArray alloc]init];
	
	[self demoFunction];
	
	
	self.wantsFullScreenLayout = YES;
	//self.hidesBottomBarWhenPushed = YES;
	//currentPageIndex = 0;
	performingLayout = NO;
	rotating = NO;
	// View
	self.view.backgroundColor = [UIColor blackColor];
	
	// Setup paging scrolling view
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	pagingScrollView.pagingEnabled = YES;
	//[pagingScrollView setScrollEnabled:FALSE];
	pagingScrollView.delegate = self;
	pagingScrollView.showsHorizontalScrollIndicator = NO;
	pagingScrollView.showsVerticalScrollIndicator = NO;
	pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:currentPageIndex];
	[self.view addSubview:pagingScrollView];
	
    
	
	
	// Setup pages
	visiblePages = [[NSMutableSet alloc] init];
	recycledPages = [[NSMutableSet alloc] init];
	[self tilePages];
    
    // Navigation bar
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
    // Only show toolbar if there's more that 1 photo
	
    if (photos.count > 1) {
        
		toolbar = [[UIToolbar alloc] initWithFrame:[self frameForToolbarAtOrientation:self.interfaceOrientation]];
        toolbar.tintColor = nil;
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:toolbar];
        [toolbar setHidden:TRUE];
        // Toolbar Items
        previousButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonItemArrowLeft.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPreviousPage)]autorelease];
        nextButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonItemArrowRight.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextPage)]autorelease];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:space];
        if (photos.count > 1) [items addObject:previousButton];
        [items addObject:space];
        if (photos.count > 1) [items addObject:nextButton];
        [items addObject:space];
        [toolbar setItems:items];
        [items release];
        [space release];
		
    }
	
	// Super
    [super viewDidLoad];
	
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] hidetabbar];
}
-(void)createSubVIews{
	
	self.wantsFullScreenLayout = YES;
	//self.hidesBottomBarWhenPushed = YES;
	currentPageIndex = 0;
	performingLayout = NO;
	rotating = NO;
	self.view.backgroundColor = [UIColor blackColor];
	
	visiblePages = [[NSMutableSet alloc] init];
	recycledPages = [[NSMutableSet alloc] init];
	[self tilePages];
   	
}

-(void)demoFunction
{
	@try {
		
		
        
        for (int i=0; i<=[self.arrImageList count]-1; i++) {
            
            NSString *imageUrl=[self.arrImageList objectAtIndex:i];
            
            NSString *strCredit=@"";
            
            
            [photos addObject:[MWPhoto photoWithFilePath:imageUrl]];
            [creditArr addObject:strCredit];
            
        }
        
	}
	@catch (NSException *ex) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",ex]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
		[alert release];
	}
	
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	
	stories = [[NSMutableArray alloc] init];
	
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
}


- (void)viewWillAppear:(BOOL)animated {
	
	currentFlag=TRUE;
	currentFlag1=TRUE;
	
	// Super
	[super viewWillAppear:animated];
	//[self.view setBackgroundColor:[UIColor blackColor]];
	//[pagingScrollView setBackgroundColor:[UIColor blackColor]];
	
	// Layout
	[self performLayout];
    
    // Set status bar style to black translucent
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	
	// Navigation
	[self updateNavigation];
	[self hideControlsAfterDelay];
	[self didStartViewingPageAtIndex:currentPageIndex]; // initial
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	// Super
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.3764705882 green:0.4901960784 blue:0.6549019608 alpha:1.0];
    
	// Cancel any hiding timers
	[self cancelControlHiding];
	
}

#pragma mark -
#pragma mark Layout

// Layout subviews
- (void)performLayout {
	
	// Flag
	
    
	
	performingLayout = YES;
	
	// Toolbar
	toolbar.frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
	
	// Remember index
	NSUInteger indexPriorToLayout = currentPageIndex;
	
	// Get paging scroll view frame to determine if anything needs changing
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	
	// Frame needs changing
	pagingScrollView.frame = pagingScrollViewFrame;
	
	// Recalculate contentSize based on current orientation
	pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	
	// Adjust frames and configuration of each visible page
	for (ZoomingScrollView *page in visiblePages) {
		//flagImage = FALSE;
        
		page.frame = [self frameForPageAtIndex:page.index];
		[page setMaxMinZoomScalesForCurrentBounds];
	}
	
	pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];
	
	// Reset
	currentPageIndex = indexPriorToLayout;
	performingLayout = NO;
	
}

#pragma mark -
#pragma mark Photos

// Get image if it has been loaded, otherwise nil
- (UIImage *)imageAtIndex:(NSUInteger)index {
	
    if (photos && index < (photos.count)) {
        
        MWPhoto *photo = [photos objectAtIndex:index];
        
        if ([photo isImageAvailable]) {
            
            titilelabl.text=@"";
            titilelabl.text=[creditArr objectAtIndex:index];
            [self.view addSubview:titilelabl];
            
            return [photo image];
        }
        
        else {
            [photo obtainImageInBackgroundAndNotify:self];
        }
        
		return nil;
    }
}

#pragma mark -
#pragma mark MWPhotoDelegate

- (void)photoDidFinishLoading:(MWPhoto *)photo {
	NSUInteger index = [photos indexOfObject:photo];
	
	
	if (index != NSNotFound) {
		
		if ([self isDisplayingPageForIndex:index]) {
			
			ZoomingScrollView *page = [self pageDisplayedAtIndex:index];
			//if (page && !flagImage){
            //
            //				flagImage = TRUE;
            //				[page displayImage];
            //			}
			
			if (page){
				
				[page displayImage];
			}
			
			
            
		}
	}
	
	
}

- (void)photoDidFailToLoad:(MWPhoto *)photo {
	
	
    flagImage = FALSE;
	
	NSUInteger index = [photos indexOfObject:photo];
	if (index != NSNotFound) {
		if ([self isDisplayingPageForIndex:index]) {
			
			// Tell page it failed
			ZoomingScrollView *page = [self pageDisplayedAtIndex:index];
			if (page) [page displayImageFailure];
			
		}
	}
}

#pragma mark -
#pragma mark Paging

- (void)tilePages {
	
	// Calculate which pages should be visible
	// Ignore padding as paging bounces encroach on that
	// and lead to false page loads
	CGRect visibleBounds = pagingScrollView.bounds;
	int iFirstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
	int iLastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > photos.count - 1) iFirstIndex = photos.count - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > photos.count - 1) iLastIndex = photos.count - 1;
	
	
	
	for (ZoomingScrollView *page in visiblePages) {
		if (page.index < (NSUInteger)iFirstIndex || page.index > (NSUInteger)iLastIndex) {
			[recycledPages addObject:page];
			page.index = NSNotFound; // empty
			[page removeFromSuperview];
		}
	}
	[visiblePages minusSet:recycledPages];
	
	// Add missing pages
	for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
		if (![self isDisplayingPageForIndex:index]) {
			ZoomingScrollView *page = [self dequeueRecycledPage];
			if (!page) {
				page = [[[ZoomingScrollView alloc] init] autorelease];
				page.photoBrowser = self;
			}
            
			[self configurePage:page forIndex:index];
			[visiblePages addObject:page];
			[pagingScrollView addSubview:page];
		}
	}
	
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
	for (ZoomingScrollView *page in visiblePages)
		
		if (page.index == index)
			return YES;
	return NO;
}

- (ZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index {
	ZoomingScrollView *thePage = nil;
	for (ZoomingScrollView *page in visiblePages) {
		if (page.index == index) {
			thePage = page; break;
		}
	}
	return thePage;
}

- (void)configurePage:(ZoomingScrollView *)page forIndex:(NSUInteger)index {
	page.frame = [self frameForPageAtIndex:index];
	page.index = index;
}

- (ZoomingScrollView *)dequeueRecycledPage {
	ZoomingScrollView *page = [recycledPages anyObject];
	if (page) {
		[[page retain] autorelease];
		
		[recycledPages removeObject:page];
	}
	return page;
}

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    NSUInteger i;
		
	if ([photos count]==0) {
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"There is no photo available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		
	}
	else {
		
		[self.navigationController.navigationBar setUserInteractionEnabled:TRUE];
		if (index > 0) {
			
			// Release anything < index - 1
			for (i = 0; i < index-1; i++) { [(MWPhoto *)[photos objectAtIndex:i] releasePhoto];  }
			
			// Preload index - 1
			i = index - 1;
			if (i < photos.count) { [(MWPhoto *)[photos objectAtIndex:i] obtainImageInBackgroundAndNotify:self];  }
			
		}
		if (index < photos.count - 1) {
			
			// Release anything > index + 1
			for (i = index + 2; i < photos.count; i++) { [(MWPhoto *)[photos objectAtIndex:i] releasePhoto];  }
			
			// Preload index + 1
			i = index + 1;
			if (i < photos.count) { [(MWPhoto *)[photos objectAtIndex:i] obtainImageInBackgroundAndNotify:self];  }
			
		}
	}
}

#pragma mark -
#pragma mark Frame Calculations

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    
    
	
	CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = pagingScrollView.bounds;
	
    
    return CGSizeMake(bounds.size.width *(photos.count), bounds.size.height);
	
	
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
	CGFloat pageWidth = pagingScrollView.bounds.size.width;
	CGFloat newOffset = index * pageWidth;
	return CGPointMake(newOffset, 0);
}

- (CGRect)frameForNavigationBarAtOrientation:(UIInterfaceOrientation)orientation {
	CGFloat height = UIInterfaceOrientationIsPortrait(orientation) ? 44 : 32;
	return CGRectMake(0, 20, self.view.bounds.size.width, height);
}

- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
	CGFloat height = UIInterfaceOrientationIsPortrait(orientation) ? 44 : 32;
	return CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height);
}

#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	
	if (performingLayout || rotating) return;
	
	[self tilePages];
	
	CGRect visibleBounds = pagingScrollView.bounds;
	int index = (int)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
	
	if (index==0) {
		
		currentFlag1=FALSE;
		currentFlag=TRUE;
	}
	else {
		
		currentFlag=TRUE;
		currentFlag1=FALSE;
	}
	
	if (index < 0) index = 0;
	if (index > photos.count - 1) index = photos.count - 1;
	
	NSUInteger previousCurrentPage = currentPageIndex;
	currentPageIndex = index;
	if (currentPageIndex != previousCurrentPage) {
		
		[self didStartViewingPageAtIndex:index];
	}
	
	
	
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	// Hide controls when dragging begins
	
	[self setControlsHidden:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// Update nav when page changes
	
	[self updateNavigation];
}

#pragma mark -
#pragma mark Navigation

- (void)updateNavigation {
	
    
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor colorWithRed:0.113725490 green:0.670588235 blue:0.098039275 alpha:1.0];
	self.navigationItem.titleView = label;
	[label release];
	
    
    if (photos.count > 1) {
        
        label.text=[NSString stringWithFormat:@"%i of %i", currentPageIndex+1, photos.count];
        
    }
    else {
        self.title = nil;
		
		
		previousButton.enabled = (currentPageIndex > 0);
		
		nextButton.enabled = (currentPageIndex < photos.count-1);
        
    }
	
}

- (void)jumpToPageAtIndex:(NSUInteger)index {
	
	
	// Change page
    
    if (index < photos.count) {
        CGRect pageFrame = [self frameForPageAtIndex:index];
        pagingScrollView.contentOffset = CGPointMake(pageFrame.origin.x - PADDING, 0);
        [self updateNavigation];
    }
    
    // Update timer to give more time
    [self hideControlsAfterDelay];
    
	
}

- (void)gotoPreviousPage {
	
	[previousButton setEnabled:TRUE];
	
	
	strCheckNextPrev=@"PREV";
	
	
	
	if (currentPageIndex==0) {
		
		[self jumpToPageAtIndex:currentPageIndex];
		
	}
	else {
		
		[self jumpToPageAtIndex:currentPageIndex-1];
	}
	
	
	
}
- (void)gotoNextPage {
	
	
	strCheckNextPrev=@"NEXT";
	currentFlag1=FALSE;
	
	
	
	[self jumpToPageAtIndex:currentPageIndex+1];
	
}

#pragma mark -
#pragma mark Control Hiding / Showing

- (void)setControlsHidden:(BOOL)hidden {
	
	// Get status bar height if visible
	
    
	
	/*CGFloat statusBarHeight = 0;
     if (![UIApplication sharedApplication].statusBarHidden) {
     CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
     statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
     }
     
     // Status Bar
     if ([UIApplication instancesRespondToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
     [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
     } else {
     [[UIApplication sharedApplication] setStatusBarHidden:hidden animated:YES];
     }
     
     // Get status bar height if visible
     if (![UIApplication sharedApplication].statusBarHidden) {
     CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
     statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
     }
     
     // Set navigation bar frame
     CGRect navBarFrame = self.navigationController.navigationBar.frame;
     navBarFrame.origin.y = statusBarHeight;
     self.navigationController.navigationBar.frame = navBarFrame;
     
     // Bars
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.35];
     [self.navigationController.navigationBar setAlpha:hidden ? 0 : 1];
     [toolbar setAlpha:hidden ? 0 : 1];
     [UIView commitAnimations];
     
     // Control hiding timer
     // Will cancel existing timer but only begin hiding if
     // they are visible
     [self hideControlsAfterDelay];*/
	
}

- (void)cancelControlHiding {
	// If a timer exists then cancel and release
	if (controlVisibilityTimer) {
		[controlVisibilityTimer invalidate];
		[controlVisibilityTimer release];
		controlVisibilityTimer = nil;
	}
}

// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
	/*[self cancelControlHiding];
     if (![UIApplication sharedApplication].isStatusBarHidden) {
     
     controlVisibilityTimer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControls) userInfo:nil repeats:NO] retain];
     }*/
}

- (void)hideControls { [self setControlsHidden:YES]; }
- (void)toggleControls { [self setControlsHidden:![UIApplication sharedApplication].isStatusBarHidden]; }


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) {
		
		[self.navigationController popViewControllerAnimated:YES];
	}
}



#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	// Remember page index before rotation
	pageIndexBeforeRotation = currentPageIndex;
	rotating = YES;
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	// Perform layout
	currentPageIndex = pageIndexBeforeRotation;
	[self performLayout];
	
	// Delay control holding
	[self hideControlsAfterDelay];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	rotating = NO;
}

#pragma mark -
#pragma mark Properties

- (void)setInitialPageIndex:(NSUInteger)index {
	if (![self isViewLoaded]) {
		if (index >= photos.count) {
			currentPageIndex = 0;
		} else {
			currentPageIndex = index;
		}
	}
}

- (void)didReceiveMemoryWarning {
	
	// Release any cached data, images, etc that aren't in use.
	
	// Release images
	[photos makeObjectsPerformSelector:@selector(releasePhoto)];
	[recycledPages removeAllObjects];
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

// Release any retained subviews of the main view.
- (void)viewDidUnload {
	currentPageIndex = 0;
    [pagingScrollView release], pagingScrollView = nil;
    [visiblePages release], visiblePages = nil;
    [recycledPages release], recycledPages = nil;
    [toolbar release], toolbar = nil;
    [previousButton release], previousButton = nil;
    [nextButton release], nextButton = nil;
}


- (void)dealloc {
	
	[photos release];
	[pagingScrollView release];
	[visiblePages release];
	[recycledPages release];
	[toolbar release];
	[previousButton release];
	[nextButton release];
	[titleview release];
	[creditArr release];
	[titilelabl release];
	[titleArr release];
    
    [super dealloc];
}
@end

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	
}
@end

