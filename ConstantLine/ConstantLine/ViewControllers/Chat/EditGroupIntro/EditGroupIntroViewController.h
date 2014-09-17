//
//  EditGroupIntroViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantLineServices.h"
#import "EditIntroOfGroupInvocation.h"
#import "GroupDetailInvocation.h"

@interface EditGroupIntroViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate,EditIntroOfGroupInvocationDelegate,GroupDetailInvocationDelegate>
{
    IBOutlet UITextView *txtView;
    IBOutlet UINavigationBar *navigation;
    ConstantLineServices *service;

    IBOutlet UIScrollView *scrollView;
        
    UIAlertView *successAlert;
    
    int totalCharacterCout;
}
@property (nonatomic,retain) NSString *groupId;
-(IBAction)btnEditIntroPressed:(id)sender;
-(NSString *) stringByStrippingHTML:(NSString*)intro;

@end
