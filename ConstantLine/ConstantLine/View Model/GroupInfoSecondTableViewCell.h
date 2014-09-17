//
//  GroupInfoSecondTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GroupInfoSecondTableViewCell;

@protocol GroupInfoSecondTableViewCellDelegate <NSObject>

@optional

-(void)ManageButtonClick:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ShareButtonClick:(GroupInfoSecondTableViewCell*)cellValue;
-(void)KickButtonClick:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ClearButtonClick:(GroupInfoSecondTableViewCell*)cellValue;
-(void)UnsubscribedPrivilageButtonClick:(GroupInfoSecondTableViewCell*)cellValue;

-(void)ratingButonClick1:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ratingButonClick2:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ratingButonClick3:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ratingButonClick4:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ratingButonClick5:(GroupInfoSecondTableViewCell*)cellValue;

-(void)ownerRatingButonClick1:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ownerRatingButonClick2:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ownerRatingButonClick3:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ownerRatingButonClick4:(GroupInfoSecondTableViewCell*)cellValue;
-(void)ownerRatingButonClick5:(GroupInfoSecondTableViewCell*)cellValue;


@end
@interface GroupInfoSecondTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *btnManage;
@property(nonatomic,strong)IBOutlet UIButton *btnShare;
@property(nonatomic,strong)IBOutlet UIButton *btnClear;
@property(nonatomic,strong)IBOutlet UIButton *btnKick;
@property(nonatomic,strong)IBOutlet UIButton *btnUnSubscribe;

@property(nonatomic,strong)IBOutlet UIButton *btnRating1;
@property(nonatomic,strong)IBOutlet UIButton *btnRating2;
@property(nonatomic,strong)IBOutlet UIButton *btnRating3;
@property(nonatomic,strong)IBOutlet UIButton *btnRating4;
@property(nonatomic,strong)IBOutlet UIButton *btnRating5;

@property(nonatomic,strong)IBOutlet UIButton *btnOwnerRating1;
@property(nonatomic,strong)IBOutlet UIButton *btnOwnerRating2;
@property(nonatomic,strong)IBOutlet UIButton *btnOwnerRating3;
@property(nonatomic,strong)IBOutlet UIButton *btnOwnerRating4;
@property(nonatomic,strong)IBOutlet UIButton *btnOwnerRating5;

@property (nonatomic, unsafe_unretained) id<GroupInfoSecondTableViewCellDelegate> cellDelegate;

+(GroupInfoSecondTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnManagePressed:(id)sender;
-(IBAction)btnSharePressed:(id)sender;
-(IBAction)btnKickPressed:(id)sender;
-(IBAction)btnClearPressed:(id)sender;
-(IBAction)btnUnsubcribedPressed:(id)sender;

-(IBAction)btnRating1Pressed:(id)sender;
-(IBAction)btnRating2Pressed:(id)sender;
-(IBAction)btnRating3Pressed:(id)sender;
-(IBAction)btnRating4Pressed:(id)sender;
-(IBAction)btnRating5Pressed:(id)sender;

-(IBAction)btnOwnerRating1Pressed:(id)sender;
-(IBAction)btnOwnerRating2Pressed:(id)sender;
-(IBAction)btnOwnerRating3Pressed:(id)sender;
-(IBAction)btnOwnerRating4Pressed:(id)sender;
-(IBAction)btnOwnerRating5Pressed:(id)sender;

@end



