//
//  AddContactViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExistingContactListViewController;
@class PhoneContactsViewController;
@interface AddContactViewController : UIViewController
{
    IBOutlet UINavigationBar *navigation;
    ExistingContactListViewController *objExistingView;
    PhoneContactsViewController *objPhoneContactView;

}

-(IBAction)btnExistingContact:(id)sender;

-(IBAction)btnphoneContact:(id)sender;

@end
