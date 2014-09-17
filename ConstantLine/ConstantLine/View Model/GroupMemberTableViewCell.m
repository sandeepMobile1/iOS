//
//  GroupMemberTableViewCell.m
//  ConstantLine
//
//  Created by Shweta Sharma on 30/06/14.
//
//

#import "GroupMemberTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupMemberTableViewCell

@synthesize btnImage,btnImage1,btnImage2,btnImage3;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(GroupMemberTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    wired = [[NSBundle mainBundle] loadNibNamed:@"GroupMemberTableViewCell" owner:owner options:nil];
    
    
    GroupMemberTableViewCell* cell = (GroupMemberTableViewCell*)[wired firstObjectWithClass:[GroupMemberTableViewCell class]];
    
    cell.btnImage.layer.cornerRadius =32;
    cell.btnImage.clipsToBounds = YES;
    [cell.btnImage.layer setBorderWidth:2.0];
    [cell.btnImage.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    
    cell.btnImage1.layer.cornerRadius =32;
    cell.btnImage1.clipsToBounds = YES;
    [cell.btnImage1.layer setBorderWidth:2.0];
    [cell.btnImage1.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    cell.btnImage2.layer.cornerRadius =32;
    cell.btnImage2.clipsToBounds = YES;
    [cell.btnImage2.layer setBorderWidth:2.0];
    [cell.btnImage2.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    cell.btnImage3.layer.cornerRadius =32;
    cell.btnImage3.clipsToBounds = YES;
    [cell.btnImage3.layer setBorderWidth:2.0];
    [cell.btnImage3.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    cell.cellDelegate = delegate;
    
    return cell;
    
}
-(IBAction)groupMemberButtonPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(GroupMemberButtonClick:)])
    {
		[self.cellDelegate GroupMemberButtonClick:self];
	}
    
}
-(IBAction)groupMemberButton1Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(GroupMemberButton1Click:)])
    {
		[self.cellDelegate GroupMemberButton1Click:self];
	}
    
}
-(IBAction)groupMemberButton2Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(GroupMemberButton2Click:)])
    {
		[self.cellDelegate GroupMemberButton2Click:self];
	}
    
}
-(IBAction)groupMemberButton3Pressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(GroupMemberButton3Click:)])
    {
		[self.cellDelegate GroupMemberButton3Click:self];
	}
    
}
@end
