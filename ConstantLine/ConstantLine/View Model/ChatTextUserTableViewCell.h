//
//  ChatTextUserTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@class  ChatTextUserTableViewCell;

@protocol ChatTextUserTableViewCellDelegate <NSObject>

@optional

-(void) ChatTextUserButtonClick:(ChatTextUserTableViewCell*)cellValue;
-(void) ChatTextUserProfileClick:(ChatTextUserTableViewCell*)cellValue;

@end

@interface ChatTextUserTableViewCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UITextView *lblMessage;
@property(nonatomic,strong)IBOutlet UIImageView *imgBackView;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;


@property (nonatomic, unsafe_unretained) id<ChatTextUserTableViewCellDelegate> cellDelegate;

+(ChatTextUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;

@end

