//
//  GroupInfoFirstDetailTableViewCell.h
//  ConstantLine
//
//  Created by Pramod Sharma on 15/11/13.
//
//

@class  GroupInfoFirstDetailTableViewCell;

@protocol GroupInfoFirstDetailTableViewCellDelegate <NSObject>

@optional

-(void)ButtonJoinClick:(GroupInfoFirstDetailTableViewCell*)cellValue;
-(void)ButtonShareClick:(GroupInfoFirstDetailTableViewCell*)cellValue;

@end
@interface GroupInfoFirstDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel  *lblGroupName;
@property(nonatomic,strong)IBOutlet UILabel  *lblGroupCharge;
@property(nonatomic,strong)IBOutlet UILabel  *lblConnectedMember;
@property(nonatomic,strong)IBOutlet UILabel  *lblGroupCode;
@property(nonatomic,strong)IBOutlet UIButton *btnJoin;
@property(nonatomic,strong)IBOutlet UIButton *btnShare;

@property (nonatomic, unsafe_unretained) id<GroupInfoFirstDetailTableViewCellDelegate> cellDelegate;

+(GroupInfoFirstDetailTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnJoinPressed:(id)sender;
-(IBAction)btnShareGroupPressed:(id)sender;

@end



