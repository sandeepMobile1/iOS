//
//  ChatListTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatListTableViewCell

@synthesize lblName,lblFee,lblMessage,lblDate,imgView,imgStatus,cellDelegate,btnAccept,btnReject,btnShare;


+(ChatListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatListTableViewCell" owner:owner options:nil];
   
    ChatListTableViewCell* cell = (ChatListTableViewCell*)[wired firstObjectWithClass:[ChatListTableViewCell class]];
    
   // cell.lblName.lineBreakMode=NSLineBreakByWordWrapping;
    
    cell.imgView.layer.cornerRadius =5;
    cell.imgView.clipsToBounds = YES;
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnAcceptPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonAcceptClick:)]) 
    {
		[self.cellDelegate buttonAcceptClick:self];
	}
}
-(IBAction)btnRejectPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonRejectClick:)]) 
    {
		[self.cellDelegate buttonRejectClick:self];
	}
}
-(IBAction)btnSharePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonShareClick:)])
    {
		[self.cellDelegate buttonShareClick:self];
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    self.lblName= nil;
    self.lblFee= nil;
    self.lblMessage= nil;
    self.lblDate= nil;
    //self.imgView= nil;
    self.imgStatus= nil;
    self.cellDelegate= nil;
   
    [super dealloc];
	
}


@end
