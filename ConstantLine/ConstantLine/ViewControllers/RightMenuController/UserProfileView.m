//
//  UserProfileView.m
//  ConstantLine
//
//  Created by Vinod Shau on 02/05/14.
//
//

#import "UserProfileView.h"

@implementation UserProfileView
@synthesize profileImage,profileName;
@synthesize delegate;
@synthesize btnProfile;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        NSArray *nib=[[NSBundle mainBundle ] loadNibNamed:@"UserProfileView" owner:self options:nil];
        self = [nib objectAtIndex:0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)userProfileButtonDidClick:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(userProfileDidClick:)])
    {
        [self.delegate userProfileDidClick:sender];
    }
}

@end
