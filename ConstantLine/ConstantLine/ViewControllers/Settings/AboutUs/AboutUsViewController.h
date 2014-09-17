//
//  AboutUsViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantLineServices.h"
#import "AboutUsInvocation.h"

@interface AboutUsViewController : UIViewController <UIWebViewDelegate,AboutUsInvocationDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationBar *navigation;
    IBOutlet UITextView *txtView;
    
    ConstantLineServices *service;

}

@end
