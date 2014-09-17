//
//  GroupInfoFirstTableViewCellController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupInfoFirstTableViewCellController.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoFirstTableViewCellController

@synthesize lblGroupName,lblGroupDescription,btnRating1,btnRating2,btnRating3,btnRating4,btnRating5,imgView,imgBackCellImage,cellDelegate,lblUploadImage,lblTapTo,lblVoteCount;


+(GroupInfoFirstTableViewCellController*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoFirstTableViewCellController" owner:owner options:nil];
        GroupInfoFirstTableViewCellController* cell = (GroupInfoFirstTableViewCellController*)[wired firstObjectWithClass:[GroupInfoFirstTableViewCellController class]];
  
    cell.imgView.layer.cornerRadius =5;
    cell.imgView.clipsToBounds = YES;
    [cell.imgView.layer setBorderWidth:2.0];
    [cell.imgView.layer setBorderColor:[[UIColor grayColor] CGColor]];

    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ButtonClick:)]) 
    {
		[self.cellDelegate ButtonClick:self];
	}
}
-(IBAction)btnMorePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(MoreButtonClick:)])
    {
		[self.cellDelegate MoreButtonClick:self];
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.lblGroupName= nil;
    self.lblGroupDescription= nil;
    self.imgView= nil;
    self.btnRating1= nil;
    self.btnRating2= nil;
    self.btnRating3= nil;
    self.btnRating4= nil;
    self.btnRating5= nil;
    self.imgBackCellImage= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
