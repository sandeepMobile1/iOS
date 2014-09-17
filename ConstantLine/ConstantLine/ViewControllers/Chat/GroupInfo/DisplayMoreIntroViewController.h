//
//  DisplayMoreIntroViewController.h
//  ConstantLine
//
//  Created by Shweta Sharma on 22/01/14.
//
//

#import <UIKit/UIKit.h>

@interface DisplayMoreIntroViewController : UIViewController
{
    IBOutlet UITextView *txtView;
    IBOutlet UINavigationBar *navigation;
    IBOutlet UIImageView *imgBackView;
}
@property (nonatomic,retain) NSString *groupIntro;

@end
