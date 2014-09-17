//
//  GallaryViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GallaryViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    
}

@property(nonatomic,strong)NSMutableArray *arrImageList;

- (void)layoutScrollText;
- (void)layoutScrollImages;
-(void)CreateGalleryView;

@end
