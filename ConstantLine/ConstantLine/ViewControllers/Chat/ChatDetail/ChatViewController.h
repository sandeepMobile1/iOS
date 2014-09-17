//
//  ChatViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "ChatTextTableViewCell.h"
#import "HPGrowingTextView.h"
#import "ChatTextUserTableViewCell.h"
#import "ChatAudioTableViewCell.h"
#import "ChatAudioUserTableViewCell.h"
#import "ChatImageTableViewCell.h"
#import "ChatImageUserTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatNameCardTableViewCell.h"
#import "ChatNameCardUserTableViewCell.h"
#import "BlockInvocation.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AppDelegate.h"
#import "SendChatInvocation.h"
#import "ChatDetailInvocation.h"
#import "DeleteChatInvocation.h"
#import "ChatStaticTextTableViewCell.h"
#import "AddContactListInvocation.h"
#import "FriendProfileViewController.h"
#import "ChatRequestTableViewCell.h"
#import "AcceptRejectOwnerRequestInvocation.h"

@class AVAudioRecorder;
@class AVAudioSession;
@class AVAudioPlayer;
@class UserProfileViewController;
@class MWPhotoBrowser;

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ImageCacheDelegate,HPGrowingTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,AVAudioRecorderDelegate,AVAudioSessionDelegate,AVAudioPlayerDelegate,ChatTextTableViewCellDelegate,ChatTextUserTableViewCellDelegate,ChatImageTableViewCellDelegate,ChatImageUserTableViewCellDelegate,ChatAudioTableViewCellDelegate,ChatAudioUserTableViewCellDelegate,ChatNameCardTableViewCellDelegate,ChatNameCardUserTableViewCellDelegate,BlockInvocationDelegate,ChatDetailInvocationDelegate,SendChatInvocationDelegate,DeleteChatInvocationDelegate,ChatStaticTextTableViewCellDelegate,AddContactListInvocationDelegate,UIPopoverControllerDelegate,ChatRequestTableViewCellDelegate,AcceptRejectOwnerRequestInvocationDelegate,UIAlertViewDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIView *requestView;
    IBOutlet UIImageView *imgFriendimage;
    IBOutlet UILabel *lblFriendName;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *blockButton;
    IBOutlet UIButton *btnProfile;
    AppDelegate *del;

    IBOutlet UINavigationBar *navigation;
    ImageCache *objImageCache;
    ConstantLineServices *service;
    
    NSMutableData *responseData;
	NSString *responseString;
    
    ChatTextTableViewCell       *cell;
    ChatTextUserTableViewCell   *textUserCell;
    ChatImageTableViewCell      *imageCell;
    ChatImageUserTableViewCell  *imageUserCell;
    ChatAudioTableViewCell      *audioCell;
    ChatAudioUserTableViewCell  *audioUserCell;
    ChatNameCardTableViewCell   *nameCardCell;
    ChatNameCardUserTableViewCell *nameCarduserCell;
    ChatStaticTextTableViewCell *staticCell;
    ChatRequestTableViewCell *requestCell;
    
    IBOutlet UIButton *btnEdit;
    
    UIView *containerView;
    
    BOOL checkDisapper;
    
    IBOutlet UIView *AudioView;
    UIButton *PlusBtn;
    
    IBOutlet UIButton *btnCameraImage;
    IBOutlet UIButton *btnLibraryImage;
    IBOutlet UIButton *btnAudio;
    IBOutlet UIButton *btnNameCard;
        
    NSMutableDictionary *results;

    AVAudioRecorder * soundRecorder;
    AVAudioPlayer *audioPlayer;
    
	BOOL soundBool;
    
    IBOutlet UIImageView *deviderImgView;
    
    NSTimer *audioTimer;

    UIImagePickerController* picker;
    
    NSString *checkPN;
    NSString *blockStr;
    
    NSString *uploadServerImageId;
    NSString *uploadServerAudioId;
    NSString *nameCardId;
    
    NSMutableArray *arrPostImageList;
    
    IBOutlet UIButton *btnHoldToTalk;
    IBOutlet UILabel  *lblHoldToTalk;

    UIButton *doneBtn;
    UIButton *btnKeyboard;
    
    UserProfileViewController *objProfileViewController;
    FriendProfileViewController *objFriendProfileViewController;

    int audiotimeLimit;
    
    NSCache *cache;
    
    IBOutlet UITableView *tblView;
    UILongPressGestureRecognizer *longPress;
    BOOL checkHoldTalkPressed;
    
    UIPopoverController *popoverController;
    
    int page;
    BOOL checkAddress;
     NSString *checkTablePosition;
    MWPhotoBrowser *objMWPhotoBrowser;
    
    UILongPressGestureRecognizer *longPressProfileImage;
    UILongPressGestureRecognizer *longPressUserProfileImage;

    BOOL checkLongPress;
    
    float offset;
    
    UIAlertView *addContactAlert;
    
    BOOL checkMove;
    
    UIAlertView *blockAlert;
    
    UITextView *alertTextField;
    int totalCharacterCount;
    
    IBOutlet UIView *blackRecordingView;
    
    NSTimer *audioProgressTimer;
    
    UIImageView *imgLoadingView;

    int loadingCounter;
    
}

@property(nonatomic,retain)NSMutableArray *arrChatData;
@property(nonatomic,retain)NSMutableArray *arrTempChatData;
@property(nonatomic,retain)HPGrowingTextView *textView;
@property(nonatomic,retain)NSString *checkLastMsgIdStr;

@property(nonatomic,retain)NSString *threadId;
@property(nonatomic,retain)NSString *friendId;
@property(nonatomic,retain)NSString *uploadFileName;
@property(nonatomic,retain)NSString *documentPath;
@property(nonatomic,retain)NSString *blockStatus;
@property(nonatomic,retain)NSString *zChatId;
@property(nonatomic,retain)NSString *recorderFilePath;
@property(nonatomic,retain)NSData   *imageData;
@property(nonatomic,retain)NSString *totalRecord;
@property(nonatomic,retain)NSString *msessageString;
@property(nonatomic,retain)NSIndexPath *selectedRowIndexPath;

@property(nonatomic,retain)NSString *friendUserName;
@property(nonatomic,retain)NSString *friendUserImage;
@property(nonatomic,retain)NSString *groupType;
@property(nonatomic,retain)NSString *groupId;

@property (nonatomic, retain) NSString *timeinNSString;
@property (nonatomic, assign)float      totalHeightForCell;
@property (nonatomic, retain)NSString * lastMsgId;
@property (nonatomic, retain)NSString * deleteMsgId;
@property (nonatomic, retain)NSString * checkType;
@property (nonatomic, retain) NSString *checkScroll;
@property(nonatomic,strong) UIActionSheet  *actionSheetView;
@property (nonatomic, retain)NSString * groupTitle;

-(IBAction)btnKeyboardPressed:(id)sender;

-(void)setRequestValue;
-(void)setRequestUserImage;
-(void)startRecording;
- (void)stopRecording;

-(IBAction)btnAddPressed:(id)sender;
-(IBAction)btnBlockPressed:(id)sender;
-(IBAction)btnEditPressed:(id)sender;
-(IBAction)plusBtnPressed:(id)sender;
-(IBAction)profileBtnPressed:(id)sender;
-(IBAction)editIconBtnPressed:(id)sender;

-(void)resignTextView;
- (void)sendChatData:(NSString*)aData;

-(void)CreateChatTableTextVIew:(ChatTextTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTableTextUserVIew:(ChatTextUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTableImageVIew:(ChatImageTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTableImageUserVIew:(ChatImageUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTableAudioVIew:(ChatAudioTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTablAudioUsereVIew:(ChatAudioUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTableNameCardVIew:(ChatNameCardTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTablNameCardUserVIew:(ChatNameCardUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;
-(void)CreateChatTableRequestVIew:(ChatRequestTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath;

-(IBAction)btnCameraPressed:(id)sender;
-(IBAction)btnCameraImagePressed:(id)sender;
-(IBAction)btnLibraryImagePressed:(id)sender;

-(IBAction)btnAudioPressed:(id)sender;
-(IBAction)btnNameCardPressed:(id)sender;

- (void)useImage:(UIImage*)theImage;
-(NSString *)documentsDirectoryPath;

-(CGSize)sizeForText:(NSString*)text;
- (CGSize)sizeForImage:(CGSize)textSize;

-(void)SendChatOnLocalDB:(NSMutableArray*)array;
-(void)displayChatDataFromLocalDB;
-(void)getThreadIDFromLocalDB;
-(void)saveLastMsgIdOnLocalDB:(NSString*)chatId;
-(void)getLastMsgIdFromLocalDB;

-(void)getChatDetailTypeFromLocalDB;

-(void)checkNameCardUser:(NSMutableArray*)array;
-(void)saveNameCardUser:(NSMutableArray*)array;

-(void)saveChatDataInTable:(NSMutableArray*)array;
-(NSString*)checkAndCreateThreadIDFromLocalDB:(NSString*)thread;
-(NSString*)checkAndCreateGroupThreadIDFromLocalDB:(NSString*)thread;

-(NSString *) genRandStringLength: (int) len;

- (void) doPostWithImage: (NSArray *) compositeData;
-(void)uploadImage;
-(void)uploadAudio;
- (void) doPostWithAudio: (NSArray *) compositeData;

-(void)parseChat;
-(void)changeStatus;

-(void)checkAndSaveUserDetailFromLocalDB:(NSString*)UserId UserName:(NSString*)UserName UserImage:(NSString*)UserImage;
-(void)recordingTime;
-(void)showBlackRecordingView;
-(void)hideBlackRecordingView;



@end
