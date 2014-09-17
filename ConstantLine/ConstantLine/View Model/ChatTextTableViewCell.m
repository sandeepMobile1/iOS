//
//  ChatTextTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatTextTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatTextTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblMessage,btnProfileImage,imgBackView;

+(ChatTextTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatTextTableViewCell" owner:owner options:nil];
       
    ChatTextTableViewCell* cell = (ChatTextTableViewCell*)[wired firstObjectWithClass:[ChatTextTableViewCell class]];
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    [cell.lblMessage setEditable:FALSE];
    [cell.lblMessage setUserInteractionEnabled:TRUE];
    [cell.lblMessage setScrollEnabled:FALSE];
    [cell.lblMessage setScrollsToTop:FALSE];
    
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_bg_yellow.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    [cell.imgBackView setImage:entryBackground];
    
    cell.cellDelegate = delegate;
    
    return cell;
    
}
-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(chatTextButtonClick:)]) 
    {
		[self.cellDelegate chatTextButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(chatTextProfileClick:)]) 
    {
		[self.cellDelegate chatTextProfileClick:self];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    self.lblName= nil;
    self.btnChatMessage= nil;
    self.lblMessage= nil;
    self.lblDate= nil;
   // self.imgView= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
