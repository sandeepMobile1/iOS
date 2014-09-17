//
//  ChatListTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ChatListTableViewCell;

@protocol ChatListTableViewCellDelegate <NSObject>

@optional

-(void) buttonAcceptClick:(ChatListTableViewCell*)cellValue;
-(void) buttonRejectClick:(ChatListTableViewCell*)cellValue;
-(void) buttonShareClick:(ChatListTableViewCell*)cellValue;


@end

@interface ChatListTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgStatus;
@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblFee;
@property(nonatomic,strong)IBOutlet UILabel *lblMessage;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;

@property(nonatomic,strong)IBOutlet UIButton *btnAccept;
@property(nonatomic,strong)IBOutlet UIButton *btnReject;
@property(nonatomic,strong)IBOutlet UIButton *btnShare;

@property (nonatomic, unsafe_unretained) id<ChatListTableViewCellDelegate> cellDelegate;


+(ChatListTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnAcceptPressed:(id)sender;
-(IBAction)btnRejectPressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;


@end
