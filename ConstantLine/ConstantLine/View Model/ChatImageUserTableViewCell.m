//
//  ChatImageUserTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatImageUserTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatImageUserTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblMessage,imgPostImage,btnProfileImage;


+(ChatImageUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{

    NSLog(@"createTextRowWithOwner");
    
    NSArray *wired;
	
           wired = [[NSBundle mainBundle] loadNibNamed:@"ChatImageUserTableViewCell" owner:owner options:nil];
   
    ChatImageUserTableViewCell* cell = (ChatImageUserTableViewCell*)[wired firstObjectWithClass:[ChatImageUserTableViewCell class]];
   
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.cellDelegate = delegate;
    
    NSLog(@"createTextRowWithOwnerEND");

    
    return cell;
    
}

-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatUserImageButtonClick:)]) 
    {
		[self.cellDelegate ChatUserImageButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatUserImageProfileClick:)]) 
    {
		[self.cellDelegate ChatUserImageProfileClick:self];
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
    //self.imgPostImage= nil;
    self.cellDelegate= nil;
    
    [super dealloc];
	
}




@end
