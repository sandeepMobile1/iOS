//
//  ChatImageUserTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@class  ChatImageUserTableViewCell;

@protocol ChatImageUserTableViewCellDelegate <NSObject>

@optional

-(void) ChatUserImageButtonClick:(ChatImageUserTableViewCell*)cellValue;
-(void) ChatUserImageProfileClick:(ChatImageUserTableViewCell*)cellValue;


@end
@interface ChatImageUserTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIImageView *imgPostImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;

@property (nonatomic, unsafe_unretained) id<ChatImageUserTableViewCellDelegate> cellDelegate;

+(ChatImageUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;

@end
