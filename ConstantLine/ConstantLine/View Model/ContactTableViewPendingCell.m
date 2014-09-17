//
//  ContactTableViewPendingCell.m
//  ConstantLine
//
//  Created by Pramod Sharma on 09/12/13.
//
//

#import "ContactTableViewPendingCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContactTableViewPendingCell

@synthesize imgView,lblName,cellDelegate,imgArrow,btnAddFriend,btnRejectFriend,txtView;


+(ContactTableViewPendingCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
    
    wired = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewPendingCell" owner:owner options:nil];
    
    ContactTableViewPendingCell* cell = (ContactTableViewPendingCell*)[wired firstObjectWithClass:[ContactTableViewPendingCell class]];
    
    cell.imgView.layer.cornerRadius =5;
    cell.imgView.clipsToBounds = YES;
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}

-(IBAction) buttonAddFriend:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonAddFriend:)])
    {
		[self.cellDelegate buttonAddFriend:self];
	}
}
-(IBAction) buttonRejectFriend:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonRejectFriend:)])
    {
		[self.cellDelegate buttonRejectFriend:self];
	}
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
