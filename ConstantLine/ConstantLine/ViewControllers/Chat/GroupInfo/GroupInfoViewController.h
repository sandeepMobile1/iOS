//
//  GroupInfoViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantLineServices.h"
#import "GroupDetailInvocation.h"
#import "ImageCache.h"
#import "GroupInfoFirstTableViewCellController.h"
#import "GroupInfoSecondTableViewCell.h"
#import "GroupInfoOwnerTableViewCell.h"
#import "GroupInfoUserTableViewCell.h"
#import "KickOffMemberViewController.h"
#import "AddRatingInvocation.h"
#import "AddRatingOwnerInvocation.h"
#import "AddMemberInGroupViewController.h"
#import "QuitGroupInvocation.h"
#import "ClearGroupMessageInvocation.h"
#import "GroupTypeEditInvocation.h"
#import "GroupInfoFirstDetailTableViewCell.h"
#import "UnSubcribeInvocation.h"
#import "GroupInfoUserPrivateTableViewCell.h"
#import "GroupInfoOwnerPrivateTableViewCell.h"
#import "JoinGroupInvocation.h"
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import "RevenueInvocation.h"
#import "DisplayMoreIntroViewController.h"
#import "SpecialGroupJoinInvocation.h"
#import "Facebook.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "GroupMemberTableViewCell.h"
#import "FriendProfileViewController.h"
#import "QuitSpecialGroupInvocation.h"
#import "UserProfileViewController.h"

@class FBPermissionDialog;
@class FBSession;

@interface GroupInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GroupDetailInvocationDelegate,ImageCacheDelegate,GroupInfoFirstTableViewCellControllerDelegate,GroupInfoSecondTableViewCellDelegate,GroupInfoOwnerTableViewCellDelegate,GroupInfoUserTableViewCellDelegate,AddRatingInvocationDelegate,AddRatingOwnerInvocationDelegate,QuitGroupInvocationDelegate,UIAlertViewDelegate,ClearGroupMessageInvocationDelegate,GroupTypeEditInvocationDelegate,GroupInfoFirstDetailTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UnSubcribeInvocationDelegate,GroupInfoUserPrivateTableViewCellDelegate,GroupInfoOwnerPrivateTableViewCellDelegate,JoinGroupInvocationDelegate,SKProductsRequestDelegate,SKRequestDelegate, SKPaymentTransactionObserver,RevenueInvocationDelegate,SpecialGroupJoinInvocationDelegate,UIActionSheetDelegate,FBDialogDelegate, FBSessionDelegate, FBRequestDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,GroupMemberTableViewCellDelegate,QuitSpecialGroupInvocationDelegate>
{
    ImageCache *objImageCache;
    ConstantLineServices *service;
   
    FriendProfileViewController *objFriendProfieView;
    GroupInfoFirstTableViewCellController *firstCell;
    GroupInfoSecondTableViewCell *secondCell;
    GroupInfoOwnerTableViewCell *ownerCell;
    GroupInfoUserTableViewCell *userCell;
    KickOffMemberViewController *objKickOffMemberViewController;
    GroupInfoFirstDetailTableViewCell *firstDetailCell;
    GroupInfoUserPrivateTableViewCell *userPrivateCell;
    GroupInfoOwnerPrivateTableViewCell *ownerPrivateCell;
    DisplayMoreIntroViewController *objDisplayMoreIntroViewController;
    GroupMemberTableViewCell *groupMemberCell;
    UserProfileViewController *objProfileViewController;
    
    NSArray *arrayProductID;
    
    IBOutlet UINavigationBar *navigation;

    NSString *desc;
    
     UIFont* font;
    
     CGFloat VertPadding;       // additional padding around the edges
     CGFloat HorzPadding;
    
     CGFloat TextLeftMargin;   // insets for the text
     CGFloat TextRightMargin;
     CGFloat TextTopMargin;
     CGFloat TextBottomMargin;
    
     CGFloat MinBubbleWidth;   // minimum width of the bubble
     CGFloat MinBubbleHeight;  // minimum height of the bubble
    
     CGFloat WrapWidth;
    
    NSMutableDictionary *results;

    AddMemberInGroupViewController *objAddMemberInGroupViewController;
    
    UIAlertView *quitAlert;
    UIAlertView *clearAlert;
    UIAlertView *imageAlert;
    UIAlertView *shareAlert;

    UIAlertView *quitSuccessAlert;
    UIAlertView *clearSuccessAlert;
    UIAlertView *imageSuccessAlert;
    
    UIAlertView *unsubscribeAlert;
    UIAlertView *unsubscribeSuccessAlert;
    
    UIAlertView *subscribeAlert;
    UIAlertView *subscribeSuccessAlert;
    UIAlertView *kickOutAlert;
    
    FBPermissionDialog *dialog;
    
    Facebook *facebook;
    
    NSArray *permissions;


}

@property(nonatomic,strong) IBOutlet UITableView *tblView;
@property(nonatomic,strong) NSMutableArray *arrGroupDetailData;
@property(nonatomic,strong) NSMutableArray *arrGroupMemberList;
@property(nonatomic,retain) NSMutableArray *arrImageAudioPath;


@property(nonatomic,retain)NSData     *imageData;

@property(nonatomic,strong) NSString  *groupId;
@property(nonatomic,strong) NSString  *groupOwnerId;
@property(nonatomic,strong) NSString  *privilageStatus;
@property(nonatomic,strong) NSString  *threadId;
@property(nonatomic,strong) NSString  *userIds;
@property(nonatomic,strong) NSString  *groupType;
@property(nonatomic,strong) NSString  *transactionId;
@property(nonatomic,strong) NSString  *joinStatus;
@property(nonatomic,strong) NSString  *subscriptionStatus;
@property(nonatomic,strong) UIActionSheet  *actionSheetView;

@property (nonatomic,retain) NSString *strTransactionId;
@property (nonatomic,retain) NSString *productId;
@property (nonatomic,retain) NSString *productName;
@property (nonatomic,retain) NSString *productPrice;
@property (nonatomic,retain) NSString *kickOutStatus;
@property (nonatomic,retain) NSString *specialStatus;

@property (nonatomic, strong)NSString *FBUserName;
@property (nonatomic, strong) FBLoginDialog *loginDialog;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, assign) BOOL posting;
@property (nonatomic, strong)NSDictionary *fbUserDetails;
@property (nonatomic, strong)NSString *FBUserID;
@property(nonatomic,strong)	NSString *FBToken;
@property (nonatomic,strong) Facebook *facebook;

-(void)CreateRatingVIew:(GroupInfoFirstTableViewCellController *)customCell AtIndex:(NSIndexPath *)indexPath;

-(void)CreateUserGroupRatingVIew:(GroupInfoUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;

-(void)CreateUserOwnerRatingVIew:(GroupInfoUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;

-(void)CreateUserGroupPrivilegeRatingVIew:(GroupInfoSecondTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;

-(void)CreateUserOwnerPrivilegeRatingVIew:(GroupInfoSecondTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;

-(void)CreateGroupMemberVIew:(GroupMemberTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;


-(IBAction)btnShareWellConnectedPressed:(id)sender;
-(IBAction)btnShareFBPressed:(id)sender;
-(IBAction)btnShareTWPressed:(id)sender;
-(IBAction)btnShareMailPressed:(id)sender;
-(IBAction)btnShareOnSMSPressed:(id)sender;

- (CGSize)sizeForText:(NSString*)text;

- (void) doPostWithImage: (NSArray *) compositeData;
-(void)uploadImage;
- (void)useImage:(UIImage*)theImage;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction:   (SKPaymentTransaction *)transaction;
- (void) restoreTransaction:  (SKPaymentTransaction *)transaction;
- (void) startPurchase;
-(NSString *) stringByStrippingHTML:(NSString*)intro;
-(void)facebookLogin;
- (void)login;

-(void)getAllImagePath;
-(void)getAllAudioPath;
-(void)deleteAllChat;

@end
