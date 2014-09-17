//
//  GroupInfoUserPrivateTableViewCell.m
//  ConstantLine
//
//  Created by Pramod Sharma on 22/11/13.
//
//

#import "GroupInfoUserPrivateTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoUserPrivateTableViewCell

@synthesize btnClear,btnQuit,cellDelegate,imgView,lblMemberCount,lblTitle;

+(GroupInfoUserPrivateTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoUserPrivateTableViewCell" owner:owner options:nil];
    
    
    GroupInfoUserPrivateTableViewCell* cell = (GroupInfoUserPrivateTableViewCell*)[wired firstObjectWithClass:[GroupInfoUserPrivateTableViewCell class]];
    
    cell.imgView.layer.cornerRadius =35;
    cell.imgView.clipsToBounds = YES;
    [cell.imgView.layer setBorderWidth:2.0];
    [cell.imgView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}

-(IBAction)btnClearPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ClearUserPrivateButtonClick:)])
    {
		[self.cellDelegate ClearUserPrivateButtonClick:self];
	}
    
}
-(IBAction)btnQuitPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(QuitUserPrivateButtonClick:)])
    {
		[self.cellDelegate QuitUserPrivateButtonClick:self];
	}
    
}
-(IBAction)btnSharePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ShareButtonClick:)])
    {
		[self.cellDelegate ShareGroupInfoUserPrivateButtonClick:self];
	}
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
