//
//  ChatNameCardUserTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import "EGOImageView.h"

@class  ChatNameCardUserTableViewCell;

@protocol ChatNameCardUserTableViewCellDelegate <NSObject>

@optional

-(void) ChatNameCardUserButtonClick:(ChatNameCardUserTableViewCell*)cellValue;
-(void) ChatNameCardUserProfileClick:(ChatNameCardUserTableViewCell*)cellValue;

@end
@interface ChatNameCardUserTableViewCell :UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblNameCardName;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;

@property(nonatomic,strong)IBOutlet UIImageView *imgNameCard;


@property (nonatomic, unsafe_unretained) id<ChatNameCardUserTableViewCellDelegate> cellDelegate;

+(ChatNameCardUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;

@end

