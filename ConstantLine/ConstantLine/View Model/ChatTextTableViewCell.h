//
//  ChatTextTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ChatTextTableViewCell;

@protocol ChatTextTableViewCellDelegate <NSObject>

@optional

-(void)chatTextButtonClick:(ChatTextTableViewCell*)cellValue;
-(void)chatTextProfileClick:(ChatTextTableViewCell*)cellValue;


@end
@interface ChatTextTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgBackView;

@property(nonatomic,strong)IBOutlet UIButton *btnChatMessage;
@property(nonatomic,strong)IBOutlet UIButton *btnProfileImage;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UITextView *lblMessage;

@property (nonatomic, unsafe_unretained) id<ChatTextTableViewCellDelegate> cellDelegate;

+(ChatTextTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnChatMessagePressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;

@end

