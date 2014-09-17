//
//  GroupInfoOwnerTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GroupInfoOwnerTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoOwnerTableViewCell

@synthesize btnManage,btnShare,btnClear,btnKick,cellDelegate,btnPublic,btnPrivate;



+(GroupInfoOwnerTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	NSArray *wired;
	
    wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoOwnerTableViewCell" owner:owner options:nil];
    
    GroupInfoOwnerTableViewCell* cell = (GroupInfoOwnerTableViewCell*)[wired firstObjectWithClass:[GroupInfoOwnerTableViewCell class]];
    
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

-(IBAction)btnPublicPressed:(UIButton *)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(btnPublicClick:)])
    {
		[self.cellDelegate btnPublicClick:self];
	}
}
-(IBAction)btnPrivatePressed:(UIButton *)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(btnPrivateClick:)])
    {
		[self.cellDelegate btnPrivateClick:self];
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
    
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
