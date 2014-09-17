//
//  GroupInfoUserTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupInfoUserTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoUserTableViewCell

@synthesize btnShare,btnClear,btnQuit,btnUnSubscribe,btnRating1,btnRating2,btnRating3,btnRating4,btnRating5,cellDelegate,btnOwnerRating1,btnOwnerRating2,btnOwnerRating3,btnOwnerRating4,btnOwnerRating5;


+(GroupInfoUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
        wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoUserTableViewCell" owner:owner options:nil];
    
   
    GroupInfoUserTableViewCell* cell = (GroupInfoUserTableViewCell*)[wired firstObjectWithClass:[GroupInfoUserTableViewCell class]];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnSharePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ShareButtonClick:)]) 
    {
		[self.cellDelegate ShareButtonClick:self];
	}
    
}

-(IBAction)btnClearPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ClearButtonClick:)]) 
    {
		[self.cellDelegate ClearButtonClick:self];
	}
    
}
-(IBAction)btnQuitPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(QuitButtonClick:)]) 
    {
		[self.cellDelegate QuitButtonClick:self];
	}

}
-(IBAction)btnUnsubcribedPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(UnsubscribedButtonClick:)])
    {
		[self.cellDelegate UnsubscribedButtonClick:self];
	}
}
-(IBAction)btnRating1Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ratingButonClick1:)]) 
    {
		[self.cellDelegate ratingButonClick1:self];
	}
    
}
-(IBAction)btnRating2Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ratingButonClick2:)]) 
    {
		[self.cellDelegate ratingButonClick2:self];
	}
    
}
-(IBAction)btnRating3Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ratingButonClick3:)]) 
    {
		[self.cellDelegate ratingButonClick3:self];
	}
    
}
-(IBAction)btnRating4Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ratingButonClick4:)]) 
    {
		[self.cellDelegate ratingButonClick4:self];
	}
    
}
-(IBAction)btnRating5Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ratingButonClick5:)]) 
    {
		[self.cellDelegate ratingButonClick5:self];
	}
    
}

-(IBAction)btnOwnerRating1Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ownerRatingButonClick1:)]) 
    {
		[self.cellDelegate ownerRatingButonClick1:self];
	}
}
-(IBAction)btnOwnerRating2Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ownerRatingButonClick2:)]) 
    {
		[self.cellDelegate ownerRatingButonClick2:self];
	}
}
-(IBAction)btnOwnerRating3Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ownerRatingButonClick3:)]) 
    {
		[self.cellDelegate ownerRatingButonClick3:self];
	}
}
-(IBAction)btnOwnerRating4Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ownerRatingButonClick4:)]) 
    {
		[self.cellDelegate ownerRatingButonClick4:self];
	}
}
-(IBAction)btnOwnerRating5Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ownerRatingButonClick5:)]) 
    {
		[self.cellDelegate ownerRatingButonClick5:self];
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.btnShare= nil;
    self.btnClear= nil;
    self.btnOwnerRating1= nil;
    self.btnOwnerRating2= nil;
    self.btnOwnerRating3= nil;
    self.btnOwnerRating4= nil;
    self.btnOwnerRating5= nil;
    
    self.btnRating1= nil;
    self.btnRating2= nil;
    self.btnRating3= nil;
    self.btnRating4= nil;
    self.btnRating5= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
