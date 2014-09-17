//
//  PrivateChatContactsViewController.h
//  ConstantLine
//
//  Created by Pramod Sharma on 21/11/13.
//
//

#import <UIKit/UIKit.h>
#import "AddMembersTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ContactListInvocation.h"
#import "FriendProfileViewController.h"

@interface PrivateChatContactsViewController : UIViewController <AddMembersTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,ContactListInvocationDelegate,UIAlertViewDelegate>
{
    
    AddMembersTableViewCell *cell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    NSRange range;
    
    IBOutlet UINavigationBar *navigation;
    
    FriendProfileViewController *objFriendProfileViewController;
    
    IBOutlet UILabel *lblNoResult;
    
    UIAlertView *successAlert;
     NSMutableDictionary *results;
    
    UIButton *doneButton;
    
    
}
@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrContactList;
@property(nonatomic,strong)NSMutableArray *arrSelectedContactList;
@property (nonatomic,strong)NSString *selectedMemberId;
@property (nonatomic,strong)NSString *selectedMemberName;

@property (nonatomic,strong)NSString *checkView;

@property(nonatomic,retain)NSString  *localImageName;
@property(nonatomic,retain)NSString  *groupUniqueMember;
@property(nonatomic,retain)NSString  *groupId;

- (void) doPostWithText: (NSArray *) compositeData;
-(void)uploadData;
-(void)uploadImage;
- (void) doPostWithImage: (NSArray *) compositeData;

-(NSString *) genRandStringLength: (int) len;
-(void)saveGroupDetailOnLocalDB;
-(void)saveGroupMemberOnLocalDB;

@end

