//
//  TableViewCell.m
//  Dolphin6
//
//  Created by Enuke Software on 14/12/11.
//  Copyright (c) 2011 rajsha.12@gmail.com. All rights reserved.
//

#import "TableViewCell.h"
#import "SpeechBubbleView.h"
#import "Chat.h"
#import <QuartzCore/QuartzCore.h>
#import "HighResolution.h"
@implementation TableViewCell


@synthesize  bubbleView, img, delegate, iconImg, icon,lblDate;
@synthesize slider = _slider;

- (void)initWithStyle:(CGSize)size chat:(Chat*)chat withDelegate:(id)delegate1
{
    self.delegate = delegate1;
    //self.contentView.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0] ;
	self.contentView.backgroundColor = [UIColor clearColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,120);
		
    bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
    //bubbleView.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0] ;
	bubbleView.backgroundColor = [UIColor clearColor];
    bubbleView.opaque = YES;
    bubbleView.clearsContextBeforeDrawing = NO;
    bubbleView.contentMode = UIViewContentModeRedraw;
    bubbleView.autoresizingMask = 0;
    
    [self.contentView addSubview:bubbleView];
    bubbleView.frame = CGRectMake(20, 5,size.width, size.height);
    [self.contentView sendSubviewToBack:bubbleView];
    
    CGRect r = CGRectMake(getFloatX(270), getFloatX(10), getFloatX(44), getFloatX(44));
    icon = [[UIImageView alloc] initWithFrame:r]; 
    icon.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [self.contentView addSubview:icon];
    
    lblDate=[[UILabel alloc] init];
    [lblDate setText:chat.sTime];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    [lblDate setTextColor:[UIColor whiteColor]];
    [lblDate setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.contentView addSubview:lblDate];

    if ([chat.sUserType isEqualToString:@"Sender"] || [chat.sUserType isEqualToString:@"sender"]) {
       
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeiPad) {
        
            [lblDate setFrame:CGRectMake(getFloatX(150), 10, 150, 20)];
        }else{
            [lblDate setFrame:CGRectMake(getFloatX(85), 10, 150, 20)];
        }
        
        [lblDate setTextAlignment:UITextAlignmentRight];
        [bubbleView setText:chat.sData bubbleType:BubbleTypeRighthand];
    
    }
    else{
        
        icon.frame = CGRectMake(5, 10, getFloatX(44), getFloatX(44));
        bubbleView.frame = CGRectMake(getFloatX(50), 5,size.width, size.height);
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeiPad) {
            [lblDate setFrame:CGRectMake(getFloatX(65), 10, 150, 20)];
        
        }else{
        
            [lblDate setFrame:CGRectMake(70, 10, 150, 20)];
        }
        
        [lblDate setTextAlignment:UITextAlignmentLeft];
        [bubbleView setText:chat.sData bubbleType:BubbleTypeLefthand];
		
    }
            	
}



- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


@end
