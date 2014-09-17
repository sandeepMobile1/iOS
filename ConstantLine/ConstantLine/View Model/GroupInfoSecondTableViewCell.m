//
//  GroupInfoSecondTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupInfoSecondTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoSecondTableViewCell

@synthesize btnManage,btnShare,btnClear,btnKick,btnUnSubscribe,btnRating1,btnRating2,btnRating3,btnRating4,btnRating5,cellDelegate,btnOwnerRating1,btnOwnerRating2,btnOwnerRating3,btnOwnerRating4,btnOwnerRating5;


+(GroupInfoSecondTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoSecondTableViewCell" owner:owner options:nil];

    
   GroupInfoSecondTableViewCell* cell = (GroupInfoSecondTableViewCell*)[wired firstObjectWithClass:[GroupInfoSecondTableViewCell class]];
        
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnManagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ManageButtonClick:)]) 
    {
		[self.cellDelegate ManageButtonClick:self];
	}
}
-(IBAction)btnSharePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ShareButtonClick:)]) 
    {
		[self.cellDelegate ShareButtonClick:self];
	}

}
-(IBAction)btnKickPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(KickButtonClick:)]) 
    {
		[self.cellDelegate KickButtonClick:self];
	}

}
-(IBAction)btnClearPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ClearButtonClick:)]) 
    {
		[self.cellDelegate ClearButtonClick:self];
	}

}
-(IBAction)btnUnsubcribedPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(UnsubscribedPrivilageButtonClick:)])
    {
		[self.cellDelegate UnsubscribedPrivilageButtonClick:self];
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
    
    self.btnManage= nil;
    self.btnShare= nil;
    self.btnClear= nil;
    self.btnKick= nil;
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
