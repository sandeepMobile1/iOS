//
//  ChatAudioTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@class  ChatAudioTableViewCell;

@protocol ChatAudioTableViewCellDelegate <NSObject>

@optional

-(void) ChatAudioButtonClick:(ChatAudioTableViewCell*)cellValue;
-(void) ChatAudioProfileClick:(ChatAudioTableViewCell*)cellValue;
-(void) ChatAudioSliderMovedClick:(ChatAudioTableViewCell*)cellValue;


@end
@interface ChatAudioTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;
@property(nonatomic,strong)IBOutlet UILabel *lblDuration;

@property(nonatomic,strong)IBOutlet UISlider *audioSlider;

@property (nonatomic, unsafe_unretained) id<ChatAudioTableViewCellDelegate> cellDelegate;

+(ChatAudioTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;
-(IBAction)sliderMoved:(id)sender;

@end


