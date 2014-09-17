//
//  ContactTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@class  ContactTableViewCell;

@protocol ContactTableViewCellDelegate <NSObject>

@optional

@end


@interface ContactTableViewCell : SWTableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgArrow;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UIButton *btnAddFriend;
@property(nonatomic,strong)IBOutlet UIButton *btnRejectFriend;


@property (nonatomic, unsafe_unretained) id<ContactTableViewCellDelegate> cellDelegate;

+(ContactTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;


@end
