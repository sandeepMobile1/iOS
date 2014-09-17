//
//  ContactViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewCell.h"
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ContactListInvocation.h"
#import "DeleteContactInvocation.h"
#import "SendPhoneListInvocation.h"
#import "UserProfileViewController.h"
#import "FriendProfileViewController.h"
#import "AcceptRejectFriendRequestInvocation.h"
#import "AddContactViewController.h"
#import "ContactTableViewPendingCell.h"
//#import "GAI.h"
//#import "GAITrackedViewController.h"

@interface ContactViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ContactTableViewCellDelegate,SWTableViewCellDelegate,ContactListInvocationDelegate,ImageCacheDelegate,UISearchBarDelegate,DeleteContactInvocationDelegate,SendPhoneListInvocationDelegate,AcceptRejectFriendRequestInvocationDelegate,ContactTableViewPendingCellDelegate>
{
    ContactTableViewCell *cell;
    ContactTableViewPendingCell *pendingCell;
    
    ImageCache *objImageCache;
    IBOutlet UISearchBar *searchBar;
    ConstantLineServices *service;
    NSMutableArray *alphasectionarray;
    NSRange range;
    AddContactViewController *objAddContactViewController;

    UIButton *EditButton;
    
    IBOutlet UINavigationBar *navigation;
    
    BOOL checkSearch;
    NSString *phoneNumList;
    IBOutlet UIButton *btnRecomanded;
    
    IBOutlet UIScrollView *topScroll;
    
    IBOutlet UILabel     *lblNoResult;
    IBOutlet UIButton    *btnExisting;
    IBOutlet UIButton    *btnPhone;
    IBOutlet UIImageView *imgExisting;
    IBOutlet UIImageView *imgPhone;
    IBOutlet UILabel     *lblExisting;
    IBOutlet UILabel     *lblPhone;
    IBOutlet UIImageView *imgExistingArrow;
    IBOutlet UIImageView *imgPhoneArrow;
    IBOutlet UIImageView *imgTopView;
    IBOutlet UILabel     *lblRecommaned;
    BOOL checkIndex;
    
    UserProfileViewController *objProfileViewController;
    FriendProfileViewController *objFriendProfileViewController;
    
    NSString *checkPN;
    
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

}
@property(nonatomic,strong)IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSMutableArray *arrContactList;
@property(nonatomic,strong)NSMutableArray *arrSearchContactList;
@property(nonatomic,strong)NSMutableArray *arrRecomandedList;
- (CGSize)sizeForText:(NSString*)text;

- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void) createSectionList: (id) wordArray;
-(BOOL) stringIsNumeric:(NSString *)str;

-(IBAction)btnRecomandedFriendsPressed:(id)sender;
//- (void)dispatch;

- (NSArray *)leftButtons:(NSString *)tag;


@end
