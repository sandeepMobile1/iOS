//
//  ChatAudioUserTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatAudioUserTableViewCell.h"

#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatAudioUserTableViewCell

@synthesize imgView,lblName,btnChatMessage,cellDelegate,lblDate,lblMessage,btnProfileImage,audioSlider,lblDuration;


+(ChatAudioUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatAudioUserTableViewCell" owner:owner options:nil];

    
    ChatAudioUserTableViewCell* cell = (ChatAudioUserTableViewCell*)[wired firstObjectWithClass:[ChatAudioUserTableViewCell class]];
    
    cell.imgView.layer.cornerRadius =27;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderWidth=2.0;
    cell.imgView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    cell.cellDelegate = delegate;
    
   /* UIImage* sliderCenterImage = [UIImage imageNamed:@"slider_circle"];
   
    [cell.audioSlider setThumbImage:sliderCenterImage forState:UIControlStateNormal];
   
    UIImage *leftStretch = [[UIImage imageNamed:@"slider_loader_orange"]
                             stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [cell.audioSlider setMinimumTrackImage:leftStretch forState:UIControlStateNormal];
  
    UIImage *rightStretch = [[UIImage imageNamed:@"slider_loader"]
                             stretchableImageWithLeftCapWidth:1.0 topCapHeight:0.0];
    [cell.audioSlider setMaximumTrackImage:rightStretch forState:UIControlStateNormal];*/
    
    
    UIImage *minImage = [[UIImage imageNamed:@"slider_loader_orange"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    UIImage *maxImage = [UIImage imageNamed:@"slider_loader"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider_circle"];
  
    cell.audioSlider.value=0.0;

    [cell.audioSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [cell.audioSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [cell.audioSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [cell.audioSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];

    
    return cell;
    
}

-(IBAction)btnChatMessagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatAudioUserButtonClick:)]) 
    {
		[self.cellDelegate ChatAudioUserButtonClick:self];
	}
}
-(IBAction)btnProfileImagePressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatAudioUserProfileClick:)]) 
    {
		[self.cellDelegate ChatAudioUserProfileClick:self];
	}
}
-(IBAction)sliderMoved:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ChatAudioSliderMovedClick:)])
    {
		[self.cellDelegate ChatAudioUserSliderMovedClick:self];
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
