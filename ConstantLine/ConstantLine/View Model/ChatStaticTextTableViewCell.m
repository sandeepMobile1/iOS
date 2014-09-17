//
//  ChatStaticTextTableViewCell.m
//  ConstantLine
//
//  Created by octal i-phone2 on 10/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatStaticTextTableViewCell.h"
#import "CAVNSArrayTypeCategory.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatStaticTextTableViewCell

@synthesize lblMessage,cellDelegate;

+(ChatStaticTextTableViewCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate
{
	
    NSArray *wired;
	
    
        wired = [[NSBundle mainBundle] loadNibNamed:@"ChatStaticTextTableViewCell" owner:owner options:nil];
    
    ChatStaticTextTableViewCell* cell = (ChatStaticTextTableViewCell*)[wired firstObjectWithClass:[ChatStaticTextTableViewCell class]];
    
    cell.lblMessage.layer.cornerRadius =5;
    cell.lblMessage.clipsToBounds = YES;
    
    cell.cellDelegate = delegate;

        
    return cell;
    
}
-(IBAction)btnPressed:(id)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(ButtonClick:)]) 
    {
		[self.cellDelegate ButtonClick:self];
	}
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
