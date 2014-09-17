
//
//  GroupInfoFirstTableViewCellController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GroupInfoFirstTableViewCellController;

@protocol GroupInfoFirstTableViewCellControllerDelegate <NSObject>

@optional

-(void)ButtonClick:(GroupInfoFirstTableViewCellController*)cellValue;

-(void)MoreButtonClick:(GroupInfoFirstTableViewCellController*)cellValue;


@end
@interface GroupInfoFirstTableViewCellController : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel  *lblGroupName;
@property(nonatomic,strong)IBOutlet UILabel  *lblGroupDescription;
@property(nonatomic,strong)IBOutlet UILabel  *lblVoteCount;

@property(nonatomic,strong)IBOutlet UIButton *btnRating1;
@property(nonatomic,strong)IBOutlet UIButton *btnRating2;
@property(nonatomic,strong)IBOutlet UIButton *btnRating3;
@property(nonatomic,strong)IBOutlet UIButton *btnRating4;
@property(nonatomic,strong)IBOutlet UIButton *btnRating5;
@property(nonatomic,strong)IBOutlet UIButton *btnMore;

@property(nonatomic,strong)IBOutlet UIImageView *imgBackCellImage;

@property(nonatomic,strong)IBOutlet UILabel *lblUploadImage;
@property(nonatomic,strong)IBOutlet UILabel *lblTapTo;

@property (nonatomic, unsafe_unretained) id<GroupInfoFirstTableViewCellControllerDelegate> cellDelegate;

+(GroupInfoFirstTableViewCellController*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnPressed:(id)sender;
-(IBAction)btnMorePressed:(id)sender;

@end


