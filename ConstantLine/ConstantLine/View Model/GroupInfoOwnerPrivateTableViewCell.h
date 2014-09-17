//
//  GroupInfoOwnerPrivateTableViewCell.h
//  ConstantLine
//
//  Created by Pramod Sharma on 22/11/13.
//
//

#import <UIKit/UIKit.h>
@class  GroupInfoOwnerPrivateTableViewCell;

@protocol GroupInfoOwnerPrivateTableViewCellDelegate <NSObject>

@optional

-(void)ShareGroupInfoOwnerPrivateButtonClick:(GroupInfoOwnerPrivateTableViewCell*)cellValue;

-(void)ClearOwnerPrivateButtonClick:(GroupInfoOwnerPrivateTableViewCell*)cellValue;
-(void)KickOutPrivateButtonClick:(GroupInfoOwnerPrivateTableViewCell*)cellValue;

@end


@interface GroupInfoOwnerPrivateTableViewCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UIButton *btnClear;
@property(nonatomic,strong)IBOutlet UIButton *btnKickOut;
@property(nonatomic,strong)IBOutlet UIButton *btnShare;

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblMemberCount;


@property (nonatomic, unsafe_unretained) id<GroupInfoOwnerPrivateTableViewCellDelegate> cellDelegate;

+(GroupInfoOwnerPrivateTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnClearPressed:(id)sender;
-(IBAction)btnKickOutPressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;


@end


