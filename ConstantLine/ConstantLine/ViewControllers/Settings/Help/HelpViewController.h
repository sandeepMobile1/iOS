//
//  HelpViewController.h
//  ConstantLine
//
//  Created by Shweta Sharma on 27/01/14.
//
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *objWebView;
    IBOutlet UINavigationBar *navigation;

}
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *titleStr;


@end
