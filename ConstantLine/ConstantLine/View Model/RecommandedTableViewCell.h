//
//  RecommandedTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RecommandedTableViewCell;

@protocol RecommandedTableViewCellDelegate <NSObject>

@optional

-(void) buttonAddFriend:(RecommandedTableViewCell*)cellValue;


@end

@interface RecommandedTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgArrow;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UIButton *btnAddFriend;


@property (nonatomic, unsafe_unretained) id<RecommandedTableViewCellDelegate> cellDelegate;

+(RecommandedTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction) buttonAddFriend:(id)sender;

@end
