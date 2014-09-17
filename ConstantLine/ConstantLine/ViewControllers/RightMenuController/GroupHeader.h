//
//  GroupHeader.h
//  ConstantLine
//
//  Created by Vinod Shau on 02/05/14.
//
//

#import <UIKit/UIKit.h>

@protocol GroupHeaderDelegate <NSObject>

-(void)arrowButtonDidClick:(UIButton *)sender;

-(void)groupButtonDidClick:(UIButton *)sender;


@end


@interface GroupHeader : UIView{
    
    
}

@property(nonatomic ,strong)id<GroupHeaderDelegate>delegate;

-(IBAction)arrowButtonClick:(UIButton *)sender;
-(IBAction)groupButtonClick:(UIButton *)sender;

@end
