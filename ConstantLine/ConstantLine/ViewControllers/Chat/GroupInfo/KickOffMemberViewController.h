//
//  KickOffMemberViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMembersTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "KickOffMemberInvocation.h"
#import "GroupMemberListInvocation.h"
#import "AddPrivillegeInvocation.h"

@interface KickOffMemberViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,KickOffMemberInvocationDelegate,GroupMemberListInvocationDelegate,ImageCacheDelegate,UIAlertViewDelegate,AddPrivillegeInvocationDelegate>
{
    AddMembersTableViewCell *cell;

    IBOutlet UITableView *tblView;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    
    IBOutlet UINavigationBar *navigation;
    
    UIAlertView *kickOffAlert;
    UIAlertView *privilageAlert;
}
@property(nonatomic,strong)NSMutableArray *arrMemberList;
@property(nonatomic,strong)NSString *kickOffUserId;
@property(nonatomic,strong)NSString *memberIds;
@property(nonatomic,strong)NSString *threadId;
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *ownerId;


@property(nonatomic,strong)NSString *checkView;

@end
