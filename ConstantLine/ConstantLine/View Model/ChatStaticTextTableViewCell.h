//
//  ChatStaticTextTableViewCell.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ChatStaticTextTableViewCell;

@protocol ChatStaticTextTableViewCellDelegate <NSObject>

@optional

-(void)ButtonClick:(ChatStaticTextTableViewCell*)cellValue;


@end


@interface ChatStaticTextTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *lblMessage;
@property (nonatomic, unsafe_unretained) id<ChatStaticTextTableViewCellDelegate> cellDelegate;

+(ChatStaticTextTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction)btnPressed:(id)sender;

@end
