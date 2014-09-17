//
//  GroupInfoUserPrivateTableViewCell.h
//  ConstantLine
//
//  Created by Pramod Sharma on 22/11/13.
//
//

#import <UIKit/UIKit.h>
@class  GroupInfoUserPrivateTableViewCell;

@protocol GroupInfoUserPrivateTableViewCellDelegate <NSObject>

@optional

-(void)ShareGroupInfoUserPrivateButtonClick:(GroupInfoUserPrivateTableViewCell*)cellValue;

-(void)ClearUserPrivateButtonClick:(GroupInfoUserPrivateTableViewCell*)cellValue;
-(void)QuitUserPrivateButtonClick:(GroupInfoUserPrivateTableViewCell*)cellValue;

@end

@interface GroupInfoUserPrivateTableViewCell :UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *btnClear;
@property(nonatomic,strong)IBOutlet UIButton *btnQuit;
@property(nonatomic,strong)IBOutlet UIButton *btnShare;

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblMemberCount;


@property (nonatomic, unsafe_unretained) id<GroupInfoUserPrivateTableViewCellDelegate> cellDelegate;

+(GroupInfoUserPrivateTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnClearPressed:(id)sender;
-(IBAction)btnQuitPressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;


@end



