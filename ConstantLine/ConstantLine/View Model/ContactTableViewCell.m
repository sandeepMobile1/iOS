//
//  ContactTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContactTableViewCell

@synthesize imgView,lblName,cellDelegate,imgArrow,btnAddFriend,btnRejectFriend;


+(ContactTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
        wired = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:owner options:nil];

       ContactTableViewCell* cell = (ContactTableViewCell*)[wired firstObjectWithClass:[ContactTableViewCell class]];
    
    cell.imgView.layer.cornerRadius =25;
     cell.imgView.layer.borderWidth=2.0;
     cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.imgView.clipsToBounds = YES;
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
    self.imgArrow= nil;
    self.imgView= nil;
    self.btnAddFriend= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
