//
//  AddMembersTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AddMembersTableViewCell;

@protocol AddMembersTableViewCellDelegate <NSObject>

@optional

-(void) buttonSelectFriend:(AddMembersTableViewCell*)cellValue;


@end


@interface AddMembersTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UIButton *btnSelectFriend;


@property (nonatomic, unsafe_unretained) id<AddMembersTableViewCellDelegate> cellDelegate;

+(AddMembersTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;
-(IBAction) buttonSelectFriend:(id)sender;

@end
