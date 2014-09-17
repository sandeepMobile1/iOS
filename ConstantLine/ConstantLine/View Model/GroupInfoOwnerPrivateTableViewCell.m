//
//  GroupInfoOwnerPrivateTableViewCell.m
//  ConstantLine
//
//  Created by Pramod Sharma on 22/11/13.
//
//

#import "GroupInfoOwnerPrivateTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoOwnerPrivateTableViewCell

@synthesize btnClear,btnKickOut,cellDelegate,imgView,lblMemberCount,lblTitle;

+(GroupInfoOwnerPrivateTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoOwnerPrivateTableViewCell" owner:owner options:nil];
    
    
    GroupInfoOwnerPrivateTableViewCell* cell = (GroupInfoOwnerPrivateTableViewCell*)[wired firstObjectWithClass:[GroupInfoOwnerPrivateTableViewCell class]];
    
    cell.imgView.layer.cornerRadius =35;
    cell.imgView.clipsToBounds = YES;
    [cell.imgView.layer setBorderWidth:2.0];
    [cell.imgView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}

-(IBAction)btnClearPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ClearOwnerPrivateButtonClick:)])
    {
		[self.cellDelegate ClearOwnerPrivateButtonClick:self];
	}
    
}
-(IBAction)btnKickOutPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(KickOutPrivateButtonClick:)])
    {
		[self.cellDelegate KickOutPrivateButtonClick:self];
	}
    
}
-(IBAction)btnSharePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ShareGroupInfoOwnerPrivateButtonClick:)])
    {
		[self.cellDelegate ShareGroupInfoOwnerPrivateButtonClick:self];
	}
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
