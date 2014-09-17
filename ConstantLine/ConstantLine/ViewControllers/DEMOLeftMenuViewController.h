//
//  DEMOMenuViewController.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "UserProfileView.h"
#import "GroupHeader.h"
#import "LogOutInvocation.h"
#import "ConstantLineServices.h"

@interface DEMOLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,LogOutInvocationDelegate>{
    
    BOOL isArrowOpen;
    
    IBOutlet UIImageView *imgAlertView;
    IBOutlet UIView *alertBackView;
    IBOutlet UIButton *btnOk;
    IBOutlet UIButton *btnCancel;
    
    UILabel *lblNotification;
    UIImageView *imgNotification;
    
    ConstantLineServices *service;

}

@property(nonatomic,strong) UserProfileView *viewUserProfile;
@property(nonatomic,strong) GroupHeader *groupHeader;

-(IBAction)btnOKPressed:(id)sender;
-(IBAction)btnCancelPressed:(id)sender;

-(void)createAlertView;

@end
