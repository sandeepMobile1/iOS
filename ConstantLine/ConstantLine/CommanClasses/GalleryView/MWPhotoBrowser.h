//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"

@class ZoomingScrollView;

@interface MWPhotoBrowser : UIViewController <UIScrollViewDelegate, MWPhotoDelegate,NSXMLParserDelegate,UIAlertViewDelegate> {
	UIView *titleview;
	UILabel *titilelabl;
	NSXMLParser *rssParser;
	
	NSString *currentElement;
	NSMutableArray *stories;
	
	NSMutableArray *titleArr;
	NSMutableArray *creditArr;
	NSMutableDictionary *item;
	NSString *currentTitle,*currentCredit,*currentImageURL;
	// Photos
	NSMutableArray *photos;
	
	// Views
	UIScrollView *pagingScrollView;
	
	// Paging
	NSMutableSet *visiblePages, *recycledPages;
	
	NSUInteger pageIndexBeforeRotation;
	
	// Navigation & controls
	UIToolbar *toolbar;
	NSTimer *controlVisibilityTimer;
	UIBarButtonItem *previousButton, *nextButton;

    // Misc
	BOOL performingLayout;
	BOOL rotating;
	
	NSString *strCheckNextPrev;
	BOOL currentFlag;
	BOOL currentFlag1;
	
	UINavigationBar *navigationbar;
	
	BOOL flagImage;
	
}
@property (nonatomic, retain) NSMutableArray *arrImageList;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, retain) NSMutableArray *titleArr,*creditArr;
@property(nonatomic,retain)UILabel *titilelabl;
@property(nonatomic,retain)UIView *titleview;
-(void)demoFunction;
-(void)parseXMLFileAtURL:(NSString*) str;
// Init
//- (id)initWithPhotos:(NSArray *)photosArray;
-(id)init;
// Photos
- (UIImage *)imageAtIndex:(NSUInteger)index;

// Layout
- (void)performLayout;

// Paging
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (ZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index;
- (ZoomingScrollView *)dequeueRecycledPage;
- (void)configurePage:(ZoomingScrollView *)page forIndex:(NSUInteger)index;
- (void)didStartViewingPageAtIndex:(NSUInteger)index;

// Frames
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index;
- (CGRect)frameForNavigationBarAtOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;

// Navigation
- (void)updateNavigation;
- (void)jumpToPageAtIndex:(NSUInteger)index;
- (void)gotoPreviousPage;
- (void)gotoNextPage;

// Controls
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)setControlsHidden:(BOOL)hidden;
- (void)toggleControls;

// Properties
- (void)setInitialPageIndex:(NSUInteger)index;

@end

