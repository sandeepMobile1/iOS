//
//  GroupViewController.h
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import <UIKit/UIKit.h>
#import "ChatListTableViewCell.h"
#import "ChatListUnpaidTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "LatestGroupInvocation.h"
#import "JoinGroupInvocation.h"
#import "AcceptRejectGroupChatInvocation.h"
#import "FindGroupInvocation.h"
#import "SpecialGroupJoinInvocation.h"
//#import "GAI.h"
//#import "GAITrackedViewController.h"
#import "Facebook.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@class StartGroupViewController;
@class GroupListViewController;
@class FinsGroupViewController;
@class ChatViewController;
@class GroupInfoViewController;
@class FBPermissionDialog;
@class FBSession;

@interface GroupViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ImageCacheDelegate,LatestGroupInvocationDelegate,ChatListTableViewCellDelegate,ChatListUnpaidTableViewCellDelegate,JoinGroupInvocationDelegate,AcceptRejectGroupChatInvocationDelegate,UISearchBarDelegate,FindGroupInvocationDelegate,SpecialGroupJoinInvocationDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,FBDialogDelegate, FBSessionDelegate, FBRequestDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    StartGroupViewController *objStartGroupView;
    GroupListViewController *objGroupListViewController;
    FinsGroupViewController *objFinsGroupViewController;
    GroupInfoViewController *objGroupInfoViewController;
    
    NSString *checkPN;
    
    IBOutlet UINavigationBar *navigation;
    ChatListTableViewCell *cell;
    ChatListUnpaidTableViewCell *unpaidCell;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    
    ChatViewController *objChatViewController;
    
    IBOutlet UIButton    *btnStartGroup;
    IBOutlet UIButton    *btnManageGroup;
    IBOutlet UIButton    *btnFindGroup;
    
    int unreadCount;
    
    IBOutlet UISearchBar *searchBar;
    
    BOOL checkPaging;
    
    UIAlertView *exitAlert;
    
    IBOutlet UIView *BottomView;
    IBOutlet UILabel *lblTotalRecordCount;
    IBOutlet UIImageView *imgBottomView;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *searchView;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIImageView *imgSearchView;
    
    FBPermissionDialog *dialog;
    
    Facebook *facebook;
    
    NSArray *permissions;
    
    IBOutlet UILabel *lblNoResult;
    IBOutlet UIButton *btnNoResult;


}
@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrChatList;
@property(nonatomic,strong)NSMutableArray *arrSearchGroupList;
@property(nonatomic,strong)NSString *searchString;
@property(nonatomic,strong)NSString *shareGroupName;
@property(nonatomic,strong)NSString *shareGroupCode;
@property(nonatomic,strong)NSString *shareGroupImage;

@property (nonatomic, strong)NSString *FBUserName;
@property (nonatomic, strong) FBLoginDialog *loginDialog;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, assign) BOOL posting;
@property (nonatomic, strong)NSDictionary *fbUserDetails;
@property (nonatomic, strong)NSString *FBUserID;
@property(nonatomic,strong)	NSString *FBToken;
@property (nonatomic,strong) Facebook *facebook;

@property(nonatomic,assign)int page;
@property (nonatomic,assign)int totalRecord;
@property(nonatomic,strong) UIActionSheet  *actionSheetView;

-(IBAction)stratGroupPressed:(id)sender;
-(IBAction)manageGroupPressed:(id)sender;
-(IBAction)findGroupPressed:(id)sender;

-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)btnCancelPressed:(id)sender;
-(IBAction)btnNoResultPressed:(id)sender;
-(IBAction)btnHelpPressed:(id)sender;

- (void)handleSearchForTerm:(NSString *)searchTerm;
-(NSString *) stringByStrippingHTML:(NSString*)intro;

@end
