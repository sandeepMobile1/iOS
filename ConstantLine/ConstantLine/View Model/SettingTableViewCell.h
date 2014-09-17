//
//  SettingTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SettingTableViewCell;

@protocol SettingTableViewCellDelegate <NSObject>

@optional

-(void) buttonClick:(SettingTableViewCell*)cellValue;


@end
@interface SettingTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgArrow;
@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UILabel *lblRevenue;
@property(nonatomic,strong)IBOutlet UISwitch *notificationSwitch;

@property (nonatomic, unsafe_unretained) id<SettingTableViewCellDelegate> cellDelegate;

+(SettingTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

@end

