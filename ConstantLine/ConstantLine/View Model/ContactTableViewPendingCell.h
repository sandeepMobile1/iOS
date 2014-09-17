//
//  ContactTableViewPendingCell.h
//  ConstantLine
//
//  Created by Pramod Sharma on 09/12/13.
//
//

#import <UIKit/UIKit.h>

@class  ContactTableViewPendingCell;

@protocol ContactTableViewPendingCellDelegate <NSObject>

@optional

-(void) buttonAddFriend:(ContactTableViewPendingCell*)cellValue;
-(void) buttonRejectFriend:(ContactTableViewPendingCell*)cellValue;


@end


@interface ContactTableViewPendingCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong)IBOutlet UIImageView *imgArrow;

@property(nonatomic,strong)IBOutlet UILabel *lblName;
@property(nonatomic,strong)IBOutlet UITextView *txtView;


@property(nonatomic,strong)IBOutlet UIButton *btnAddFriend;
@property(nonatomic,strong)IBOutlet UIButton *btnRejectFriend;


@property (nonatomic, unsafe_unretained) id<ContactTableViewPendingCellDelegate> cellDelegate;

+(ContactTableViewPendingCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;

-(IBAction) buttonAddFriend:(id)sender;
-(IBAction) buttonRejectFriend:(id)sender;

@end

