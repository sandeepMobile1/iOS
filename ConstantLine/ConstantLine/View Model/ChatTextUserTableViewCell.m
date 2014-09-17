//
//  ChatTextUserTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatTextUserTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatTextUserTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblMessage,btnProfileImage,imgBackView;

+(ChatTextUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatTextUserTableViewCell" owner:owner options:nil];
           
    ChatTextUserTableViewCell* cell = (ChatTextUserTableViewCell*)[wired firstObjectWithClass:[ChatTextUserTableViewCell class]];
   
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    [cell.lblMessage setEditable:FALSE];
    [cell.lblMessage setUserInteractionEnabled:TRUE];
    //[cell.lblMessage setSelectable:TRUE];
    [cell.lblMessage setScrollEnabled:FALSE];
    [cell.lblMessage setScrollsToTop:FALSE];
    
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_bg_white.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    [cell.imgBackView setImage:entryBackground];

    cell.cellDelegate = delegate;
    
    return cell;
    
}
-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatTextUserButtonClick:)]) 
    {
		[self.cellDelegate ChatTextUserButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatTextUserProfileClick:)]) 
    {
		[self.cellDelegate ChatTextUserProfileClick:self];
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
    //self.imgView= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
