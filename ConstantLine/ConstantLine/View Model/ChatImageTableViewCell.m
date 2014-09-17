//
//  ChatImageTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatImageTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatImageTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblMessage,imgPostImage,btnProfileImage;


+(ChatImageTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
    NSArray *wired;
	
   

        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatImageTableViewCell" owner:owner options:nil];
        ChatImageTableViewCell* cell = (ChatImageTableViewCell*)[wired firstObjectWithClass:[ChatImageTableViewCell class]];
       
    cell.cellDelegate = delegate;
    
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    return cell;
    
}
-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatImageButtonClick:)]) 
    {
		[self.cellDelegate ChatImageButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatImageProfileClick:)]) 
    {
		[self.cellDelegate ChatImageProfileClick:self];
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    
    self.lblName= nil;
    self.imgPostImage= nil;
    self.lblMessage= nil;
    self.lblDate= nil;
    //self.imgView= nil;
    self.btnChatMessage= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
