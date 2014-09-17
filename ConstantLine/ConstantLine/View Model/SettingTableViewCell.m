//
//  SettingTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation SettingTableViewCell

@synthesize imgView,lblName,lblRevenue,cellDelegate,imgArrow,notificationSwitch;



+(SettingTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
            wired = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:owner options:nil];
       
    SettingTableViewCell* cell = (SettingTableViewCell*)[wired firstObjectWithClass:[SettingTableViewCell class]];
   
    //cell.imgView.layer.cornerRadius =5;

    //cell.imgView.clipsToBounds = YES;
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.lblName= nil;
    self.lblRevenue= nil;
    self.imgArrow= nil;
    self.imgView= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
