//
//  GroupHeader.m
//  ConstantLine
//
//  Created by Vinod Shau on 02/05/14.
//
//

#import "GroupHeader.h"

@implementation GroupHeader
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *nib=[[NSBundle mainBundle ] loadNibNamed:@"GroupHeader" owner:self options:nil];
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

-(IBAction)arrowButtonClick:(UIButton *)sender {
    
    if (sender.isSelected)
    {
        [sender setSelected:NO];
    }
    else
    {
        [sender setSelected:YES];
    }
    if ([self.delegate respondsToSelector:@selector(arrowButtonDidClick:)])
    {
        [self.delegate arrowButtonDidClick:sender];
    }
    
}
-(IBAction)groupButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(groupButtonDidClick:)])
    {
        [self.delegate groupButtonDidClick:sender];
    }

}
@end
