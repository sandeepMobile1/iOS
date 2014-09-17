//
//  GroupInfoUserTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GroupInfoUserTableViewCell;

@protocol GroupInfoUserTableViewCellDelegate <NSObject>

@optional

-(void)ShareButtonClick:(GroupInfoUserTableViewCell*)cellValue;
-(void)ClearButtonClick:(GroupInfoUserTableViewCell*)cellValue;
-(void)QuitButtonClick:(GroupInfoUserTableViewCell*)cellValue;
-(void)UnsubscribedButtonClick:(GroupInfoUserTableViewCell*)cellValue;

-(void)ratingButonClick1:(GroupInfoUserTableViewCell*)cellValue;
-(void)ratingButonClick2:(GroupInfoUserTableViewCell*)cellValue;
-(void)ratingButonClick3:(GroupInfoUserTableViewCell*)cellValue;
-(void)ratingButonClick4:(GroupInfoUserTableViewCell*)cellValue;
-(void)ratingButonClick5:(GroupInfoUserTableViewCell*)cellValue;

-(void)ownerRatingButonClick1:(GroupInfoUserTableViewCell*)cellValue;
-(void)ownerRatingButonClick2:(GroupInfoUserTableViewCell*)cellValue;
-(void)ownerRatingButonClick3:(GroupInfoUserTableViewCell*)cellValue;
-(void)ownerRatingButonClick4:(GroupInfoUserTableViewCell*)cellValue;
-(void)ownerRatingButonClick5:(GroupInfoUserTableViewCell*)cellValue;


@end

@interface GroupInfoUserTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *btnShare;
@property(nonatomic,strong)IBOutlet UIButton *btnClear;
@property(nonatomic,strong)IBOutlet UIButton *btnQuit;
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

@property (nonatomic, unsafe_unretained) id<GroupInfoUserTableViewCellDelegate> cellDelegate;

+(GroupInfoUserTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnSharePressed:(id)sender;
-(IBAction)btnClearPressed:(id)sender;
-(IBAction)btnQuitPressed:(id)sender;
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




