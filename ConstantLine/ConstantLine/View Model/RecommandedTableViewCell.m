//
//  RecommandedTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RecommandedTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation RecommandedTableViewCell

@synthesize imgView,lblName,cellDelegate,imgArrow,btnAddFriend;

+(RecommandedTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;

    wired = [[NSBundle mainBundle] loadNibNamed:@"RecommandedTableViewCell" owner:owner options:nil];

    RecommandedTableViewCell* cell = (RecommandedTableViewCell*)[wired firstObjectWithClass:[RecommandedTableViewCell class]];
    
    cell.imgView.layer.cornerRadius =25;
    cell.imgView.clipsToBounds = YES;

    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
   
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
