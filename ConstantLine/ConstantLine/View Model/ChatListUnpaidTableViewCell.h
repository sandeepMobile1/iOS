//
//  ChatListUnpaidTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ChatListUnpaidTableViewCell;

@protocol ChatListUnpaidTableViewCellDelegate <NSObject>

@optional

-(void) buttonUnpaidAcceptClick:(ChatListUnpaidTableViewCell*)cellValue;
-(void) buttonUnpaidRejectClick:(ChatListUnpaidTableViewCell*)cellValue;


@end
@interface ChatListUnpaidTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgStatus;
@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblMsgCount;
@property(nonatomic,strong)IBOutlet UIImageView *imgChatType;
@property(nonatomic,strong)IBOutlet UIImageView *imgBackView;
@property(nonatomic,strong)IBOutlet UIImageView *imgSep;

@property(nonatomic,strong)IBOutlet UIButton *btnAccept;
@property(nonatomic,strong)IBOutlet UIButton *btnReject;

@property (nonatomic, unsafe_unretained) id<ChatListUnpaidTableViewCellDelegate> cellDelegate;


+(ChatListUnpaidTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnAcceptPressed:(id)sender;
-(IBAction)btnRejectPressed:(id)sender;

@end
