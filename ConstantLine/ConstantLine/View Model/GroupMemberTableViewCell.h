//
//  GroupMemberTableViewCell.h
//  ConstantLine
//
//  Created by Shweta Sharma on 30/06/14.
//
//

#import <UIKit/UIKit.h>

@class  GroupMemberTableViewCell;

@protocol GroupMemberTableViewCellDelegate <NSObject>

@optional

-(void)GroupMemberButtonClick:(GroupMemberTableViewCell*)cellValue;
-(void)GroupMemberButton1Click:(GroupMemberTableViewCell*)cellValue;
-(void)GroupMemberButton2Click:(GroupMemberTableViewCell*)cellValue;
-(void)GroupMemberButton3Click:(GroupMemberTableViewCell*)cellValue;

@end

@interface GroupMemberTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *btnImage;
@property(nonatomic,strong)IBOutlet UIButton *btnImage1;
@property(nonatomic,strong)IBOutlet UIButton *btnImage2;
@property(nonatomic,strong)IBOutlet UIButton *btnImage3;

@property (nonatomic, unsafe_unretained) id<GroupMemberTableViewCellDelegate> cellDelegate;

+(GroupMemberTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)groupMemberButtonPressed:(id)sender;
-(IBAction)groupMemberButton1Pressed:(id)sender;
-(IBAction)groupMemberButton2Pressed:(id)sender;
-(IBAction)groupMemberButton3Pressed:(id)sender;


@end
