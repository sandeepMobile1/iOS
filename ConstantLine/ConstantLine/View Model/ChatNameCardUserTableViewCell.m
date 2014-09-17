//
//  ChatNameCardUserTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatNameCardUserTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatNameCardUserTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblNameCardName,imgNameCard,lblMessage,btnProfileImage;



+(ChatNameCardUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatNameCardUserTableViewCell" owner:owner options:nil];
   
    
    ChatNameCardUserTableViewCell* cell = (ChatNameCardUserTableViewCell*)[wired firstObjectWithClass:[ChatNameCardUserTableViewCell class]];
    
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.cellDelegate = delegate;
    
    
    return cell;
    
}
-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatNameCardUserButtonClick:)]) 
    {
		[self.cellDelegate ChatNameCardUserButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatNameCardUserProfileClick:)]) 
    {
		[self.cellDelegate ChatNameCardUserProfileClick:self];
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
   // self.imgNameCard= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}


@end
