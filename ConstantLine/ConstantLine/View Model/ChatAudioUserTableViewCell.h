//
//  ChatAudioUserTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@class  ChatAudioUserTableViewCell;

@protocol ChatAudioUserTableViewCellDelegate <NSObject>

@optional

-(void) ChatAudioUserButtonClick:(ChatAudioUserTableViewCell*)cellValue;
-(void) ChatAudioUserProfileClick:(ChatAudioUserTableViewCell*)cellValue;
-(void) ChatAudioUserSliderMovedClick:(ChatAudioUserTableViewCell*)cellValue;

@end
@interface ChatAudioUserTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;
@property(nonatomic,strong)IBOutlet UISlider *audioSlider;
@property(nonatomic,strong)IBOutlet UILabel *lblDuration;

@property (nonatomic, unsafe_unretained) id<ChatAudioUserTableViewCellDelegate> cellDelegate;

+(ChatAudioUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;
-(IBAction)sliderMoved:(id)sender;

@end


