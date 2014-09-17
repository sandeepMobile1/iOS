//
//  GroupCell.m
//  ConstantLine
//
//  Created by Vinod Shau on 02/05/14.
//
//

#import "GroupCell.h"

@implementation GroupCell
@synthesize delegate,lblNotification,imgNotification;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)buttonClick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(buttonDidClick:)])
    {
        [self.delegate buttonDidClick:sender];
    }
}

@end
