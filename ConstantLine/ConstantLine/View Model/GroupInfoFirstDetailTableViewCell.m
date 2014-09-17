//
//  GroupInfoFirstDetailTableViewCell.m
//  ConstantLine
//
//  Created by Pramod Sharma on 15/11/13.
//
//

#import "GroupInfoFirstDetailTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupInfoFirstDetailTableViewCell

@synthesize lblGroupName,lblGroupCharge,lblConnectedMember,cellDelegate,lblGroupCode,btnJoin,btnShare;

+(GroupInfoFirstDetailTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
    wired = [[NSBundle mainBundle] loadNibNamed:@"GroupInfoFirstDetailTableViewCell" owner:owner options:nil];
   
    GroupInfoFirstDetailTableViewCell* cell = (GroupInfoFirstDetailTableViewCell*)[wired firstObjectWithClass:[GroupInfoFirstDetailTableViewCell class]];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnJoinPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ButtonJoinClick:)])
    {
		[self.cellDelegate ButtonJoinClick:self];
	}
}
-(IBAction)btnShareGroupPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ButtonShareClick:)])
    {
		[self.cellDelegate ButtonShareClick:self];
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.lblGroupName= nil;
    self.lblGroupCharge= nil;
    self.lblConnectedMember= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
