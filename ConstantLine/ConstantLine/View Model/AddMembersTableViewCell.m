//
//  AddMembersTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 9/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AddMembersTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddMembersTableViewCell

@synthesize imgView,lblName,cellDelegate,btnSelectFriend;



+(AddMembersTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;

    wired = [[NSBundle mainBundle] loadNibNamed:@"AddMembersTableViewCell" owner:owner options:nil];
   
    AddMembersTableViewCell* cell = (AddMembersTableViewCell*)[wired firstObjectWithClass:[AddMembersTableViewCell class]];
  
    
    cell.imgView.layer.cornerRadius =25;
    cell.imgView.clipsToBounds = YES;

    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction) buttonSelectFriend:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonSelectFriend:)]) 
    {
		[self.cellDelegate buttonSelectFriend:self];
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.lblName= nil;
    self.imgView= nil;
    self.btnSelectFriend= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
