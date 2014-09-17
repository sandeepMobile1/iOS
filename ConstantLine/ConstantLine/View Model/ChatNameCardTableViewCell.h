//
//  ChatNameCardTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@class  ChatNameCardTableViewCell;

@protocol ChatNameCardTableViewCellDelegate <NSObject>

@optional

-(void) ChatNameCardButtonClick:(ChatNameCardTableViewCell*)cellValue;
-(void) ChatNameCardProfileClick:(ChatNameCardTableViewCell*)cellValue;

@end
@interface ChatNameCardTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblNameCardName,*lblMessage;
@property(nonatomic,strong)IBOutlet UIImageView *imgNameCard;
@property (nonatomic, unsafe_unretained) id<ChatNameCardTableViewCellDelegate> cellDelegate;

+(ChatNameCardTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;

@end

