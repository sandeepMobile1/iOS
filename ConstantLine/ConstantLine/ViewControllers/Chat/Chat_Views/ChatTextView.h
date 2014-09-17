//
//  ChatTextView.h
//  WazZupCafe
//
//  Created by octal i-phone2 on 4/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface ChatTextView : UIView {
    
    
    
}
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
@property(nonatomic,retain)HPGrowingTextView *hPGrowingTextView;
@property(nonatomic,retain)UILabel *lblCharacterCount;
@property(nonatomic,assign)BOOL isOpen;
@end
