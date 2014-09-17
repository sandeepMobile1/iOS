//
//  ChatRequestTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatRequestTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatRequestTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblMessage,btnAccept
,btnReject,btnProfileImage;

+(ChatRequestTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatRequestTableViewCell" owner:owner options:nil];
    
    
    ChatRequestTableViewCell* cell = (ChatRequestTableViewCell*)[wired firstObjectWithClass:[ChatRequestTableViewCell class]];
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatRquestButtonClick:)]) 
    {
		[self.cellDelegate ChatRquestButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatRequestProfileClick:)]) 
    {
		[self.cellDelegate ChatRequestProfileClick:self];
	}
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
-(IBAction)btnRequestPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(buttonRequestClick:)])
    {
		[self.cellDelegate buttonRequestClick:self];
	}
}
@end
