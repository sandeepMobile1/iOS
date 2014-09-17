//
//  GroupCell.h
//  ConstantLine
//
//  Created by Vinod Shau on 02/05/14.
//
//

#import <UIKit/UIKit.h>

@protocol GroupCellDelegate <NSObject>
-(void)buttonDidClick:(UIButton *)sender;


@end


@interface GroupCell : UITableViewCell{
    
    
}
@property(nonatomic,strong)IBOutlet UILabel *lblNotification;
@property(nonatomic,strong)IBOutlet UIImageView *imgNotification;

@property(nonatomic,strong)id<GroupCellDelegate>delegate;
-(IBAction)buttonClick:(UIButton *)sender;

@end
