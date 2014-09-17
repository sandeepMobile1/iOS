//
//  TableViewCell.h
//  Dolphin6
//
//  Created by Enuke Software on 14/12/11.
//  Copyright (c) 2011 rajsha.12@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AsyncImageView.h"

@class SpeechBubbleView;
@class Chat;
@class TableViewCell;

@protocol TableViewCellDelegate <NSObject>

@end
@interface TableViewCell : UITableViewCell{

    IBOutlet SpeechBubbleView* bubbleView;
    UIImageView *icon;
    
    UISlider * _slider;
    UIImageView *img;
    BOOL isPaused;
    NSString *iconImg;
}
@property (nonatomic, strong) IBOutlet SpeechBubbleView* bubbleView;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) NSString *iconImg;
@property (nonatomic, strong) IBOutlet UISlider * slider;
@property (nonatomic, unsafe_unretained) id<TableViewCellDelegate> delegate;

- (void)initWithStyle:(CGSize)size chat:(Chat*)chat withDelegate:(id)delegate1;
- (NSString *)applicationDocumentsDirectory;
@end
