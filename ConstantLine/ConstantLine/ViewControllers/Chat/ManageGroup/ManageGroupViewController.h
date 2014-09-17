//
//  ManageGroupViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloseGroupInvocation.h"
#import "QuitGroupInvocation.h"
#import "ConstantLineServices.h"
#import "KickOffMemberViewController.h"

@interface ManageGroupViewController : UIViewController <CloseGroupInvocationDelegate,QuitGroupInvocationDelegate,UIAlertViewDelegate>
{
    IBOutlet UINavigationBar *navigation;
    ConstantLineServices *service;
    IBOutlet UILabel *lblCloseGroup;
    IBOutlet UILabel *lblCloseGroupDesc;
    
    IBOutlet UIButton *btnPrivilage;
    
    KickOffMemberViewController *objKickofmember;
    UIAlertView *successAlert;
}
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *ownerId;
@property(nonatomic,retain)NSString *userIds;
@property(nonatomic,retain)NSString *closeStatus;
@property(nonatomic,retain)NSString *threadId;

@property(nonatomic,retain)NSString *checkUser;

-(IBAction)btnCloseGroupPressed:(id)sender;
-(IBAction)btnEditGroupPressed:(id)sender;
-(IBAction)btnPrivilegeGroupPressed:(id)sender;
-(IBAction)btnQuitGroupPressed:(id)sender;

@end
