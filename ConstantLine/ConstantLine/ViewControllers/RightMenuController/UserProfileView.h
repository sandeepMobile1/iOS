//
//  UserProfileView.h
//  ConstantLine
//
//  Created by Vinod Shau on 02/05/14.
//
//

#import <UIKit/UIKit.h>

@protocol UserProfileViewDelegate <NSObject>

-(void)userProfileDidClick:(UIButton *)sender;

@end

@interface UserProfileView : UIView{
    
    
}

@property(nonatomic,strong)IBOutlet UIButton *btnProfile;
@property(nonatomic,strong)IBOutlet UIImageView *profileImage;
@property(nonatomic,strong)IBOutlet UILabel *profileName;
@property(nonatomic,strong) id<UserProfileViewDelegate>delegate;

-(IBAction)userProfileButtonDidClick:(UIButton*)sender;
@end
