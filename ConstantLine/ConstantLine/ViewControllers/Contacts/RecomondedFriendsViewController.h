//
//  RecomondedFriendsViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 9/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactListInvocation.h"
#import "ConstantLineServices.h"
#import "RecommandedTableViewCell.h"
#import "ImageCache.h"

@interface RecomondedFriendsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,AddContactListInvocationDelegate,RecommandedTableViewCellDelegate,ImageCacheDelegate>
{
    RecommandedTableViewCell *cell;
    ConstantLineServices *service;
    IBOutlet UINavigationBar *navigation;
    
    ImageCache *objImageCache;
    
    int deletedRow;

}
@property(nonatomic,strong)IBOutlet UITableView *tblView;

@property(nonatomic,strong)NSMutableArray *arrRecommandFriendList;



@end
