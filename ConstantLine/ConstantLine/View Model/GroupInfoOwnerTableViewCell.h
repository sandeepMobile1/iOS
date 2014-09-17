//
//  GroupInfoOwnerTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GroupInfoOwnerTableViewCell;

@protocol GroupInfoOwnerTableViewCellDelegate <NSObject>

@optional

-(void)ManageButtonClick:(GroupInfoOwnerTableViewCell*)cellValue;
-(void)ShareButtonClick:(GroupInfoOwnerTableViewCell*)cellValue;
-(void)KickButtonClick:(GroupInfoOwnerTableViewCell*)cellValue;
-(void)ClearButtonClick:(GroupInfoOwnerTableViewCell*)cellValue;
-(void)btnPublicClick:(GroupInfoOwnerTableViewCell *)sender;
-(void)btnPrivateClick:(GroupInfoOwnerTableViewCell *)sender;

@end
@interface GroupInfoOwnerTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *btnManage;
@property(nonatomic,strong)IBOutlet UIButton *btnShare;
@property(nonatomic,strong)IBOutlet UIButton *btnClear;
@property(nonatomic,strong)IBOutlet UIButton *btnKick;
@property(nonatomic,strong)IBOutlet UIButton *btnPublic;
@property(nonatomic,strong)IBOutlet UIButton *btnPrivate;


@property (nonatomic, unsafe_unretained) id<GroupInfoOwnerTableViewCellDelegate> cellDelegate;

+(GroupInfoOwnerTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnManagePressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;
-(IBAction)btnKickPressed:(id)sender;
-(IBAction)btnClearPressed:(id)sender;
-(IBAction)btnPublicPressed:(UIButton *)sender;
-(IBAction)btnPrivatePressed:(UIButton *)sender;


@end




