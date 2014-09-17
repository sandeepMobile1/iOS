//
//  ChatListUnpaidTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatListUnpaidTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatListUnpaidTableViewCell

@synthesize lblName,lblMessage,lblDate,imgSep,imgView,imgStatus,imgBackView,cellDelegate,btnReject,btnAccept,lblMsgCount,imgChatType;


+(ChatListUnpaidTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
   
    wired = [[NSBundle mainBundle] loadNibNamed:@"ChatListUnpaidTableViewCell" owner:owner options:nil];
   
    ChatListUnpaidTableViewCell* cell = (ChatListUnpaidTableViewCell*)[wired firstObjectWithClass:[ChatListUnpaidTableViewCell class]];
    
    //cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnAcceptPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonUnpaidAcceptClick:)]) 
    {
		[self.cellDelegate buttonUnpaidAcceptClick:self];
	}
}
-(IBAction)btnRejectPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonUnpaidRejectClick:)]) 
    {
		[self.cellDelegate buttonUnpaidRejectClick:self];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.lblName= nil;
    self.lblMessage= nil;
    self.lblDate= nil;
    //self.imgView= nil;
   // self.imgStatus= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}



@end
