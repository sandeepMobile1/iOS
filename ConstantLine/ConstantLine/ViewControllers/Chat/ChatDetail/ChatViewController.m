//
//  ChatViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChatViewController.h"
#import "Config.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "ChatDetailData.h"
#import "AddContactViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "UserProfileViewController.h"
#import "QSStrings.h"
#import "ExistingContactListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageExtras.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "MWPhotoBrowser.h"
#import "NSString+Utils.h"
#import "ChatStaticTextTableViewCell.h"
#import "GroupInfoViewController.h"
#import "PrivateChatContactsViewController.h"
#import "KickOffMemberViewController.h"
#import "NSString+AESCrypt.h"
#import "NSData+AESCrypt.h"

static UIFont* font = nil;

const CGFloat VertPadding = 4;       // additional padding around the edges
const CGFloat HorzPadding = 4;

const CGFloat TextLeftMargin = 17;   // insets for the text
const CGFloat TextRightMargin = 15;
const CGFloat TextTopMargin = 10;
const CGFloat TextBottomMargin = 11;

const CGFloat MinBubbleWidth = 50;   // minimum width of the bubble
const CGFloat MinBubbleHeight = 40;  // minimum height of the bubble

const CGFloat WrapWidth = 200;
//static NSCache *cache = nil;
static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";


@implementation ChatViewController

@synthesize friendId,uploadFileName,documentPath,blockStatus,zChatId,friendUserName,friendUserImage,imageData,timeinNSString,threadId,recorderFilePath,totalHeightForCell,lastMsgId,groupType,groupId,deleteMsgId,checkType,totalRecord,checkScroll,textView,checkLastMsgIdStr,msessageString,actionSheetView,selectedRowIndexPath,groupTitle;

@synthesize arrChatData=_arrChatData;
@synthesize arrTempChatData=_arrTempChatData;




- (void)scrollToNewestMessage
{
	// The newest message is at the bottom of the table
    if ([self.arrChatData count] > 1) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(self.arrChatData.count - 1) inSection:0];
        [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
}

// maximum width of text in the bubble

-(id)init
{
    
	self = [super init];
	if(self){
		
        
	}
	
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    page=1;
    
    [AppDelegate sharedAppDelegate].checkaddressContact=@"NO";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [btnEdit setHidden:TRUE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveForgroundNotification:) name:@"RemoteNotificationReceivedWhileForgroud" object:Nil];
    
    if (self.arrChatData == nil) {
        
        self.arrChatData=[[NSMutableArray alloc] init];
    }
    if (arrPostImageList == nil) {
        
        arrPostImageList=[[NSMutableArray alloc] init];
    }
    if (self.arrTempChatData == nil) {
        
        self.arrTempChatData=[[NSMutableArray alloc] init];
    }
    
    [AppDelegate sharedAppDelegate].friendStatus=@"0";
    self.blockStatus=@"0";
    
    [lblFriendName setHidden:TRUE];
    [imgFriendimage setHidden:TRUE];
    [btnProfile setHidden:TRUE];
    
    [addButton setHidden:TRUE];
    [blockButton setHidden:TRUE];
    
    
    checkDisapper=TRUE;
    
    self.lastMsgId=@"";
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Chat"];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    
    UIButton *infoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setFrame:CGRectMake(0,0, 39,44)];
    
    [infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [infoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [infoButton.titleLabel setTextColor:[UIColor whiteColor]];

    [infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *infoButtonView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 39, 44)]autorelease];
    [infoButtonView addSubview:infoButton];
    
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:infoButtonView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 5, 270, 50)];
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
	self.textView.returnKeyType = UIReturnKeyGo;
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.returnKeyType=UIReturnKeySend;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground]autorelease];
    
    entryImageView.frame = CGRectMake(10, 0, 270, 45);
    
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background]autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
   /* btnKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    btnKeyboard.frame = CGRectMake(2, 5, 35, 35);
    btnKeyboard.tag=1;
    [btnKeyboard setBackgroundImage:[UIImage imageNamed:@"ToolViewInputText.png"] forState:UIControlStateNormal];
    btnKeyboard.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [btnKeyboard addTarget:self action:@selector(btnKeyboardPressed:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:btnKeyboard];*/
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    PlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PlusBtn.frame = CGRectMake(containerView.frame.size.width - 35, 10, 27, 27);
    PlusBtn.tag=1;
    PlusBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [PlusBtn addTarget:self action:@selector(plusBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [PlusBtn setBackgroundImage:[UIImage imageNamed:@"go_back_btn"] forState:UIControlStateNormal];
    [containerView addSubview:PlusBtn];
    
    [requestView setFrame:CGRectMake(0, 63, 320, 35)];
    
    [self.view addSubview:AudioView];

    [AudioView setHidden:TRUE];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:2.0];
    
    [UIView commitAnimations];
    
    imgLoadingView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 21)];
    [imgLoadingView setBackgroundColor:[UIColor clearColor]];
    [AudioView addSubview:imgLoadingView];
    [imgLoadingView setHidden:TRUE];


    self.textView.text=@"";
    [containerView setHidden:TRUE];
    [AudioView setHidden:FALSE];
    
  /*  btnHoldToTalk=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnHoldToTalk setFrame:CGRectMake(self.textView.frame.origin.x-2, 8, self.textView.frame.size.width+2, self.textView.frame.size.height+10)];
    //[btnHoldToTalk setBackgroundImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];
    
    [btnHoldToTalk setBackgroundImage:[UIImage imageNamed:@"before_tab_btn"] forState:UIControlStateNormal];
    [btnHoldToTalk setBackgroundImage:[UIImage imageNamed:@"after_tab_btn"] forState:UIControlStateHighlighted];

    [btnHoldToTalk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHoldToTalk setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [btnHoldToTalk.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [btnHoldToTalk setTitle:@"Hold to talk" forState:UIControlStateNormal];
    [btnHoldToTalk setTitle:@"Release to send" forState:UIControlStateHighlighted];
    [containerView addSubview:btnHoldToTalk];
    [btnHoldToTalk setHidden:FALSE];*/
    
    
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.cancelsTouchesInView = NO;
    [btnHoldToTalk addGestureRecognizer:longPress];
    
    [self getLastMsgIdFromLocalDB];
    
    if([self.groupType isEqualToString:@"1"])
    {
        if (self.threadId!=nil || self.threadId!=(NSString*)[NSNull null] || ![self.threadId isEqualToString:@""]) {
            
            NSString *thread=[self checkAndCreateGroupThreadIDFromLocalDB:[NSString stringWithFormat:@"%@",self.threadId]];
            
            NSLog(@"%@",thread);
        }
    }
   
    
    [longPress release];
    
    checkType=@"";
    
    self.zChatId=@"";
    
    [tblView setContentOffset:CGPointMake(0, 0)];

    [AppDelegate sharedAppDelegate].checkNameCard=@"NO";
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        if (service==nil) {
            
            service=[[ConstantLineServices alloc] init];
        }
        
        NSLog(@"%@",self.lastMsgId);
        NSString *pageStr=[NSString stringWithFormat:@"%d",page];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        checkDisapper=FALSE;
        checkScroll=@"NO";
        
        
        [service ChatDetailInvocation:gUserId friendId:self.friendId lastmsgId:self.lastMsgId type:[AppDelegate sharedAppDelegate].chatDetailType groupType:self.groupType groupId:self.groupId page:pageStr delegate:self];
        
        offset=0;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.textView.text=@"";
    [containerView setHidden:TRUE];
    [AudioView setHidden:FALSE];
    PlusBtn.tag=1;
    
    checkLongPress=FALSE;
        
    if (service==nil) {
        
        service=[[ConstantLineServices alloc] init];
    }
    offset=0;
    
    checkAddress=TRUE;
    checkTablePosition=@"YES";
    page=1;
    
    objImageCache=[[ImageCache alloc] init];
    objImageCache.delegate=self;
    
    [self setRequestValue];
    
    checkHoldTalkPressed=TRUE;
    
    checkDisapper=TRUE;
    checkPN=@"YES";
    
    if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
        
        [requestView setHidden:FALSE];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,430)];
                
                [AudioView setFrame:CGRectMake(0, 467, AudioView.frame.size.width, AudioView.frame.size.height)];

                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,430-IPHONE_FIVE_FACTOR)];
                
                [AudioView setFrame:CGRectMake(0, 467-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];

                
            }
            
        }
        else{
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,380)];
                
                [AudioView setFrame:CGRectMake(0, 379, AudioView.frame.size.width, AudioView.frame.size.height)];

                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,380-IPHONE_FIVE_FACTOR)];
                
                [AudioView setFrame:CGRectMake(0, 379-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];

                
            }
        }
        
        
    }
    else
    {
        [requestView setHidden:TRUE];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,460)];
                
                [AudioView setFrame:CGRectMake(0, 467, AudioView.frame.size.width, AudioView.frame.size.height)];
                
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,460-IPHONE_FIVE_FACTOR)];
                
                [AudioView setFrame:CGRectMake(0, 467-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                
                
            }
            
        }
        else{
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,380)];
                
                [AudioView setFrame:CGRectMake(0, 379, AudioView.frame.size.width, AudioView.frame.size.height)];
                
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,380-IPHONE_FIVE_FACTOR)];
                
                [AudioView setFrame:CGRectMake(0, 379-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                
                
            }
        }
        
    }
    
    btnAudio.tag=0;
    
    font=[UIFont fontWithName:ARIALFONT_BOLD size:14.0];
    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    navigation=self.navigationController.navigationBar;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    
    
    if ([[AppDelegate sharedAppDelegate].checkNameCard isEqualToString:@"YES"])
    {
        
        [self performSelectorOnMainThread:@selector(SendChatOnLocalDB:) withObject:[[NSMutableArray alloc]initWithObjects:[AppDelegate sharedAppDelegate].nameCardId,@"4", nil] waitUntilDone:YES];
        
    }
    
    if ([[AppDelegate sharedAppDelegate].checkaddressContact isEqualToString:@"YES"]) {
        
        [AppDelegate sharedAppDelegate].checkaddressContact=@"NO";
        
        [self.textView becomeFirstResponder];
        
        self.textView.text=[NSString stringWithFormat:@"%@%@%@",self.textView.text,[AppDelegate sharedAppDelegate].addressContactName,@" "];
    }
    
    [AppDelegate sharedAppDelegate].checkNameCard=@"NO";
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] hidetabbar];
}

- (void)didReceiveBackgroundNotification:(NSNotification*) note{
    
    if ([checkPN isEqualToString:@"YES"]) {
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            NSDictionary* notification = (NSDictionary*)[note object];
            
            NSString* nType = [notification valueForKeyPath:@"aps.type"];
            
            if ([nType isEqualToString:@"chat"] || [nType isEqualToString:@"groupchat"]) {
                
                page=1;
                checkTablePosition=@"YES";
                
                if ([AppDelegate sharedAppDelegate].chatNotificationCount>0) {
                    
                    [AppDelegate sharedAppDelegate].chatNotificationCount=[AppDelegate sharedAppDelegate].chatNotificationCount-1;
                }
                
                UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
                tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[AppDelegate sharedAppDelegate].chatNotificationCount];
                
                NSLog(@"dgdfg %d",[AppDelegate sharedAppDelegate].chatNotificationCount);
                
                if ([AppDelegate sharedAppDelegate].chatNotificationCount==0) {
                    
                    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                    
                }
                
                if ([self.groupType isEqualToString:@"0"]) {
                    
                    NSString* nUserId = [notification valueForKeyPath:@"aps.senderId"];
                    
                    if ([nUserId isEqualToString:self.friendId]) {
                        
                        
                        [self parseChat];
                    }
                    
                    
                }
                
                else
                {
                    
                    NSString* nUserId = [notification valueForKeyPath:@"aps.groupId"];
                    
                    if ([nUserId isEqualToString:self.groupId]) {
                        
                        [self parseChat];
                    }
                    
                }
            }
            
            
            
        }
        
    }
}
-(void)parseChat
{
    
    if ([self.lastMsgId length]>0 && [self.checkType isEqualToString:@""]) {
        
        [AppDelegate sharedAppDelegate].chatDetailType=@"new";
        
    }
    else
    {
        [AppDelegate sharedAppDelegate].chatDetailType=@"old";
    }
    
    if ([self.checkType isEqualToString:@""]) {
        
        [AppDelegate sharedAppDelegate].chatDetailType=@"new";
        
    }
    else
    {
        [AppDelegate sharedAppDelegate].chatDetailType=@"old";
        
    }
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue,
                       ^{
                           
                           dispatch_sync(dispatch_get_main_queue(),
                                         ^{
                                             NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                                             
                                             [service ChatDetailInvocation:gUserId friendId:self.friendId lastmsgId:self.lastMsgId type:[AppDelegate sharedAppDelegate].chatDetailType groupType:self.groupType groupId:self.groupId page:pageStr delegate:self];
                                             
                                         });
                       });
        

       
        
    }
    
}
- (void)didReceiveForgroundNotification:(NSNotification*) note
{

    if ([checkPN isEqualToString:@"YES"]) {
        
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            
            if ([self.lastMsgId length]>0 && [self.checkType isEqualToString:@""]) {
                
                [AppDelegate sharedAppDelegate].chatDetailType=@"new";
                
            }
            else
            {
                [AppDelegate sharedAppDelegate].chatDetailType=@"old";
            }
            
            
            
            NSString *pageStr=[NSString stringWithFormat:@"%d",page];
            
          
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            [service ChatDetailInvocation:gUserId friendId:self.friendId lastmsgId:self.lastMsgId type:[AppDelegate sharedAppDelegate].chatDetailType groupType:self.groupType groupId:self.groupId page:pageStr delegate:self];
            
            
            
            
        }
    }
}

-(void)backButtonClick:(UIButton *)sender{
    
    if (moveTabG==FALSE) {
        
        self.textView.text=@"";
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(IBAction)infoButtonClick:(id)sender
{
    if (moveTabG==FALSE) {
        
        if ([self.groupType isEqualToString:@"0"]) {
            
            if ([self.friendId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=friendId;
                objProfileViewController.navTitle=self.friendUserName;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
            }
            else
            {
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=friendId;
                objFriendProfileViewController.navTitle=self.friendUserName;
                objFriendProfileViewController.checkView=@"ShowClearButton";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
            }
            
        }
        else
        {
            GroupInfoViewController *objGroupInfoViewController;
            
            objGroupInfoViewController=[[GroupInfoViewController alloc] initWithNibName:@"GroupInfoViewController" bundle:nil];
            
            objGroupInfoViewController.groupId=self.groupId;
            objGroupInfoViewController.joinStatus=@"1";
            objGroupInfoViewController.subscriptionStatus=@"1";
            
            [self.navigationController pushViewController:objGroupInfoViewController animated:YES];
            [objGroupInfoViewController release];
            
        }
        
    }
    
}

-(IBAction)btnKeyboardPressed:(id)sender
{
   // if (moveTabG==FALSE) {

    if (btnKeyboard.tag==0) {
        
        [btnKeyboard setTag:1];
        self.textView.text=@"";
        [btnHoldToTalk setHidden:FALSE];
        [self.textView resignFirstResponder];
        [btnKeyboard setBackgroundImage:[UIImage imageNamed:@"ToolViewInputText"] forState:UIControlStateNormal];
        
        
    }
    else
    {
        [btnKeyboard setTag:0];
        
        [btnHoldToTalk setHidden:TRUE];
        [self.textView becomeFirstResponder];
        [btnKeyboard setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        
    }
        
   // }
}

/*-(IBAction)plusBtnPressed:(id)sender
{
    [self.textView resignFirstResponder];
    
    
    if (PlusBtn.tag==0) {
        
        [PlusBtn setTag:1];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, self.view.frame.size.height-151, containerView.frame.size.width, containerView.frame.size.height)];
                
                [AudioView setFrame:CGRectMake(0, self.view.frame.size.height-101, AudioView.frame.size.width, AudioView.frame.size.height)];
            }
            else
            {
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, self.view.frame.size.height-151, containerView.frame.size.width, containerView.frame.size.height)];
                
                [AudioView setFrame:CGRectMake(0, self.view.frame.size.height-101, AudioView.frame.size.width, AudioView.frame.size.height)];
            }

            
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, self.view.frame.size.height-151, containerView.frame.size.width, containerView.frame.size.height)];
                
                [AudioView setFrame:CGRectMake(0, self.view.frame.size.height-101, AudioView.frame.size.width, AudioView.frame.size.height)];
            }
            else
            {
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, self.view.frame.size.height-151, containerView.frame.size.width, containerView.frame.size.height)];
                
                [AudioView setFrame:CGRectMake(0, self.view.frame.size.height-101, AudioView.frame.size.width, AudioView.frame.size.height)];
            }
            
        }
        if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-250,self.view.frame.size.width, 470+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-250,self.view.frame.size.width, 470)];
                    
                }
                
                
            }
            else{
                
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+240,self.view.frame.size.width, 335+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+240,self.view.frame.size.width, 335)];
                    
                }
                
            }
            
        }
        else
        {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+200,self.view.frame.size.width, 400+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+110,self.view.frame.size.width, 400)];
                    
                }
                
            }
            else{
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+140,self.view.frame.size.width, 430+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+140,self.view.frame.size.width, 430)];
                    
                }
                
            }
        }
        
        
        [self.view addSubview:AudioView];
        
        [AudioView setHidden:FALSE];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationCurve:2.0];
        
        [UIView commitAnimations];
        
        self.checkScroll=@"NO";
        
    }
    else
    {
        [PlusBtn setTag:0];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
                
            }
            else
            {
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
                
            }
            
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
                
            }
            else
            {
                [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
                
            }
            
        }
        
        
        if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328)];
                    
                }
                
            }
            else
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328)];
                    
                }
            }
            
        }
        else
        {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365)];
                    
                }
                
            }
            else
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365+IPHONE_FIVE_FACTOR)];
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365)];
                    
                }
            }
        }
        
        [AudioView setHidden:TRUE];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationCurve:2.0];
        
        [UIView commitAnimations];
        
        self.checkScroll=@"YES";
        
        [self scrollToNewestMessage];
        
        
    }
        
    
}*/

-(IBAction)plusBtnPressed:(id)sender
{
    if (PlusBtn.tag==0) {
        
        [PlusBtn setTag:1];
        
        self.textView.text=@"";
        [containerView setHidden:TRUE];
        [AudioView setHidden:FALSE];
        [self.textView resignFirstResponder];
    }
    else
    {
        [PlusBtn setTag:0];
        
        [containerView setHidden:FALSE];
        [AudioView setHidden:TRUE];

    }
}
-(IBAction)editIconBtnPressed:(id)sender
{
    [self.textView becomeFirstResponder];
    
}
-(void)setRequestValue
{
    
    if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
        
        [requestView setHidden:FALSE];
        
        [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:self.friendUserName];

        
        if ([[AppDelegate sharedAppDelegate].friendStatus isEqualToString:@"0"]) {
            
            [lblFriendName setHidden:TRUE];
            [imgFriendimage setHidden:TRUE];
            [btnProfile setHidden:TRUE];
            [deviderImgView setHidden:FALSE];
            
            [addButton setHidden:FALSE];
            [blockButton setHidden:FALSE];
            
            
            [blockButton setFrame:CGRectMake(60, 5, 63, 24)];
            
            
            if ([self.blockStatus isEqualToString:@"0"]) {
                
                [blockButton setTitle:@"Block" forState:UIControlStateNormal];
                [blockButton setTag:0];
            }
            else
            {
                [blockButton setTitle:@"Unblock" forState:UIControlStateNormal];
                [blockButton setTag:1];
                
            }
            
        }
        else
        {
            [lblFriendName setText:self.friendUserName];
            imgFriendimage.layer.cornerRadius =15;
            imgFriendimage.clipsToBounds = YES;
            imgFriendimage.layer.borderWidth=2.0;
            imgFriendimage.layer.borderColor=[[UIColor whiteColor]CGColor];
            [deviderImgView setHidden:TRUE];
            
            [lblFriendName setHidden:FALSE];
            [imgFriendimage setHidden:FALSE];
            [btnProfile setHidden:FALSE];
            
            [blockButton setHidden:FALSE];
            [addButton setHidden:TRUE];
            
            [blockButton setFrame:CGRectMake(255, 5, 63, 24)];
            
            if ([self.blockStatus isEqualToString:@"0"]) {
                
                [blockButton setTitle:@"Block" forState:UIControlStateNormal];
                [blockButton setTag:0];
                
            }
            else
            {
                [blockButton setTitle:@"Unblock" forState:UIControlStateNormal];
                [blockButton setTag:1];
                
            }
        }
        
        [self performSelectorOnMainThread:@selector(setRequestUserImage) withObject:nil waitUntilDone:YES];
    }
    
    else
    {
     
        if (![self.groupTitle isEqualToString:@""]) {
            
              [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:self.groupTitle];
        }
      

        [requestView setHidden:TRUE];
    }
    
}

-(void)setRequestUserImage
{
    
    if (self.friendUserImage==nil || self.friendUserImage==(NSString *)[NSNull null] || [self.friendUserImage isEqualToString:@""]) {
        
        [imgFriendimage setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        NSLog(@"%@",self.friendUserImage);
        
        UIImage *img = [objImageCache iconForUrl:self.friendUserImage];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:self.friendUserImage withSize:kImgSize_1 forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        
        else {
            
            [imgFriendimage setImage:img];
        }
        
        
    }
    
}
#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrChatData count];
    
    return rowCount;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height=0;
    
    ChatDetailData *temp=[self.arrChatData objectAtIndex:indexPath.row];
    
    if ([temp.staticMessage isEqualToString:@"1"]) {
        
        if ([temp.requestStatus isEqualToString:@"1"]) {
            
            if (temp.cellHeight<=40) {
                
                height=90;
            }
            else
            {
                if (temp.cellHeight>140) {
                    
                    height=temp.cellHeight+100;
                    
                }
                
                else if (temp.cellHeight>90) {
                    
                    height=temp.cellHeight+70;
                    
                }
                else if (temp.cellHeight>70) {
                    
                    height=temp.cellHeight+50;
                    
                }
                else
                {
                    height=temp.cellHeight+20;
                    
                }
                
                
            }
            
        }
        else
        {
            height=30;
        }
        
        
    }
    else
    {
        if ([temp.chatType isEqualToString:@"1"]) {
            
            if (temp.cellHeight<=40) {
                
                height=80;
            }
            else
            {
            
                NSLog(@"%f",temp.cellHeight);
                
                if (temp.cellHeight<75) {
                   
                    height=temp.cellHeight+50;

                }
                else
                {
                    height=temp.cellHeight+70;

                }
                
            }
            
        }
        else if ([temp.chatType isEqualToString:@"2"])
        {
            height=170;
        }
        else if ([temp.chatType isEqualToString:@"3"])
        {
            height=90;
        }
        else if ([temp.chatType isEqualToString:@"4"])
        {
            height=105;
        }
        
    }
    
    
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tblView.dragging==YES) {
        
        self.checkScroll=@"YES";
        
        if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
            
            [requestView setHidden:FALSE];
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,430)];
                    
                    [AudioView setFrame:CGRectMake(0, 467, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,430-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 467-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                
            }
            else{
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,380)];
                    
                    [AudioView setFrame:CGRectMake(0, 379, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,380-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 379-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
            }
            
            
        }

        else
        {
            [requestView setHidden:TRUE];
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,460)];
                    
                    [AudioView setFrame:CGRectMake(0, 467, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,460-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 467-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                
            }
            else{
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,380)];
                    
                    [AudioView setFrame:CGRectMake(0, 379, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,380-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 379-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
            }
            
        }
        [self.textView resignFirstResponder];
        
    }
    
    static NSString *cellIdentifier=@"Cell";
    static NSString *cellTextuserIdentifier=@"TextUserCell";
    static NSString *cellImageIdentifier=@"ImageCell";
    static NSString *cellImageUserIdentifier=@"ImageuserCell";
    static NSString *cellAudioIdentifier=@"AudioCell";
    static NSString *cellAudioUserIdentifier=@"AudioUserCell";
    static NSString *cellNameCardIdentifier=@"NameCardCell";
    static NSString *cellNameCardUserIdentifier=@"nameCardUserCell";
    static NSString *cellStaticIdentifier=@"staticCell";
    static NSString *cellRequestIdentifier=@"requestCell";
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if ([data.staticMessage isEqualToString:@"1"]) {
        
        if ([data.requestStatus isEqualToString:@"1"]) {
            
            requestCell = (ChatRequestTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellRequestIdentifier];
            
            if (requestCell==nil)
            {
                requestCell = [ChatRequestTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            [requestCell setBackgroundColor:[UIColor clearColor]];
            
            [self CreateChatTableRequestVIew:requestCell AtIndex:indexPath];
            
            return requestCell;
            
            
            
        }
        else
        {
            staticCell = (ChatStaticTextTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellStaticIdentifier];
            
            if (staticCell==nil)
            {
                staticCell = [ChatStaticTextTableViewCell createTextRowWithOwner:self withDelegate:self];
            }
            
            [staticCell setBackgroundColor:[UIColor clearColor]];
            
            CGSize size = [data.message sizeWithFont:[UIFont fontWithName:ARIALFONT size:11] constrainedToSize:CGSizeMake(200, 20)];
            
            [staticCell.lblMessage setFrame:CGRectMake(staticCell.frame.origin.x, staticCell.lblMessage.frame.origin.y, size.width+20, staticCell.lblMessage.frame.size.height)];
            
            [staticCell.lblMessage setCenter:CGPointMake(self.view.center.x,staticCell.lblMessage.frame.origin.y+10)];
            
            [staticCell.lblMessage setText:data.message];
            
            return staticCell;
            
        }
        
    }
    else
    {
        if ([data.chatType isEqualToString:@"1"] || [data.chatType isEqualToString:@"5"]) {
            
            cell = (ChatTextTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (![gUserId isEqualToString:data.userId]) {
                
                if (cell==nil)
                {
                    cell = [ChatTextTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [cell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTableTextVIew:cell AtIndex:indexPath];
                
                
                return cell;
                
            }
            else
            {
                
                textUserCell = (ChatTextUserTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellTextuserIdentifier];
                
                if (textUserCell==nil)
                {
                    
                    textUserCell = [ChatTextUserTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [textUserCell setBackgroundColor:[UIColor clearColor]];
                
               // [textUserCell.lblMessage setBackgroundColor:[UIColor redColor]];
               // [textUserCell.lblDate setBackgroundColor:[UIColor blueColor]];

                
                [self CreateChatTableTextUserVIew:textUserCell AtIndex:indexPath];
                
                return textUserCell;
                
            }
            
        }
        if([data.chatType isEqualToString:@"2"])
        {
            
            
            imageCell = (ChatImageTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellImageIdentifier];
            
            if (![gUserId isEqualToString:data.userId]) {
                
                if (imageCell==nil)
                {
                    imageCell = [ChatImageTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                
                [imageCell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTableImageVIew:imageCell AtIndex:indexPath];
                
                return imageCell;
                
            }
            else
            {
                imageUserCell = (ChatImageUserTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellImageUserIdentifier];
                
                if (imageUserCell==nil)
                {
                    imageUserCell = [ChatImageUserTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [imageUserCell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTableImageUserVIew:imageUserCell AtIndex:indexPath];
                
                
                
                return imageUserCell;
                
            }
        }
        else if([data.chatType isEqualToString:@"3"])
        {
            
            if (![gUserId isEqualToString:data.userId]) {
                
                audioCell = (ChatAudioTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellAudioIdentifier];
                
                if (audioCell==nil)
                {
                    audioCell = [ChatAudioTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [audioCell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTableAudioVIew:audioCell AtIndex:indexPath];
                
                return audioCell;
            }
            else
            {
                
                audioUserCell = (ChatAudioUserTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellAudioUserIdentifier];
                
                if (audioUserCell==nil)
                {
                    audioUserCell = [ChatAudioUserTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [audioUserCell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTablAudioUsereVIew:audioUserCell AtIndex:indexPath];
                
                return audioUserCell;
            }
        }
        else if([data.chatType isEqualToString:@"4"])
        {
            if (![gUserId isEqualToString:data.userId]) {
                
                nameCardCell = (ChatNameCardTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellNameCardIdentifier];
                
                if (nameCardCell==nil)
                {
                    nameCardCell = [ChatNameCardTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [nameCardCell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTableNameCardVIew:nameCardCell AtIndex:indexPath];
                
                return nameCardCell;
            }
            else
            {
                
                nameCarduserCell = (ChatNameCardUserTableViewCell*)[tblView dequeueReusableCellWithIdentifier:cellNameCardUserIdentifier];
                
                if (nameCarduserCell==nil)
                {
                    nameCarduserCell = [ChatNameCardUserTableViewCell createTextRowWithOwner:self withDelegate:self];
                }
                [nameCarduserCell setBackgroundColor:[UIColor clearColor]];
                
                [self CreateChatTablNameCardUserVIew:nameCarduserCell AtIndex:indexPath];
                
                return nameCarduserCell;
            }
        }
    }
    
    
}

-(void)CreateChatTableTextVIew:(ChatTextTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    customCell.lblName.text= data.name;
    customCell.lblDate.text=data.date;
    
    [customCell.lblMessage setFont:[UIFont fontWithName:ARIALFONT_BOLD size:14.0]];
    
    //CGSize randomSizeFortext=[self sizeForText:data.message];
    
    customCell.lblMessage.text=data.message;
    
    NSString *text=@"";
    text= getStringAfterTriming(data.message);
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(216,130000)lineBreakMode:NSLineBreakByWordWrapping];
    
    

    [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,size.height+20)];
    
    [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,size.height+40)];
    
    [customCell.lblDate setFrame:CGRectMake(customCell.lblDate.frame.origin.x,customCell.imgBackView.frame.size.height+customCell.imgBackView.frame.origin.y+5,customCell.lblDate.frame.size.width,customCell.lblDate.frame.size.height)];

    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressProfileImage:)];
        longPressProfileImage.cancelsTouchesInView = NO;
        
        [customCell.btnProfileImage addGestureRecognizer:longPressProfileImage];
        
    }
    
    //[customCell setBackgroundColor:[UIColor redColor]];
   // [customCell.lblMessage setBackgroundColor:[UIColor redColor]];

  /*  if (randomSizeFortext.height>120) {
        
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+70)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+100)];
        
        
    }
    else if (randomSizeFortext.height>70) {
        
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+30)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+70)];
        
        
    }
    else if (randomSizeFortext.height>50) {
        
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+30)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+50)];
        
        
    }
    else
    {
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+20)];
        
        
    }
    */
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        NSLog(@"data.image %@",data.image);
        
        if (data.image && [data.image length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:data.image];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(80, 80);
                }
                else{
                    kImgSize_1=CGSizeMake(80*2, 80*2);
                }
                
                [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
                
            }
            
            else {
                
                [customCell.imgView setImage:img];
            }
            
        }
        
    }
    
    
}
-(void)CreateChatTableTextUserVIew:(ChatTextUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    customCell.lblDate.text=data.date;
    
    [customCell.lblMessage setFont:[UIFont fontWithName:ARIALFONT_BOLD size:14.0]];
    
   // CGSize randomSizeFortext=[self sizeForText:data.message];
    
    customCell.lblMessage.text=data.message;
    
    NSString *text=@"";
    text= getStringAfterTriming(data.message);
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(216,130000)lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"%f",size.height);
    
    if (size.height<55) {
     
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,size.height+20)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,size.height+40)];
        
        [customCell.lblDate setFrame:CGRectMake(customCell.lblDate.frame.origin.x,customCell.imgBackView.frame.size.height+customCell.imgBackView.frame.origin.y,customCell.lblDate.frame.size.width,customCell.lblDate.frame.size.height)];

    }
    else
    {
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,size.height+40)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,size.height+60)];
        
        [customCell.lblDate setFrame:CGRectMake(customCell.lblDate.frame.origin.x,customCell.imgBackView.frame.size.height+customCell.imgBackView.frame.origin.y,customCell.lblDate.frame.size.width,customCell.lblDate.frame.size.height)];

    }
    
  
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressUserProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressUserProfileImage:)];
        longPressUserProfileImage.cancelsTouchesInView = NO;
        
        [customCell.btnProfileImage addGestureRecognizer:longPressUserProfileImage];
        
    }
    
   /* if (randomSizeFortext.height>120) {
        
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+70)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+100)];
        
        
    }
    else if (randomSizeFortext.height>70) {
        
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+30)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+70)];
        
        
    }
    else if (randomSizeFortext.height>50) {
        
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+30)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+50)];
        
        
    }
    else
    {
        [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height)];
        
        [customCell.imgBackView setFrame:CGRectMake(customCell.imgBackView.frame.origin.x,customCell.imgBackView.frame.origin.y,customCell.imgBackView.frame.size.width,randomSizeFortext.height+20)];
        
        
    }
    */
  
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        
    }
    else
    {
        
        if (data.image && [data.image length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:data.image];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(80, 80);
                }
                else{
                    kImgSize_1=CGSizeMake(80*2, 80*2);
                }
                
                [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
                
                
            }
            
            else {
                
                [customCell.imgView setImage:img];
            }
            
        }
        
        
    }
}
-(void)CreateChatTableImageVIew:(ChatImageTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    
    customCell.lblName.text= data.name;
    customCell.lblDate.text=data.date;
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressProfileImage:)];
        longPressProfileImage.cancelsTouchesInView = NO;
        [customCell.btnProfileImage addGestureRecognizer:longPressProfileImage];
        
    }
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        UIImage *img = [objImageCache iconForUrl:data.image];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
            
            
        }
        
        else {
            
            [customCell.imgView setImage:img];
        }
        
    }
    if (data.postImageUrl==nil || data.postImageUrl==(NSString *)[NSNull null] || [data.postImageUrl isEqualToString:@""]) {
        
        [customCell.imgPostImage setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        NSString *postImageStr=[[data.postImageUrl copy] autorelease];
        
        [customCell.imgPostImage setImage:[UIImage imageWithContentsOfFile:postImageStr]];
        
    }
    
}
-(void)CreateChatTableImageUserVIew:(ChatImageUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressUserProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressUserProfileImage:)];
        longPressUserProfileImage.cancelsTouchesInView = NO;
        
        [customCell.btnProfileImage addGestureRecognizer:longPressUserProfileImage];
        
    }
    customCell.lblDate.text=data.date;
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
    }
    else
    {
        
        UIImage *img = [objImageCache iconForUrl:data.image];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
        }
        
        else {
            
            [customCell.imgView setImage:img];
        }
    }
    
    
    if (data.postImageUrl==nil || data.postImageUrl==(NSString *)[NSNull null] || [data.postImageUrl isEqualToString:@""]) {
        
    }
    else
    {
        
        NSString *postImageStr=[[data.postImageUrl copy] autorelease];
        
        [customCell.imgPostImage setImage:[UIImage imageWithContentsOfFile:postImageStr]];
        
        
    }
    
}
-(void)CreateChatTableAudioVIew:(ChatAudioTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    customCell.lblDate.text=data.date;
    customCell.lblName.text=data.name;
    customCell.lblDuration.text=data.audioDuration;
    
    customCell.audioSlider.enabled = NO;

    if (indexPath==selectedRowIndexPath) {
        
        [customCell.btnChatMessage setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
        
        customCell.audioSlider.value=0.0;
    }
    
    [customCell.btnChatMessage setTitle:data.postAudioUrl forState:UIControlStateReserved];
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressProfileImage:)];
        longPressProfileImage.cancelsTouchesInView = NO;
        [customCell.btnProfileImage addGestureRecognizer:longPressProfileImage];
        
    }
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        UIImage *img = [objImageCache iconForUrl:data.image];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
            
            
        }
        
        else {
            
            [customCell.imgView setImage:img];
        }
    }
    
    
}
-(void)CreateChatTablAudioUsereVIew:(ChatAudioUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    [customCell.btnChatMessage setTitle:data.postAudioUrl forState:UIControlStateReserved];
    customCell.lblDate.text=data.date;
    customCell.lblDuration.text=data.audioDuration;

    customCell.audioSlider.enabled = NO;

   
    if (indexPath==selectedRowIndexPath) {
        
        [customCell.btnChatMessage setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
        
        customCell.audioSlider.value=0.0;
    }
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressUserProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressUserProfileImage:)];
        longPressUserProfileImage.cancelsTouchesInView = NO;
        
        [customCell.btnProfileImage addGestureRecognizer:longPressUserProfileImage];
        
    }
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        UIImage *img = [objImageCache iconForUrl:data.image];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
            
            
        }
        
        else {
            
            [customCell.imgView setImage:img];
        }
        
    }
    
}
-(void)CreateChatTableNameCardVIew:(ChatNameCardTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    customCell.lblName.text= data.name;
    customCell.lblDate.text=data.date;
    customCell.lblMessage.text=[data.message capitalizedString];
    customCell.lblNameCardName.text=data.nameCardName;
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressProfileImage:)];
        longPressProfileImage.cancelsTouchesInView = NO;
        [customCell.btnProfileImage addGestureRecognizer:longPressProfileImage];
        
    }
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
    }
    else
    {
        
        UIImage *img = [objImageCache iconForUrl:data.image];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
            
        }
        
        else {
            
            [customCell.imgView setImage:img];
        }
    }
    
    
    if (data.nameCardImage==nil || data.nameCardImage==(NSString *)[NSNull null] || [data.nameCardImage isEqualToString:@""]) {
        
        [customCell.imgNameCard setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        
        UIImage *img = [objImageCache iconForUrl:data.nameCardImage];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.nameCardImage withSize:kImgSize_1 forIndexPath:indexPath];
            
        }
        
        else {
            
            [customCell.imgNameCard setImage:img];
        }
        
        
        
    }
    
    
}
-(void)CreateChatTablNameCardUserVIew:(ChatNameCardUserTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    
    customCell.lblDate.text=data.date;
    customCell.lblMessage.text=[data.message capitalizedString];
    customCell.lblNameCardName.text=data.nameCardName;
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        longPressUserProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressUserProfileImage:)];
        longPressUserProfileImage.cancelsTouchesInView = NO;
        
        [customCell.btnProfileImage addGestureRecognizer:longPressUserProfileImage];
        
    }
    
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        UIImage *img = [objImageCache iconForUrl:data.image];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
            
            
        }
        
        else {
            
            [customCell.imgView setImage:img];
            
            
        }
        
        
    }
    
    if (data.nameCardImage==nil || data.nameCardImage==(NSString *)[NSNull null] || [data.nameCardImage isEqualToString:@""]) {
        
        
        [customCell.imgNameCard setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    }
    else
    {
        
        UIImage *img = [objImageCache iconForUrl:data.nameCardImage];
        
        if (img == Nil) {
            
            CGSize kImgSize_1;
            if ([[UIScreen mainScreen] scale] == 1.0)
            {
                kImgSize_1=CGSizeMake(80, 80);
            }
            else{
                kImgSize_1=CGSizeMake(80*2, 80*2);
            }
            
            [objImageCache startDownloadForUrl:data.nameCardImage withSize:kImgSize_1 forIndexPath:indexPath];
            
        }
        
        else {
            
            [customCell.imgNameCard setImage:img];
        }
        
        
        
        
    }
    
    
}
-(void)CreateChatTableRequestVIew:(ChatRequestTableViewCell *)customCell AtIndex:(NSIndexPath *)indexPath
{
    {
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        customCell.lblName.text= data.name;
        
        [customCell.lblMessage setFont:[UIFont fontWithName:ARIALFONT_BOLD size:12.0]];
        
        CGSize randomSizeFortext=[self sizeForText:data.message];
        
        customCell.lblMessage.numberOfLines=0;
        customCell.lblMessage.lineBreakMode=NSLineBreakByWordWrapping;
        customCell.lblMessage.text=data.message;
        
        if ([self.groupType isEqualToString:@"1"]) {
            
            longPressProfileImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressProfileImage:)];
            longPressProfileImage.cancelsTouchesInView = NO;
            
            [customCell.btnProfileImage addGestureRecognizer:longPressProfileImage];
            
            
        }
        
        
        if (randomSizeFortext.height>120) {
            
            [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+80)];
            
        }
        else if (randomSizeFortext.height>70) {
            
            [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height+20)];
            
        }
        
        else
        {
            [customCell.lblMessage setFrame:CGRectMake(customCell.lblMessage.frame.origin.x,customCell.lblMessage.frame.origin.y,customCell.lblMessage.frame.size.width,randomSizeFortext.height)];
            
        }
        
        
        
        CGSize randomSizeForImage=[self sizeForImage:randomSizeFortext];
        
        if (randomSizeForImage.height>150) {
            
            
            [customCell.btnChatMessage setFrame:CGRectMake(customCell.btnChatMessage.frame.origin.x,customCell.btnChatMessage.frame.origin.y,customCell.btnChatMessage.frame.size.width,randomSizeForImage.height+100)];
            
        }
        
        else if (randomSizeForImage.height>90) {
            
            
            [customCell.btnChatMessage setFrame:CGRectMake(customCell.btnChatMessage.frame.origin.x,customCell.btnChatMessage.frame.origin.y,customCell.btnChatMessage.frame.size.width,randomSizeForImage.height+30)];
            
        }
        
        else
        {
            [customCell.btnChatMessage setFrame:CGRectMake(customCell.btnChatMessage.frame.origin.x,customCell.btnChatMessage.frame.origin.y,customCell.btnChatMessage.frame.size.width,randomSizeForImage.height)];
            
        }
        
        [customCell.btnReject setFrame:CGRectMake(238, 36, 60, 20)];
        
        if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
            
            [customCell.imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
            
        }
        else
        {
            if (data.image && [data.image length] > 0) {
                
                UIImage *img = [objImageCache iconForUrl:data.image];
                
                if (img == Nil) {
                    
                    CGSize kImgSize_1;
                    if ([[UIScreen mainScreen] scale] == 1.0)
                    {
                        kImgSize_1=CGSizeMake(80, 80);
                    }
                    else{
                        kImgSize_1=CGSizeMake(80*2, 80*2);
                    }
                    
                    [objImageCache startDownloadForUrl:data.image withSize:kImgSize_1 forIndexPath:indexPath];
                    
                }
                
                else {
                    
                    [customCell.imgView setImage:img];
                }
                
            }
            
        }
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self setRequestUserImage];
    [tblView reloadData];
}
#pragma mark Edit Table delegate method

#pragma mark...........
#pragma calculate size methods

- (CGSize)sizeForText:(NSString*)text
{
	CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(getFloatX(WrapWidth),9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;
    
	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;
    
	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;
    
	bubbleSize.width = 240;
	bubbleSize.height +=VertPadding*2;
    
	return bubbleSize;
}

- (CGSize)sizeForImage:(CGSize)textSize
{
    
	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;
	
	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;
	
	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;
	
	bubbleSize.width += HorzPadding*2;
	bubbleSize.height += VertPadding*2;
	
	return bubbleSize;
}


#pragma --------
#pragma IBAction method

-(IBAction)btnAddPressed:(id)sender
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        addContactAlert = [[UIAlertView alloc] initWithTitle:@"Tell your new friend why you 2 should be connected"
                                                     message:Nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Continue", nil];
        
        alertTextField = [[UITextView alloc]
                          initWithFrame:CGRectMake(20.0, 30.0, 245.0, 60.0)];
        [alertTextField setBackgroundColor:[UIColor whiteColor]];
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        alertTextField.keyboardType=UIKeyboardTypeDefault;
        alertTextField.delegate=self;
        [alertTextField setFont:[UIFont systemFontOfSize:15]];
        [addContactAlert setValue:alertTextField forKey:@"accessoryView"];
        [alertTextField release];
        [addContactAlert show];
        [addContactAlert release];
        
    }
    else
    {
        
        addContactAlert = [[UIAlertView alloc] initWithTitle:@"Tell your new friend why you 2 should be connected" message:@"                                                                                    " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        
        [addContactAlert setFrame:CGRectMake(addContactAlert.frame.origin.x, addContactAlert.frame.origin.y, addContactAlert.frame.size.width, 400)];
        
        alertTextField= [[UITextView alloc] initWithFrame:CGRectMake(20.0, 60, 245.0, 40.0)];
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        alertTextField.keyboardType=UIKeyboardTypeDefault;
        alertTextField.delegate=self;
        [alertTextField setBackgroundColor:[UIColor whiteColor]];
        [alertTextField setFont:[UIFont systemFontOfSize:15]];

        [addContactAlert addSubview:alertTextField];
        [addContactAlert show];
        [addContactAlert release];
    }
    
    
    
}

#pragma Mark Delegate
#pragma Mark UIAlertview delegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==addContactAlert) {
        
        if (buttonIndex==1) {
            
            //NSString *inputText = [[addContactAlert textFieldAtIndex:0] text];
            NSString *inputText = alertTextField.text;

            if ([inputText length]>0) {
                
                int status=[[AppDelegate sharedAppDelegate] netStatus];
                
                if(status==0)
                {
                    if (service!=nil) {
                        service=nil;
                    }
                    service=[[ConstantLineServices alloc] init];
                    
                    NSString *base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                  NULL,
                                                                                                  (CFStringRef)inputText,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                  kCFStringEncodingUTF8 ) autorelease];
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [service AddContactListInvocation:gUserId friendId:self.friendId intro:base64String delegate:self];
                    
                    
                }
                
            }
            
        }
        
    }
    
    if (alertView==blockAlert) {
        
        if (buttonIndex==1) {
            
            if (blockButton.tag==0) {
                
                blockStr=@"1";
                
                [blockButton setTag:1];
                
            }
            else
            {
                blockStr=@"0";
                [blockButton setTag:0];
            }
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [service BlockInvocation:gUserId friendId:self.friendId blockType:blockStr delegate:self];
            }

        }
    }
}
-(BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range1 replacementText:(NSString *)text
{
    
    NSString *newText = [txtView.text stringByReplacingCharactersInRange:range1 withString:text];
    
    NSLog(@"input %d chars", newText.length);
    
    totalCharacterCount=80-newText.length;
    
    if (totalCharacterCount>=0 && totalCharacterCount<=80) {
        
        if ([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            
            
        }
        return YES;
        
    }else{
        if ([text isEqualToString:@"\n"])
        {
            
            [textView resignFirstResponder];
            
            
        }
        return NO;
    }
    
    
	return YES;
    
}
/*- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView!=blockAlert) {
        
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 && [inputText length]<=80)
        {
            return YES;
        }
        else
        {
            return NO;
        }

    }
    return YES;

}*/
-(IBAction)btnBlockPressed:(id)sender
{
    NSString *blockMsg=@"";
    
    if (blockButton.tag==0) {
        
        blockMsg=@"Block this user?";
    }
    else
    {
        blockMsg=@"Unblock this user?";

    }

    blockAlert=[[UIAlertView alloc] initWithTitle:nil message:blockMsg delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [blockAlert show];
    [blockAlert release];
    
    }
-(IBAction)btnEditPressed:(id)sender
{
    if (self.editing) {
		[super setEditing:NO animated:NO];
        [btnEdit setTitle:@"Edit Message" forState:UIControlStateNormal];
		[tblView setEditing:NO animated:NO];
		[tblView reloadData];
	}
	else {
		[super setEditing:YES animated:YES];
        [btnEdit setTitle:@"Done Message" forState:UIControlStateNormal];
		[tblView setEditing:YES animated:YES];
		[tblView reloadData];
	}
    
}
-(IBAction)profileBtnPressed:(id)sender
{
    if ([self.friendId isEqualToString:gUserId]) {
        
        objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        
        objProfileViewController.userId=friendId;
        objProfileViewController.navTitle=self.friendUserName;
        objProfileViewController.checkBackButton=@"Setting";

        [self.navigationController pushViewController:objProfileViewController animated:YES];
    }
    else
    {
        objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
        
        objFriendProfileViewController.userId=friendId;
        objFriendProfileViewController.navTitle=self.friendUserName;
        objFriendProfileViewController.checkView=@"Other";
        
        objFriendProfileViewController.checkChatButtonStatus=@"NO";
        objFriendProfileViewController.threadId=self.zChatId;
        
        [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
    }
    
    
}
-(IBAction)btnCameraPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    self.actionSheetView = actionSheet;
    
    
    UIImageView *background = [[UIImageView alloc] init];
    [background setFrame:CGRectMake(0, 0, 320, 320)];
    [background setBackgroundColor:[UIColor whiteColor]];
    background.contentMode = UIViewContentModeScaleToFill;
    [self.actionSheetView addSubview:background];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 30)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:@"Share"];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:20]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.actionSheetView addSubview:lblTitle];
    
    
    UIButton *cameraImageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cameraImageButton.frame = CGRectMake(20, 60, 280, 50);
    [cameraImageButton addTarget:self action:@selector(btnCameraImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    cameraImageButton.adjustsImageWhenHighlighted = YES;
    [cameraImageButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [cameraImageButton setTitle:@"Take from Camera" forState:UIControlStateNormal];
    [cameraImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cameraImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cameraImageButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.actionSheetView addSubview: cameraImageButton];
    
    UIButton *libraryImageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    libraryImageButton.frame = CGRectMake(20, 130, 280, 50);
    [libraryImageButton addTarget:self action:@selector(btnLibraryImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    libraryImageButton.adjustsImageWhenHighlighted = YES;
    [libraryImageButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [libraryImageButton setTitle:@"Take from Library" forState:UIControlStateNormal];
    [libraryImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    libraryImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    libraryImageButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.actionSheetView addSubview: libraryImageButton];
    
    
    UIButton *cancelButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, 220, 280, 50);
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.adjustsImageWhenHighlighted = YES;
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"navi_blue_btn.png"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.actionSheetView addSubview: cancelButton];
    
   
    [self.actionSheetView showInView:self.view];
    [self.actionSheetView setBounds:CGRectMake(0,0,320, 600)];
    

}
-(void)cancelButtonClicked:(id)sender {
    
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
}
-(IBAction)btnCameraImagePressed:(id)sender
{
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        
        picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.sourceType =UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];

        
    }
    
    else {
        
        picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.delegate = self;
        picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
        
    }

}

-(IBAction)btnLibraryImagePressed:(id)sender
{
    [self.actionSheetView dismissWithClickedButtonIndex:0 animated:YES];

    picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:NULL];
    
}
-(void)actionSheet:(UIActionSheet *)menu didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    int i = buttonIndex;
    switch(i)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
            break;
            
        }
        default:
            break;
    }
    
}

-(IBAction)btnAudioPressed:(id)sender
{
    
    [btnHoldToTalk setHidden:FALSE];
    
    [btnKeyboard setBackgroundImage:[UIImage imageNamed:@"ToolViewInputText"] forState:UIControlStateNormal];
    [btnKeyboard setTag:1];
    
    [PlusBtn setTag:0];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){

        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        else
        {
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
            
        }

    }
    else
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        else
        {
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
            
        }

    }
    
    if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,325+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,325)];
                
            }
            
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328)];
                
            }
        }
        
    }
    else
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365)];
                
            }
            
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365)];
                
            }
        }
    }
    
    [AudioView setHidden:TRUE];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:2.0];
    
    [UIView commitAnimations];
    
    self.checkScroll=@"YES";
    
    [self scrollToNewestMessage];
    
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender{
    
    checkHoldTalkPressed=FALSE;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        [imgLoadingView setHidden:TRUE];
        
        
        [lblHoldToTalk setText:@"HOLD TO TALK"];
        
        [self performSelectorOnMainThread:@selector(stopRecording) withObject:nil waitUntilDone:YES];
        
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        
        [lblHoldToTalk setText:@"RELEASE TO SEND"];
        
        [imgLoadingView setHidden:FALSE];
       
        loadingCounter=1;
        
        [self performSelectorOnMainThread:@selector(startRecording) withObject:nil waitUntilDone:YES];
        
    }
    
}

- (void)handleLongPressUserProfileImage:(UILongPressGestureRecognizer*)sender
{
    checkLongPress=TRUE;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [sender locationInView:tblView];
        
        NSIndexPath * indexPath = [tblView indexPathForRowAtPoint:location];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        [self.textView becomeFirstResponder];
        
        self.textView.text=[NSString stringWithFormat:@"%@%@%@%@",self.textView.text,@"@",data.name,@" "];
        
        [self performSelector:@selector(changeStatus) withObject:Nil afterDelay:1];
    }
    
}

-(void)changeStatus
{
    checkLongPress=FALSE;
    
}

- (void)handleLongPressProfileImage:(UILongPressGestureRecognizer*)sender
{
    checkLongPress=TRUE;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        [self.textView becomeFirstResponder];
        
        CGPoint location = [sender locationInView:tblView];
        
        NSIndexPath * indexPath = [tblView indexPathForRowAtPoint:location];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        self.textView.text=[NSString stringWithFormat:@"%@%@%@%@",self.textView.text,@"@",data.name,@" "];
        
        [self performSelector:@selector(changeStatus) withObject:Nil afterDelay:1];
        
        
        
    }
}

- (void) startRecording{
    
    //[self showBlackRecordingView];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
   
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];

    // Create a new dated file
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    self.recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", [self documentsDirectoryPath ], caldate];
    
    NSURL *url = [NSURL fileURLWithPath:self.recorderFilePath];
    err = nil;
    soundRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    soundRecorder.delegate=self;
    soundRecorder.meteringEnabled = YES;
    if(!soundRecorder){
        
        [self hideBlackRecordingView];
        
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    else
    {
        audiotimeLimit=0;
        
        
        audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                      target:self
                                                    selector:@selector(recordingTime)
                                                    userInfo:nil
                                                     repeats:YES];
        
    }
    
    
    [soundRecorder prepareToRecord];
    [soundRecorder record];
    
}
-(void)recordingTime {
    
    NSString *img=[NSString stringWithFormat:@"img_%d",loadingCounter];
    [imgLoadingView setImage:[UIImage imageNamed:img]];

    loadingCounter=loadingCounter+1;
    
    if (loadingCounter==9) {
        
        loadingCounter=1;
    }
    
    
    if (audiotimeLimit>180) {
        
        [soundRecorder stop];
        
        [audioTimer invalidate];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You recording is too long!..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    audiotimeLimit=audiotimeLimit+1;
}
- (void)stopRecording{
    
    [self hideBlackRecordingView];

    [audioTimer invalidate];
    [blackRecordingView removeFromSuperview];
    [soundRecorder stop];
    
    NSURL *url = [NSURL fileURLWithPath: self.recorderFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    if(!audioData)
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    
    self.imageData=audioData;
    NSLog(@"%d",[self.imageData length]);
    NSDate *date = [NSDate date];
    time_t interval = (time_t) [date timeIntervalSince1970];
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString *timestampStr = [NSString stringWithFormat:@"%ld%f", interval,timeInMiliseconds];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory=[documentsDirectory stringByAppendingPathComponent:timestampStr];
    NSString *savedImagePath = [documentsDirectory stringByAppendingFormat:@"%@",@"savedAudio.caf"];
    
    NSLog(@"%@",savedImagePath);
    
    [self.imageData writeToFile:savedImagePath atomically:NO];
    
    if (self.imageData.length==0 || self.imageData==nil) {
        
        checkHoldTalkPressed=FALSE;
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Audio file not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        
               
        [self performSelectorOnMainThread:@selector(SendChatOnLocalDB:) withObject:[[NSMutableArray alloc]initWithObjects:savedImagePath,@"3", nil] waitUntilDone:YES];
        
        
    }
    
    
    
}
-(void)showBlackRecordingView
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [blackRecordingView setFrame:CGRectMake(0, self.view.frame.size.height-100, blackRecordingView.frame.size.width, blackRecordingView.frame.size.height)];
        }
        else
        {
            
            [blackRecordingView setFrame:CGRectMake(0, self.view.frame.size.height-100, blackRecordingView.frame.size.width, blackRecordingView.frame.size.height)];
        }
        
        
    }
    else
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [blackRecordingView setFrame:CGRectMake(0, self.view.frame.size.height-100, blackRecordingView.frame.size.width, blackRecordingView.frame.size.height)];
        }
        else
        {
            
            [blackRecordingView setFrame:CGRectMake(0, self.view.frame.size.height-100, blackRecordingView.frame.size.width, blackRecordingView.frame.size.height)];
        }
        
    }
    
    if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-267,self.view.frame.size.width, 487+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-267,self.view.frame.size.width, 487)];
                
            }
            
            
        }
        else{
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+257,self.view.frame.size.width, 352+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+257,self.view.frame.size.width, 352)];
                
            }
            
        }
        
    }
    else
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+217,self.view.frame.size.width, 417+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+127,self.view.frame.size.width, 417)];
                
            }
            
        }
        else{
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+157,self.view.frame.size.width, 447+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerView.frame.origin.y+157,self.view.frame.size.width, 447)];
                
            }
            
        }
    }
    
    
    [self.view addSubview:blackRecordingView];
    
    [blackRecordingView setHidden:FALSE];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:2.0];
    
    [UIView commitAnimations];
    
    self.checkScroll=@"NO";

}
-(void)hideBlackRecordingView
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        else
        {
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        
    }
    else
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        else
        {
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        
    }
    
    
    if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328)];
                
            }
            
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,38,self.view.frame.size.width,328)];
                
            }
        }
        
    }
    else
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365)];
                
            }
            
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x,3,self.view.frame.size.width,365)];
                
            }
        }
    }
    
    [blackRecordingView setHidden:TRUE];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:2.0];
    
    [UIView commitAnimations];
    
    self.checkScroll=@"YES";
    
    [self scrollToNewestMessage];
}

-(IBAction)btnNameCardPressed:(id)sender
{
    ExistingContactListViewController *objExistuserView;
    
    objExistuserView=[[ExistingContactListViewController alloc] initWithNibName:@"ExistingContactListViewController" bundle:nil];
    
    [AppDelegate sharedAppDelegate].nameCardId=@"";
    
    [PlusBtn setTag:0];
    
    
    if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
    {
        [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
        
    }
    else
    {
        [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
        
    }
    
    [AudioView setHidden:TRUE];
    
    objExistuserView.checkView=@"namecard";
    [self.navigationController pushViewController:objExistuserView animated:YES];
    [objExistuserView release];
}

#pragma UIView Delegate
-(void)chatTextProfileClick:(ChatTextTableViewCell*)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
    
    
}
-(void) ChatTextUserProfileClick:(ChatTextUserTableViewCell*)cellValue;
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.checkView=@"Other";
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}

-(void) ChatImageButtonClick:(ChatImageTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    NSString *object=data.postImageUrl;
    
    int index=[arrPostImageList indexOfObject:object];
    
    objMWPhotoBrowser=[[MWPhotoBrowser alloc] init];
    objMWPhotoBrowser.arrImageList=[[NSMutableArray alloc] initWithArray:arrPostImageList];
    objMWPhotoBrowser.currentPageIndex=index;
    [self.navigationController pushViewController:objMWPhotoBrowser animated:YES];
    
    
}
-(void) ChatImageProfileClick:(ChatImageTableViewCell*)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.checkView=@"Other";
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}
-(void) ChatUserImageButtonClick:(ChatImageUserTableViewCell*)cellValue
{
    
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    NSString *object=data.postImageUrl;
    
    int index=[arrPostImageList indexOfObject:object];
    
    objMWPhotoBrowser=[[MWPhotoBrowser alloc] init];
    objMWPhotoBrowser.arrImageList=[[NSMutableArray alloc] initWithArray:arrPostImageList];
    objMWPhotoBrowser.currentPageIndex=index;
    [self.navigationController pushViewController:objMWPhotoBrowser animated:YES];
}

-(void) ChatUserImageProfileClick:(ChatImageUserTableViewCell *)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}


// friend audio play


-(void) ChatAudioButtonClick:(ChatAudioTableViewCell*)cellValue
{
    

    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if (self.selectedRowIndexPath!=nil) {
        
        NSLog(@"%d",indexPath.row);
        NSLog(@"%d",self.selectedRowIndexPath.row);
        
        if (indexPath.row!=self.selectedRowIndexPath.row) {
            
            [audioProgressTimer invalidate];
            audioProgressTimer=nil;
            
            [audioPlayer stop];
            
            [tblView reloadRowsAtIndexPaths:@[self.selectedRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            self.selectedRowIndexPath=nil;
            
        }
    }
    
    self.selectedRowIndexPath=[indexPath retain];
    
    NSLog(@"%@",self.selectedRowIndexPath);
    
    NSURL *url=[NSURL URLWithString:data.postAudioUrl];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
	[audioSession setActive:YES error: nil];
    
    NSLog(@"%@",url);
    
    if (audioPlayer.playing) {
        
        
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.enabled=NO;

        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [audioPlayer stop];
    }
    else
    {
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"pause_btn.png"] forState:UIControlStateNormal];
        cellValue.audioSlider.enabled = YES;

        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        [audioPlayer prepareToPlay];
        
        
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.maximumValue = audioPlayer.duration;
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
}
- (void)updateTime:(NSTimer *)timer{

    ChatAudioUserTableViewCell *cellValue=[timer userInfo];
    
    cellValue.audioSlider.value = audioPlayer.currentTime;
    
    if (cellValue.audioSlider.value<=0) {
        
        cellValue.audioSlider.enabled=NO;

        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
    }
}

-(void) ChatAudioSliderMovedClick:(ChatAudioTableViewCell*)cellValue;
{
    if (audioPlayer.isPlaying) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        NSURL *url=[NSURL URLWithString:data.postAudioUrl];
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),&audioRouteOverride);
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"pause_btn.png"] forState:UIControlStateNormal];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
    else
    {
        cellValue.audioSlider.enabled = NO;
    }

}

-(void) ChatAudioProfileClick:(ChatAudioTableViewCell*)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
        }
        
    }
}


// self audio play

-(void) ChatAudioUserButtonClick:(ChatAudioUserTableViewCell*)cellValue
{
    

    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if (self.selectedRowIndexPath!=nil) {
        
        NSLog(@"%d",indexPath.row);
        NSLog(@"%d",self.selectedRowIndexPath.row);
        
        if (indexPath.row!=self.selectedRowIndexPath.row) {
            
            [audioProgressTimer invalidate];
            audioProgressTimer=nil;
            
            [audioPlayer stop];
            
            [tblView reloadRowsAtIndexPaths:@[self.selectedRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            self.selectedRowIndexPath=nil;
            
        }
          }
    
    self.selectedRowIndexPath=[indexPath retain];
    
    NSLog(@"%@",self.selectedRowIndexPath);

    NSURL *url=[NSURL URLWithString:data.postAudioUrl];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
	[audioSession setActive:YES error: nil];
  
    NSLog(@"%@",url);
    
    if (audioPlayer.playing) {
        
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.enabled=NO;

        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        [audioPlayer stop];
    }
    else
    {
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"pause_btn.png"] forState:UIControlStateNormal];
        cellValue.audioSlider.enabled = YES;

        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        [audioPlayer prepareToPlay];
        
        
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        cellValue.audioSlider.value = 0.0;
        cellValue.audioSlider.maximumValue = audioPlayer.duration;
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;

        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime1:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
        
    }
    
   
}
- (void)updateTime1:(NSTimer *)timer{
    
    ChatAudioUserTableViewCell *cellValue=[timer userInfo];
  
    cellValue.audioSlider.value = audioPlayer.currentTime;
    
    [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"pause_btn.png"] forState:UIControlStateNormal];

    if (cellValue.audioSlider.value<=0) {
        
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
        cellValue.audioSlider.value=0.0;
        cellValue.audioSlider.enabled=NO;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
    }
    
}
-(void) ChatAudioUserSliderMovedClick:(ChatAudioUserTableViewCell*)cellValue;
{
    if (audioPlayer.isPlaying) {
        
        [audioPlayer stop];
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        NSURL *url=[NSURL URLWithString:data.postAudioUrl];
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),&audioRouteOverride);
        [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
        [audioSession setActive:YES error: nil];
        
        [cellValue.btnChatMessage setImage:[UIImage imageNamed:@"pause_btn.png"] forState:UIControlStateNormal];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer setVolume:100];
        cellValue.audioSlider.maximumValue = [audioPlayer duration];
        audioPlayer.currentTime = cellValue.audioSlider.value;
        
        [audioProgressTimer invalidate];
        audioProgressTimer=nil;
        
        audioProgressTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime1:) userInfo:cellValue repeats:YES];
        [audioPlayer play];
     
    }
    
    
    else
    {
        cellValue.audioSlider.enabled = NO;
    }
   
}

-(void) ChatAudioUserProfileClick:(ChatAudioUserTableViewCell*)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}
-(void) ChatNameCardButtonClick:(ChatNameCardTableViewCell*)cellValue
{
    
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if ([data.nameCardId isEqualToString:gUserId]) {
        
        
        objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        
        objProfileViewController.userId=data.nameCardId;
        objProfileViewController.navTitle=data.nameCardName;
        objProfileViewController.checkBackButton=@"Setting";

        [self.navigationController pushViewController:objProfileViewController animated:YES];
    }
    else
    {
        objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
        
        objFriendProfileViewController.userId=data.nameCardId;
        objFriendProfileViewController.navTitle=data.nameCardName;
        objFriendProfileViewController.checkView=@"Other";
        objFriendProfileViewController.checkChatButtonStatus=@"NO";
        objFriendProfileViewController.threadId=self.zChatId;
        
        [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
    }
    
}
-(void) ChatNameCardProfileClick:(ChatNameCardTableViewCell*)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}
-(void) ChatNameCardUserButtonClick:(ChatNameCardUserTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if ([data.nameCardId isEqualToString:gUserId]) {
        
        objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        
        objProfileViewController.userId=data.nameCardId;
        objProfileViewController.navTitle=data.nameCardName;
        objProfileViewController.checkBackButton=@"Setting";

        [self.navigationController pushViewController:objProfileViewController animated:YES];    }
    else
    {
        
        objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
        
        objFriendProfileViewController.userId=data.nameCardId;
        objFriendProfileViewController.navTitle=data.nameCardName;
        objFriendProfileViewController.checkView=@"Other";
        objFriendProfileViewController.checkChatButtonStatus=@"NO";
        objFriendProfileViewController.threadId=self.zChatId;
        
        [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
    }
}
-(void) ChatNameCardUserProfileClick:(ChatNameCardUserTableViewCell*)cellValue
{
    
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}
-(void) ChatRquestButtonClick:(ChatRequestTableViewCell*)cellValue
{
    
}
-(void) ChatRequestProfileClick:(ChatRequestTableViewCell*)cellValue
{
    if (checkLongPress==FALSE) {
        
        NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
        
        ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
        
        if (![data.userId isEqualToString:@"1"]) {
            
            if ([data.userId isEqualToString:gUserId]) {
                
                objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                
                objProfileViewController.userId=data.userId;
                objProfileViewController.navTitle=data.name;
                objProfileViewController.checkBackButton=@"Setting";

                [self.navigationController pushViewController:objProfileViewController animated:YES];
                
            }
            else
            {
                objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
                
                objFriendProfileViewController.userId=data.userId;
                objFriendProfileViewController.navTitle=data.name;
                objFriendProfileViewController.checkView=@"Other";
                objFriendProfileViewController.checkChatButtonStatus=@"NO";
                objFriendProfileViewController.threadId=self.zChatId;
                
                [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
                
            }
            
        }
        
    }
}
-(void) buttonRequestClick:(ChatRequestTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    if (![data.userId isEqualToString:@"1"]) {
        
        if ([data.userId isEqualToString:gUserId]) {
            
            objProfileViewController=[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            
            objProfileViewController.userId=data.userId;
            objProfileViewController.navTitle=data.name;
            objProfileViewController.checkBackButton=@"Setting";

            [self.navigationController pushViewController:objProfileViewController animated:YES];
            
        }
        else
        {
            objFriendProfileViewController=[[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
            
            objFriendProfileViewController.userId=data.userId;
            objFriendProfileViewController.navTitle=data.name;
            objFriendProfileViewController.checkView=@"Other";
            objFriendProfileViewController.checkChatButtonStatus=@"NO";
            objFriendProfileViewController.threadId=self.zChatId;
            
            [self.navigationController pushViewController:objFriendProfileViewController animated:YES];
            
        }
        
    }
    
}

-(void) buttonAcceptClick:(ChatRequestTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSLog(@"%@",data.userId);
        NSLog(@"%@",data.messasgeId);
        
        self.deleteMsgId=data.serverMsgId;
        
        [service AcceptRejectOwnerRequestInvocation:gUserId groupId:self.groupId memberId:data.userId status:@"2" messageId:data.serverMsgId delegate:self];
        
    }
}
-(void) buttonRejectClick:(ChatRequestTableViewCell*)cellValue
{
    NSIndexPath * indexPath = [tblView indexPathForCell:cellValue];
    
    ChatDetailData *data=[self.arrChatData objectAtIndex:indexPath.row];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.deleteMsgId=data.serverMsgId;
        
        [service AcceptRejectOwnerRequestInvocation:gUserId groupId:self.groupId memberId:data.userId status:@"3" messageId:data.serverMsgId delegate:self];
        
    }
}


#pragma mark Delegate
#pragma textfield delegate

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    [AudioView setHidden:TRUE];
    [containerView setHidden:FALSE];
    
    self.checkScroll=@"NO";
    
    [btnEdit setHidden:TRUE];
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect containerFrame = containerView.frame;
    
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+300,self.view.frame.size.width, 300)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+300-IPHONE_FIVE_FACTOR,self.view.frame.size.width, 300-IPHONE_FIVE_FACTOR)];
                
            }
            
            
        }
        else{
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+180,self.view.frame.size.width, 115+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+180-IPHONE_FIVE_FACTOR,self.view.frame.size.width, 115)];
                
            }
            
        }
        
    }
    else
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+300,self.view.frame.size.width, 300)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+300-IPHONE_FIVE_FACTOR,self.view.frame.size.width, 300-IPHONE_FIVE_FACTOR)];
                
            }
            
            
        }
        else{
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+180,self.view.frame.size.width, 115+IPHONE_FIVE_FACTOR)];
                
            }
            else
            {
                [tblView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-containerFrame.origin.y+180-IPHONE_FIVE_FACTOR,self.view.frame.size.width, 115)];
                
            }
            
        }
    }
    
    if ([self.arrChatData count] > 1) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(self.arrChatData.count - 1) inSection:0];
        
        
        if (checkDisapper==TRUE) {
            
            [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
    }
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
	
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    [AudioView setHidden:FALSE];
    [containerView setHidden:TRUE];

    if (checkAddress==TRUE) {
        
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        //  [btnEdit setHidden:FALSE];
        
        // get a rect for the textView frame
        CGRect containerFrame = containerView.frame;
        containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
        
        NSLog(@"containerFrame %f",containerFrame.origin.y);
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        containerView.frame = containerFrame;
        
        if ([self.groupType isEqualToString:@"0"] && ![self.friendId isEqualToString:@"100"]) {
            
            [requestView setHidden:FALSE];
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,430)];
                    
                    [AudioView setFrame:CGRectMake(0, 467, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,430-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 467-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                
            }
            else{
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,380)];
                    
                    [AudioView setFrame:CGRectMake(0, 379, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,35,self.view.frame.size.width,380-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 379-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
            }
            
            
        }

        else
        {
            [requestView setHidden:TRUE];
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,460)];
                    
                    [AudioView setFrame:CGRectMake(0, 467, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,460-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 467-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                
            }
            else{
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,380)];
                    
                    [AudioView setFrame:CGRectMake(0, 379, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
                else
                {
                    [tblView setFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,380-IPHONE_FIVE_FACTOR)];
                    
                    [AudioView setFrame:CGRectMake(0, 379-IPHONE_FIVE_FACTOR, AudioView.frame.size.width, AudioView.frame.size.height)];
                    
                    
                }
            }
            
        }
        if ([self.arrChatData count] > 1) {
            
            if (checkDisapper==TRUE) {
                
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(self.arrChatData.count - 1) inSection:0];
                
                [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
            }
            
        }
        
        [UIView commitAnimations];
        [self resignTextView];
        self.checkScroll=@"YES";
        
    }
	// commit animations
	
}
-(void)resignTextView
{
    
    [self.textView resignFirstResponder];
    
	NSString *str = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"%@",str);
    NSLog(@"%@",self.textView.text);
	
	if([str length] > 0){
        
		[self sendChatData:str];
		
		
    }
    
    
}
- (void)sendChatData:(NSString*)aData
{
    if (aData==nil || aData==(NSString*)[NSNull null]) {
        
    }
    else
    {
        NSLog(@"%@",aData);
        
        [self performSelectorOnMainThread:@selector(SendChatOnLocalDB:) withObject:[[NSMutableArray alloc]initWithObjects:aData,@"1", nil] waitUntilDone:YES];

        
        
    }
    
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string;
{
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        if ([string isEqualToString:@"@"]) {
            
            
            NSString *str=@"";
            
            if ([growingTextView.text length]>0) {
                
                str=[growingTextView.text substringFromIndex:[growingTextView.text length]-1];
                
                
                if ([str isEqualToString:@" "]) {
                    
                    checkAddress=FALSE;
                    
                    self.textView.text=[NSString stringWithFormat:@"%@%@",self.textView.text,@"@"];
                    
                    KickOffMemberViewController *objKickOffMemberViewController=[[KickOffMemberViewController alloc] initWithNibName:@"KickOffMemberViewController" bundle:Nil];
                    objKickOffMemberViewController.checkView=@"chat";
                    objKickOffMemberViewController.groupId=self.groupId;
                    [self.navigationController pushViewController:objKickOffMemberViewController animated:YES];
                }
            }
            else
            {
                checkAddress=FALSE;
                
                self.textView.text=[NSString stringWithFormat:@"%@%@",self.textView.text,@"@"];
                
                KickOffMemberViewController *objKickOffMemberViewController=[[KickOffMemberViewController alloc] initWithNibName:@"KickOffMemberViewController" bundle:Nil];
                objKickOffMemberViewController.checkView=@"chat";
                objKickOffMemberViewController.groupId=self.groupId;
                [self.navigationController pushViewController:objKickOffMemberViewController animated:YES];
            }
            
            
            
        }
        
    }
    
    return YES;
    
}
- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
    
}

-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    
    if (tblView.dragging==YES) {
        
        return NO;
    }
    else
    {
        [PlusBtn setTag:0];
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370+IPHONE_FIVE_FACTOR, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        else
        {
            [containerView setFrame:CGRectMake(containerView.frame.origin.x, 370, containerView.frame.size.width, containerView.frame.size.height)];
            
        }
        
        [AudioView setHidden:TRUE];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationCurve:2.0];
        
        [UIView commitAnimations];
        
        return YES;
    }
    
    
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

#pragma mark ------------Delegate-----------------
#pragma mark Sqlite method

-(void)checkNameCardUser:(NSMutableArray*)array
{
    NSString *nmCardId=[array objectAtIndex:0];
    
    
    NSString *uId=@"";
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT UserId FROM tbl_user where UserId='%@'",nmCardId];
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            uId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSLog(@"%@",uId);
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
    
    if ([uId isEqualToString:@""]) {
        
        [self performSelectorOnMainThread:@selector(saveNameCardUser:) withObject:array waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(updateNameCardUserOnLocalDB:) withObject:array waitUntilDone:YES];
        
    }
}

-(void)saveNameCardUser:(NSMutableArray*)array
{
    
    NSString *nmCardId=[array objectAtIndex:0];
    NSString *nmCardNm=[array objectAtIndex:1];
    NSString *nmCardImg=[array objectAtIndex:2];
    
    NSLog(@"nmCardImg %@",nmCardImg);
    
    const char *sqlStatement = "Insert into tbl_user (UserId,UserName,UserImage,DisplayName,EmailId,PhoneNo,Gender,Dob,Rating,Unpaid_revenue) values(?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        
        
        sqlite3_bind_text( compiledStatement, 1, [nmCardId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 2, [nmCardNm UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 3, [nmCardImg UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 4, [@""  UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 6, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text( compiledStatement, 7, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 8, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text( compiledStatement, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 10, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
        NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
    } else {
        
        NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
        
    }
    sqlite3_finalize(compiledStatement);
    
    
}
-(void)updateNameCardUserOnLocalDB:(NSMutableArray*)array
{
    NSString *nmCardId=[array objectAtIndex:0];
    NSString *nmCardNm=[array objectAtIndex:1];
    NSString *nmCardImg=[array objectAtIndex:2];
    
    
    NSString *sqlStatement1=[NSString stringWithFormat:@"update tbl_user set UserId = '%@',UserName = '%@',UserImage='%@' where UserId= '%@'",nmCardId,nmCardNm,nmCardImg,nmCardId];
    
    NSLog(@"%@",sqlStatement1);
    
    const char *sqlStatement=[sqlStatement1 UTF8String];
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        int success = sqlite3_step(compiledStatement);
        
        if (success == SQLITE_ERROR) {
            
            NSLog(@"updateNameCardUserOnLocalDB error");
            
            
        }
        else
        {
            
            NSLog(@"updateNameCardUserOnLocalDB success");
        }
        
        
    }
    
    sqlite3_finalize(compiledStatement);
    
    
}
#pragma mark - Start from View DID Load


-(void)getThreadIDFromLocalDB
{
    
    NSString *chatId=@"";
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id,ZMsgId FROM tbl_chatUser where chatUserId='%@' and chatFriendId= '%@' or chatUserId='%@' and chatFriendId= '%@' ",gUserId,self.friendId,self.friendId,gUserId];
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            self.zChatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            self.threadId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            NSLog(@"%@",self.zChatId);
        }
        
    }
    
    sqlite3_finalize(compiledStatement);
    
	if ([self.zChatId isEqualToString:@""]) {
		
        chatId=[self genRandStringLength:40];
        
        NSLog(@"%@",chatId);
        
        const char *sqlStatement = "Insert into tbl_chatUser (chatUserId,chatFriendId,ZMsgId) values(?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text( compiledStatement, 1, [gUserId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [friendId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [chatId UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        } else {
            
            NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            self.zChatId=[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database)];
            self.threadId=chatId;
            
        }
        sqlite3_finalize(compiledStatement);
        
        
	}
    
}
-(void)displayChatDataFromLocalDB
{
    self.checkType=@"old";
    
    [self.arrTempChatData removeAllObjects];
    
    @try {
        
        if ([checkTablePosition isEqualToString:@"YES"]) {
            
            [self.arrChatData removeAllObjects];
            [arrPostImageList removeAllObjects];
        }
        
        NSString *key = @"Key=";
        NSString *sqlStatement = @"";
        NSString *sqlStatement1 = @"";
        
        
        sqlStatement1 =[NSString stringWithFormat:@"SELECT COUNT(*) from tbl_chat as tbc INNER JOIN tbl_chatUser as tcu on tbc.ZChatId=tcu.Id LEFT JOIN tbl_user as tbu on tbu.UserId = tbc.NameCardId LEFT  JOIN tbl_user as tu on tbc.MsgUserId=tu.UserId where tcu.Id ='%@'",self.zChatId];
        
        
        NSLog(@"%@",sqlStatement1);
        
        [cache removeAllObjects];
        
		sqlite3_stmt *compiledStatement1;
		
        if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement1 cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement1,NULL )==SQLITE_OK)
		{
            
            if (sqlite3_step(compiledStatement1) == SQLITE_ERROR) {
                NSAssert1(0,@"Error when counting rows  %s",sqlite3_errmsg([AppDelegate sharedAppDelegate].database));
            } else {
                int rows = sqlite3_column_int(compiledStatement1, 0);
                NSLog(@"SQLite Rows: %i", rows);
                self.totalRecord=[NSString stringWithFormat:@"%d",rows];
                
            }
            
            sqlite3_finalize(compiledStatement1);
            
        }
        
        
        int firstLimit=(page-1)*10;
        NSLog(@"%d",firstLimit);
        NSString *pageCountStr=[NSString stringWithFormat:@"%d",firstLimit];
        
        sqlStatement =[NSString stringWithFormat:@"SELECT tbc.ContentType,tbc.ReadCount,tbc.TimeStamp,tbc.MessageType,tbc.Message,tbc.ImageId,tbc.AudioId,tbu.UserId,tbu.UserName,tbu.UserImage,tbc.MsgUserId,tu.UserName,tu.UserImage,tbc.Id,tbc.StaticMessage,tbc.RequestStatus,tbc.MessageId from tbl_chat as tbc INNER JOIN tbl_chatUser as tcu on tbc.ZChatId=tcu.Id LEFT JOIN tbl_user as tbu on tbu.UserId = tbc.NameCardId LEFT  JOIN tbl_user as tu on tbc.MsgUserId=tu.UserId where tcu.Id ='%@' order by tbc.Id DESC limit '%@',10",self.zChatId,pageCountStr];
        
        
        
        NSLog(@"%@",sqlStatement);
        
        [cache removeAllObjects];
        
		sqlite3_stmt *compiledStatement;
        
        NSMutableArray *array=[[NSMutableArray alloc] init];
		
        if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
		{
			while (sqlite3_step(compiledStatement)==SQLITE_ROW)
			{
                [AppDelegate sharedAppDelegate].chatDetailType=@"old";
                
                ChatDetailData *data=[[[ChatDetailData alloc] init] autorelease];
                
                NSString * msgId=@"";
                NSString * msgUserId=@"";
                NSString * msgUserName=@"";
                NSString * msgUserImage=@"";
                NSString * ImageId=@"";
                NSString * AudioId=@"";
                NSString * chatType=@"";
                NSString * ReadUnread=@"";
                NSString * messageType=@"";
                NSString * TimeStamp=@"";
                NSString * message=@"";
                NSString * nameCardUserId=@"";
                NSString * nameCardUserImage=@"";
                NSString * nameCardUserName=@"";
                NSString * staticMsg=@"";
                NSString * requestStatus=@"";
                NSString * messageId=@"";
                
                if (sqlite3_column_type(compiledStatement, 0) != SQLITE_NULL)
                {
                    chatType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 1) != SQLITE_NULL )
                {
                    ReadUnread=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 2) != SQLITE_NULL )
                {
                    NSString *time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                    
                    NSLog(@"time %@",time);
                    
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
                    
                    NSDateFormatter *dateForMater=[[NSDateFormatter alloc] init];
                    [dateForMater setDateFormat:@"yy/MM/dd hh:mm:a"];
                    TimeStamp=[dateForMater stringFromDate:date];
                    
                }
                if (sqlite3_column_type(compiledStatement, 3) != SQLITE_NULL )
                {
                    messageType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                if (sqlite3_column_type(compiledStatement, 14) != SQLITE_NULL )
                {
                    staticMsg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 4) != SQLITE_NULL )
                {
                    NSString *msg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                    
                    NSLog(@"%@",msg);
              
                    NSString *result =@"";
                    
                    if ([chatType isEqualToString:@"1"]) {
                        
                        if ([staticMsg isEqualToString:@"1"]) {
                            
                            NSString *plaintext = [msg AES256DecryptWithKey:key];
                            
                            NSLog(@"%@",plaintext);

                            if (plaintext==nil || plaintext==(NSString*)[NSNull null] || [plaintext isEqualToString:@""]) {
                                
                                result = [(NSString *)msg stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                                result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            }
                            else
                            {
                                result = [(NSString *)plaintext stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                                result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            }
                            
                           
                        }
                        else
                        {
                            NSString *plaintext = [msg AES256DecryptWithKey:key];
                           
                            NSLog(@"%@",plaintext);

                            if (plaintext==nil || plaintext==(NSString*)[NSNull null] || [plaintext isEqualToString:@""]) {

                                NSData *dataMsg=[QSStrings decodeBase64WithString:msg];
                                
                                result = [[NSString alloc] initWithData:dataMsg encoding:NSUTF8StringEncoding];
                            }
                            else
                            {
                                NSData *dataMsg=[QSStrings decodeBase64WithString:plaintext];
                                
                                result = [[NSString alloc] initWithData:dataMsg encoding:NSUTF8StringEncoding];
                            }
                           
                            
                        }
                        
                    }
                    
                    else
                    {
                        NSString *plaintext = [msg AES256DecryptWithKey:key];
                        
                        NSLog(@"%@",plaintext);

                        if (plaintext==nil || plaintext==(NSString*)[NSNull null] || [plaintext isEqualToString:@""]) {
                            
                            result=msg;

                        }
                        else
                        {
                            result=plaintext;

                        }

                    }
                    
                    
                    message=result;
                }
                
                if (sqlite3_column_type(compiledStatement, 5) != SQLITE_NULL )
                {
                    ImageId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 6) != SQLITE_NULL )
                {
                    AudioId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 7) != SQLITE_NULL )
                {
                    nameCardUserId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 8) != SQLITE_NULL )
                {
                    nameCardUserName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                if (sqlite3_column_type(compiledStatement, 9) != SQLITE_NULL )
                {
                    nameCardUserImage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 10) != SQLITE_NULL )
                {
                    msgUserId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 11) != SQLITE_NULL )
                {
                    msgUserName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 12) != SQLITE_NULL )
                {
                    msgUserImage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 13) != SQLITE_NULL )
                {
                    msgId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 15) != SQLITE_NULL )
                {
                    requestStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                    
                }
                if (sqlite3_column_type(compiledStatement, 16) != SQLITE_NULL )
                {
                    messageId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                    
                }
                data.userId= msgUserId;
                data.image=msgUserImage;
                data.name=msgUserName;
                data.message=message;
                data.messasgeId=msgId;
                data.date=TimeStamp;
                data.chatType=chatType;
                data.postImageUrl=ImageId;
                data.postAudioUrl=AudioId;
                data.nameCardId=nameCardUserId;
                data.nameCardImage=nameCardUserImage;
                data.nameCardName=nameCardUserName;
                data.staticMessage=staticMsg;
                data.requestStatus=requestStatus;
                data.serverMsgId=messageId;
                
                NSLog(@"data.message %@",data.message);
                NSLog(@"data.message %@",data.name);
                NSLog(@"data.message %@",data.userId);

                if (![data.postImageUrl isEqualToString:@""]) {
                    
                    [arrPostImageList addObject:data.postImageUrl];
                }
                
                self.totalHeightForCell=0;
                
                if (data.message.length>0)
                {
                    NSString *text=@"";
                    text= getStringAfterTriming(data.message);
                    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(216,130000)lineBreakMode:NSLineBreakByWordWrapping];
                    
                    //CGSize size=[self sizeForText:data.message];
                    
                    self.totalHeightForCell=self.totalHeightForCell+size.height+20;
                    
                    data.cellHeight=self.totalHeightForCell;
                }
                
                if ([data.chatType isEqualToString:@"3"]) {
                    
                   /* NSURL *afUrl = [NSURL fileURLWithPath:data.postAudioUrl];
                    AudioFileID fileID;
                    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &fileID);
                    UInt64 outDataSize = 0;
                    UInt32 thePropSize = sizeof(UInt64);
                    result = AudioFileGetProperty(fileID, kAudioFilePropertyEstimatedDuration, &thePropSize, &outDataSize);
                    NSLog(@"%d",(int)result);
                    
                    AudioFileClose(fileID);*/
                    
                   /* AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:data.postAudioUrl] options:nil];
                    CMTime audioDuration = audioAsset.duration;
                    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
                    
                    NSLog(@"%f",audioDurationSeconds);*/
                    
                    NSURL *url=[NSURL URLWithString:data.postAudioUrl];
                    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
                    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
                    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                             sizeof (audioRouteOverride),&audioRouteOverride);
                    [audioSession setCategory:AVAudioSessionCategoryPlayback error: nil];
                    [audioSession setActive:YES error: nil];
                    
                    
                    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    
                    NSLog(@"%.2f",player.duration);

                    float duration = player.duration;
                    
                    int result = (int)roundf(duration);

                    NSLog(@"%d",result);
                    
                   NSString *durationStr=[NSString stringWithFormat:@"%d",result];
                
                    data.audioDuration=[NSString stringWithFormat:@"%@ sec",durationStr];


                }
                
                if (![data.chatType isEqualToString:@"4"]) {
                    
                    [array addObject:data];

                }
                
                
            }
            
            
            for (int i=[array count]-1; i>=0; i--) {
                
                [self.arrTempChatData addObject:[array objectAtIndex:i]];
            }
            [self.arrTempChatData addObjectsFromArray:self.arrChatData];
            
            [self.arrChatData removeAllObjects];
            
            [self.arrChatData addObjectsFromArray:self.arrTempChatData];
		}
        
        [array release];
        
        NSLog(@"[self.arrChatData count] %d",[self.arrChatData count]);
        
		sqlite3_finalize(compiledStatement);
        
        NSLog(@"count %d",[self.arrChatData count]);
        NSLog(@"offset %f",offset);
        
        [tblView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [tblView setHidden:FALSE];
        
        
        if ([checkTablePosition isEqualToString:@"YES"]) {
            
            
            [self scrollToNewestMessage];
            
        }
        
        
        checkScroll=@"YES";
        
        if([self.arrChatData count]>0)
        {
            [btnEdit setEnabled:TRUE];
        }
        else
        {
            [btnEdit setEnabled:FALSE];
            
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"111 %@",[exception description]);
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    moveTabG=FALSE;
    
}

#pragma mark - Display data work finished

-(void)SendChatOnLocalDB:(NSMutableArray *)array
{
    moveTabG=TRUE;
    checkDisapper=TRUE;
    checkTablePosition=@"YES";
    
    page=1;
    
    if ([self.groupType isEqualToString:@"0"]) {
        
        [self getChatDetailTypeFromLocalDB];
        [self getThreadIDFromLocalDB];
        
    }
    
    NSString *data=[array objectAtIndex:0];
    NSString *type=[array objectAtIndex:1];
    
    NSDate *date = [NSDate date];
    time_t interval = (time_t) [date timeIntervalSince1970];
    
    self.timeinNSString = [NSString stringWithFormat:@"%ld", interval];
    NSLog(@"%@",self.timeinNSString);
    
    NSLog(@"type %@",type);
    
    NSString* base64String=@"";
    NSString *key = @"Key=";

    NSString *serverMsg=@"";
    
    if ([type isEqualToString:@"1"]) {
        
        NSData* msgData=[self.textView.text dataUsingEncoding:NSUTF8StringEncoding];
      
        NSString *plaintext = [QSStrings encodeBase64WithData:msgData];
        
        serverMsg=plaintext;

        base64String = [plaintext AES256EncryptWithKey:key];

        NSLog(@"%@",plaintext);

        self.msessageString=base64String;
        
    }
    else if ([type isEqualToString:@"2"]) {
        
        
       // base64String=@"[Image File]";
       
        NSString *plaintext=@"[Image File]";
        
        serverMsg=plaintext;
        
        base64String = [plaintext AES256EncryptWithKey:key];


        
    }
    else if ([type isEqualToString:@"3"]) {
        
        //base64String=@"[Audio File]";
        
        NSString *plaintext=@"[Audio File]";
        serverMsg=plaintext;
        
        base64String = [plaintext AES256EncryptWithKey:key];


        
    }
    else if ([type isEqualToString:@"4"]) {
        
        //base64String=@"[Name Card]";
        
        NSString *plaintext=@"[Name Card]";
        
        serverMsg=plaintext;
        
        base64String = [plaintext AES256EncryptWithKey:key];

        
        NSMutableArray *array=[[[NSMutableArray alloc] initWithObjects:[AppDelegate sharedAppDelegate].nameCardId,[AppDelegate sharedAppDelegate].nameCardName,[AppDelegate sharedAppDelegate].nameCardImage, nil] autorelease];
        
        [self checkNameCardUser:array];
    }
    
    NSString *idStr=@"";
    
    if ([self.groupType isEqualToString:@"1"]) {
        
        idStr=self.groupId;
    }
    else
    {
        idStr=@"";
    }
    
    
    self.msessageString=base64String;
    
    NSLog(@"%@",self.msessageString);
    
    
    const char *sqlStatement = "Insert into tbl_chat (ReadCount,ContentType,TimeStamp,MessageType,Message,MsgUserId,ZChatId,GroupId,AudioId,ImageId,NameCardId,StaticMessage) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
        
        sqlite3_bind_text( compiledStatement, 1, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 2, [type UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 3, [self.timeinNSString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 4, [@"S" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 5, [self.msessageString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 6, [gUserId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 7, [self.zChatId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 8, [idStr UTF8String], -1, SQLITE_TRANSIENT);
        if ([type isEqualToString:@"3"]) {
            sqlite3_bind_text( compiledStatement, 9, [data UTF8String], -1, SQLITE_TRANSIENT);
        }
        else
        {
            sqlite3_bind_text( compiledStatement, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        }
        if ([type isEqualToString:@"2"]) {
            
            sqlite3_bind_text( compiledStatement, 10, [data UTF8String], -1, SQLITE_TRANSIENT);
        }
        else
        {
            sqlite3_bind_text( compiledStatement, 10, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        }
        if ([type isEqualToString:@"4"]) {
            
            sqlite3_bind_text( compiledStatement, 11, [data UTF8String], -1, SQLITE_TRANSIENT);
        }
        else
        {
            sqlite3_bind_text( compiledStatement, 11, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        }
        
        sqlite3_bind_text( compiledStatement, 12, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    
    if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
        NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
    }
    
    else {
        NSLog( @"Insert into row id = %lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
        
        
    }
    sqlite3_finalize(compiledStatement);
    
    
    self.textView.text=@"";
    
    checkHoldTalkPressed=TRUE;
    
    [self displayChatDataFromLocalDB];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        
        if ([type isEqualToString:@"1"]) {
            
            NSLog(@"%@",self.msessageString);
            
            NSLog(@"%@",self.threadId);
            
            [service SendChatInvocation:gUserId friendId:self.friendId message:serverMsg type:type imageName:@"" audioName:@"" namecardId:@"" threadId:self.threadId groupId:self.groupId groupType:self.groupType publicPrivateType:[AppDelegate sharedAppDelegate].checkPublicPrivateStatus delegate:self];
            
        }
        else if([type isEqualToString:@"2"])
        {
            [self uploadImage];
        }
        else if([type isEqualToString:@"3"])
        {
            [self uploadAudio];
        }
        else
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue,
                           ^{
                               
                               dispatch_sync(dispatch_get_main_queue(),
                                             ^{
                                                 [service SendChatInvocation:gUserId friendId:self.friendId message:serverMsg type:type imageName:@"" audioName:@"" namecardId:[AppDelegate sharedAppDelegate].nameCardId threadId:self.threadId groupId:self.groupId groupType:self.groupType publicPrivateType:[AppDelegate sharedAppDelegate].checkPublicPrivateStatus delegate:self];

                                                 
                                             });
                           });
            

            
        }
        
        
    }
    
    
}
-(void)saveLastMsgIdOnLocalDB:(NSString*)chatId
{
    
    @try {
        NSString *sqlStatement1=[NSString stringWithFormat:@"update tbl_chatUser set lastMsgId = '%@' where ZMsgId= '%@'", self.lastMsgId,chatId];
        
        NSLog(@"%@",sqlStatement1);
        const char *sqlStatement=[sqlStatement1 UTF8String];
		sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			int success = sqlite3_step(compiledStatement);
            
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg([AppDelegate sharedAppDelegate].database));
            }
            else
            {
                self.checkLastMsgIdStr=self.lastMsgId;
                
                NSLog(@"success");
            }
		}
		sqlite3_finalize(compiledStatement);
        
    }
    @catch (NSException *exception) {
        NSLog(@"114 %@",[exception description]);
    }
    
}
-(void)getLastMsgIdFromLocalDB
{
    if ([self.groupType isEqualToString:@"0"]) {
        
        NSString *sqlStatement = @"";
        sqlStatement =[NSString stringWithFormat:@"SELECT lastMsgId from tbl_chatUser where chatUserId='%@' and chatFriendId='%@'",gUserId,self.friendId];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement)==SQLITE_ROW)
            {
                if (sqlite3_column_type(compiledStatement, 0) != SQLITE_NULL )
                {
                    
                    self.lastMsgId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                    
                    self.checkLastMsgIdStr=self.lastMsgId;
                    
                    
                }
            }
            sqlite3_finalize(compiledStatement);
            
        }
    }
    else
    {
        NSString *sqlStatement = @"";
        sqlStatement =[NSString stringWithFormat:@"SELECT lastMsgId from tbl_chatUser where chatUserId='%@' and chatFriendId='%@'",self.groupId,self.friendId];
        NSLog(@"%@",sqlStatement);
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement)==SQLITE_ROW)
            {
                if (sqlite3_column_type(compiledStatement, 0) != SQLITE_NULL )
                {
                    NSLog(@"ksdlgkl;dgks");
                    
                    self.lastMsgId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                    self.checkLastMsgIdStr=self.lastMsgId;
                    
                }
            }
            sqlite3_finalize(compiledStatement);
            
        }
    }
    
    [self getChatDetailTypeFromLocalDB];
    
    NSLog(@"%@",self.lastMsgId);
}
-(void)getChatDetailTypeFromLocalDB
{
    NSString *chatId=@"";
    
    if ([self.groupType isEqualToString:@"0"]) {
        
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id FROM tbl_chatUser where chatUserId='%@' and chatFriendId= '%@'",gUserId,friendId];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement)==SQLITE_ROW)
            {
                chatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"%@",self.zChatId);
            }
            
        }
        sqlite3_finalize(compiledStatement);
    }
    else
    {
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id FROM tbl_chatUser where chatUserId='%@'",self.groupId];
        
        sqlite3_stmt *compiledStatement;
        if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement)==SQLITE_ROW)
            {
                chatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSLog(@"%@",chatId);
            }
            
        }
        sqlite3_finalize(compiledStatement);
    }
    
    
    if ([chatId isEqualToString:@""]) {
        
        [AppDelegate sharedAppDelegate].chatDetailType=@"new";
    }
    else
    {
        [AppDelegate sharedAppDelegate].chatDetailType=@"old";
        
    }
}
-(NSString *) genRandStringLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}
-(void)saveChatDataInTable:(NSMutableArray*)array
{
    NSString *senderIdStr=[array objectAtIndex:0];
    NSString *messageType=[array objectAtIndex:1];
    NSString *zChatIdStr=[array objectAtIndex:2];
    NSString *timestamp=[array objectAtIndex:3];
    NSString *message=[array objectAtIndex:4];
    NSString *chatType=[array objectAtIndex:5];
    NSString *imageUrl=[array objectAtIndex:6];
    NSString *audioUrl=[array objectAtIndex:7];
    NSString *nameCard=[array objectAtIndex:8];
    NSString *staticMsg=[array objectAtIndex:9];
    NSString *requestStatus=[array objectAtIndex:10];
    
    NSString *idStr=@"";
    NSString *key = @"Key=";

    
    if ([self.groupType isEqualToString:@"1"]) {
        
        idStr=self.groupId;
    }
    else
    {
        idStr=@"";
    }
    
    NSString* base64String=@"";
    NSString* msgType=@"";
    
    if ([messageType isEqualToString:@"Receiver"]) {
        
        msgType=@"R";
    }
    else
    {
        msgType=@"S";
    }
    
    NSLog(@"threadId %@",self.threadId);
    
    if ([staticMsg isEqualToString:@"1"]) {
        
        NSString *plaintext = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                            NULL,
                                                                            (CFStringRef)message,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                            kCFStringEncodingUTF8 )autorelease];
        
        base64String = [plaintext AES256EncryptWithKey:key];
        
        NSLog(@"%@",plaintext);
        
        self.msessageString=base64String;

    }
    else
    {
        base64String = [message AES256EncryptWithKey:key];
    }
    
    NSString *chatId=@"";
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT MessageId FROM tbl_chat where MessageId = '%@' ",self.lastMsgId];
    
    NSLog(@"%@",sqlStatement);
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            chatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
    if ([chatId isEqualToString:@""]) {
        
        const char *sqlStatement = "Insert into tbl_chat (ReadCount,ContentType,TimeStamp,MessageType,Message,MsgUserId,ZChatId,GroupId,AudioId,ImageId,NameCardId,StaticMessage,RequestStatus,MessageId) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        NSLog(@"insert");
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            sqlite3_bind_text( compiledStatement, 1, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [chatType UTF8String], -1, SQLITE_TRANSIENT);
            NSLog(@"insert1");
            sqlite3_bind_text( compiledStatement, 3, [timestamp UTF8String], -1, SQLITE_TRANSIENT);
            NSLog(@"insert2");
            sqlite3_bind_text( compiledStatement, 4, [msgType UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 5, [message UTF8String], -1, SQLITE_TRANSIENT);
            NSLog(@"insert3");
            sqlite3_bind_text( compiledStatement, 6, [senderIdStr UTF8String], -1, SQLITE_TRANSIENT);
            NSLog(@"insert4");
            sqlite3_bind_text( compiledStatement, 7, [zChatIdStr UTF8String], -1, SQLITE_TRANSIENT);
            NSLog(@"insert5");
            sqlite3_bind_text( compiledStatement, 8, [idStr UTF8String], -1, SQLITE_TRANSIENT);
            
            if ([chatType isEqualToString:@"3"]) {
                
                sqlite3_bind_text( compiledStatement, 9, [audioUrl UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            else
            {
                sqlite3_bind_text( compiledStatement, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            if ([chatType isEqualToString:@"2"]) {
                
                sqlite3_bind_text( compiledStatement, 10, [imageUrl UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            else
            {
                sqlite3_bind_text( compiledStatement, 10, [@"" UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            
            if ([chatType isEqualToString:@"4"]) {
                
                sqlite3_bind_text( compiledStatement, 11, [nameCard UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            else
            {
                sqlite3_bind_text( compiledStatement, 11, [@"" UTF8String], -1, SQLITE_TRANSIENT);
                
            }
            
            sqlite3_bind_text( compiledStatement, 12, [staticMsg UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 13, [requestStatus UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 14, [self.lastMsgId UTF8String], -1, SQLITE_TRANSIENT);
            
            
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        }
        else {
            
            NSLog( @"Insert into row id = %lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            
            
        }
        sqlite3_finalize(compiledStatement);
        
    }
    
    
    
    
    
    
}
-(NSString*)checkAndCreateThreadIDFromLocalDB:(NSString*)thread
{
    self.threadId=thread;
    
    NSString *chatId=@"";
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id,ZMsgId FROM tbl_chatUser where chatUserId='%@' and chatFriendId= '%@' or chatUserId='%@' and chatFriendId= '%@' ",gUserId,self.friendId,self.friendId,gUserId];
    
    NSLog(@"%@",sqlStatement);
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            chatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            self.zChatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            //self.threadId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            NSLog(@"%@",self.zChatId);
            NSLog(@"%@",self.threadId);
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
	if ([chatId isEqualToString:@""]) {
		
        const char *sqlStatement = "Insert into tbl_chatUser (chatUserId,chatFriendId,ZMsgId) values(?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [gUserId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [self.friendId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [thread UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
            
        } else {
            
            NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            chatId=[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database)];
            
            self.zChatId=chatId;
            //self.threadId=thread;
            
            NSLog(@"%@",self.zChatId);
            NSLog(@"%@",self.threadId);
            
        }
        sqlite3_finalize(compiledStatement);
        
		
	}
    else
    {
        NSString *sqlStatement1=[NSString stringWithFormat:@"update tbl_chatUser set chatUserId = '%@',chatFriendId = '%@',ZMsgId='%@' where chatUserId='%@' and chatFriendId= '%@' or chatUserId='%@' and chatFriendId= '%@' ",gUserId,self.friendId,thread,gUserId,self.friendId,self.friendId,gUserId];
        
        NSLog(@"%@",sqlStatement1);
        
        const char *sqlStatement=[sqlStatement1 UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            int success = sqlite3_step(compiledStatement);
            
            if (success == SQLITE_ERROR) {
                
                NSLog(@"updateUserDetailOnLocalDB error");
                
                
            }
            else
            {
                
                NSLog(@"%@",self.zChatId);
                NSLog(@"%@",self.threadId);
                
                
                NSLog(@"updateUserDetailOnLocalDB success");
            }
            
            
        }
        
        sqlite3_finalize(compiledStatement);
    }
    
    return chatId;
    
    
}
-(NSString*)checkAndCreateGroupThreadIDFromLocalDB:(NSString*)thread;
{
    NSString *chatId=@"";
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id,ZMsgId FROM tbl_chatUser where chatUserId='%@' and chatFriendId='%@'",self.groupId,@"0"];
    
    NSLog(@"%@",sqlStatement);
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            chatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            self.zChatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSString *thread=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            self.threadId=@"";
            self.threadId=[NSString stringWithFormat:@"%@",thread];
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
	if ([chatId isEqualToString:@""]) {
		
        const char *sqlStatement = "Insert into tbl_chatUser (chatUserId,chatFriendId,ZMsgId) values(?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text( compiledStatement, 1, [self.groupId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [thread UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
            
        } else {
            
            NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            chatId=[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database)];
            
            self.zChatId=chatId;
            self.threadId=thread;
            
        }
        sqlite3_finalize(compiledStatement);
        
		
	}
    
    NSLog(@"%@",chatId);
    
    return chatId;
    
    
}
-(void)checkAndSaveUserDetailFromLocalDB:(NSString*)UserId UserName:(NSString*)UserName UserImage:(NSString*)UserImage
{
    NSString *uId=@"";
    
    NSString *sqlStatement =[NSString stringWithFormat:@"SELECT UserId FROM tbl_user where UserId='%@'",UserId];
    
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
    {
        while (sqlite3_step(compiledStatement)==SQLITE_ROW)
        {
            uId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            NSLog(@"%@",uId);
        }
        
    }
    sqlite3_finalize(compiledStatement);
    
    if ([uId isEqualToString:@""]) {
        
        const char *sqlStatement = "Insert into tbl_user (UserId,UserName,UserImage,DisplayName,EmailId,PhoneNo,Gender,Dob,Rating,Unpaid_revenue) values(?,?,?,?,?,?,?,?,?,?)";
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text( compiledStatement, 1, [UserId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [UserName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [UserImage UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 4, [@""  UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 6, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text( compiledStatement, 7, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 8, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text( compiledStatement, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 10, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        } else {
            
            NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            
        }
        sqlite3_finalize(compiledStatement);
    }
    
    else
    {
        NSString *sqlStatement1=[NSString stringWithFormat:@"update tbl_user set UserId = '%@',UserName = '%@',UserImage='%@' where UserId= '%@'",UserId,UserName,UserImage,UserId];
        
        NSLog(@"%@",sqlStatement1);
        
        const char *sqlStatement=[sqlStatement1 UTF8String];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            int success = sqlite3_step(compiledStatement);
            
            if (success == SQLITE_ERROR) {
                
                NSLog(@"updateUserDetailOnLocalDB error");
                
                
            }
            else
            {
                
                NSLog(@"updateUserDetailOnLocalDB success");
            }
            
            
        }
        
        sqlite3_finalize(compiledStatement);
    }
}
#pragma Mark--------------
#pragma Webservice delegate

-(void)SendChatInvocationDidFinish:(SendChatInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    
    if (result==nil || result==(NSString*)[NSNull null]) {
        
    }
    else
    {
        
        checkType=@"old";
        
    }
    imageData=nil;
    
    
    
}
-(void)ChatDetailInvocationDidFinish:(ChatDetailInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    checkPN=@"YES";
    
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[result objectForKey:@"ChatDetail"];
        NSMutableArray *requestArray=[result objectForKey:@"request_data"];
        
        NSLog(@"%d",[responseArray count]);
        
        if ([requestArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"friend_id",@"block_status",@"friend_image",@"friend_name",@"friend_status",@"totalMessage",nil];
            
            for (NSMutableArray *arrValue in requestArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                [AppDelegate sharedAppDelegate].friendStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"friend_status"]];
                self.blockStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"block_status"]];
                self.totalRecord=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"totalMessage"]];
                
            }
            [arrOfResponseField release];
            
        }
        
        if ([responseArray count]>0) {
            
            NSString *thread=@"";
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"friend_id",@"chat_type",@"username",@"image",@"message",@"msgid",@"status",@"date",@"friend_status",@"image_url",@"audio_url",@"namecard_id",@"namecard_image",@"namecard_usename",@"thread_id",@"type",@"timestamp",@"static",@"request_status",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                NSString *senderId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"friend_id"]];
                self.lastMsgId=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"msgid"]];
                NSString *message=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"message"]];
                NSString *messageType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"type"]];
                NSString *date=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"timestamp"]];
                NSString *chatType=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"chat_type"]];
                NSString *postImageUrl=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"image_url"]];
                NSString *postAudioUrl=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"audio_url"]];
                NSString *nameCard=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"namecard_id"]];
                NSString *nameCardImage=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"namecard_image"]];
                NSString *nameCardName=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"namecard_usename"]];
                thread=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"thread_id"]];
                NSString *userName=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"username"]];
                NSString *userImage=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"image"]];
                NSString *staticMsg=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"static"]];
                NSString *requestStatus=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"request_status"]];
                
                NSString *nameCardImageurl=@"";
                
                if (nameCardImage==nil || nameCardImage==(NSString*)[NSNull null] || [nameCardImage isEqualToString:@""]) {
                    
                    nameCardImageurl=@"";
                }
                else
                {
                    nameCardImageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,nameCardImage];
                    
                }
                
                
                NSString *savedAudioPath=@"";
                NSString *savedImagePath=@"";
                
                NSLog(@"%d",[postImageUrl length]);
                NSLog(@"%@",postImageUrl);
                
                if (![self.lastMsgId isEqualToString:self.checkLastMsgIdStr]) {
                    
                    if ([chatType isEqualToString:@"2"]) {
                        
                        NSString *imageUrl=[NSString stringWithFormat:@"%@%@",gOriginalPostImageUrl,postImageUrl];
                        
                        NSLog(@"%@",imageUrl);
                        
                        NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                        
                        NSDate *date1 = [NSDate date];
                        time_t interval = (time_t) [date1 timeIntervalSince1970];
                        NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
                        
                        NSString *timestampStr = [NSString stringWithFormat:@"%ld%f", interval,timeInMiliseconds];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        
                        documentsDirectory=[documentsDirectory stringByAppendingPathComponent:timestampStr];
                        savedImagePath = [documentsDirectory stringByAppendingFormat:@"%@",@"savedImage.jpg"];
                        [imgData writeToFile:savedImagePath atomically:NO];
                    }
                    
                    if ([chatType isEqualToString:@"3"]) {
                        
                        NSString *audioUrl=[NSString stringWithFormat:@"%@%@",gPostMp3AudioUrl,postAudioUrl];
                        
                        NSData *audioData=[NSData dataWithContentsOfURL:[NSURL URLWithString:audioUrl]];
                        
                        NSDate *date2 = [NSDate date];
                        time_t interval1 = (time_t) [date2 timeIntervalSince1970];
                        NSTimeInterval timeInMiliseconds1 = [[NSDate date] timeIntervalSince1970];
                        
                        NSString *timestampStr1= [NSString stringWithFormat:@"%ld%f", interval1,timeInMiliseconds1];
                        NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                        
                        documentsDirectory1=[documentsDirectory1 stringByAppendingPathComponent:timestampStr1];
                        savedAudioPath = [documentsDirectory1 stringByAppendingFormat:@"%@",@"savedAudio.m3u8"];
                        [audioData writeToFile:savedAudioPath atomically:NO];
                        
                    }
                    
                    if ([chatType isEqualToString:@"4"]) {
                        
                        NSMutableArray *NameCardArray=[[NSMutableArray alloc] initWithObjects:nameCard,nameCardName,nameCardImageurl,nil];
                        
                        [self performSelectorOnMainThread:@selector(checkNameCardUser:) withObject:NameCardArray waitUntilDone:YES];
                        
                    }
                    
                    NSString *userImageUrl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,userImage];
                    
                    [self checkAndSaveUserDetailFromLocalDB:senderId UserName:userName UserImage:userImageUrl];
                    
                    
                    NSString *chatId=@"";
                    
                    if ([self.groupType isEqualToString:@"0"]) {
                        
                        chatId=[self checkAndCreateThreadIDFromLocalDB:thread];
                        
                    }
                    else
                    {
                        chatId=[self checkAndCreateGroupThreadIDFromLocalDB:thread];
                    }
                    if ([messageType isEqualToString:@"Receiver"]) {
                        
                        [self performSelectorOnMainThread:@selector(saveLastMsgIdOnLocalDB:) withObject:thread waitUntilDone:YES];
                        
                    }
                    
                    NSMutableArray *array=[[NSMutableArray alloc] initWithObjects:senderId,messageType,chatId,date,message,chatType,savedImagePath,savedAudioPath,nameCard,staticMsg,requestStatus,nil];
                    
                    
                    [self performSelectorOnMainThread:@selector(saveChatDataInTable:) withObject:array waitUntilDone:YES];
                    
                }
                
            }
            
            [arrOfResponseField release];
            
            [self setRequestValue];
            [self displayChatDataFromLocalDB];
            
        }
        else
        {
            [self setRequestValue];
            
            if ([self.groupType isEqualToString:@"0"]) {
                
                NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id,ZMsgId FROM tbl_chatUser where chatUserId='%@' and chatFriendId= '%@' or chatUserId='%@' and chatFriendId= '%@' ",gUserId,self.friendId,self.friendId,gUserId];
                
                NSLog(@"%@",sqlStatement);
                
                sqlite3_stmt *compiledStatement;
                if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
                {
                    while (sqlite3_step(compiledStatement)==SQLITE_ROW)
                    {
                        self.zChatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                        self.threadId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                        
                        NSLog(@"%@",self.zChatId);
                        NSLog(@"%@",self.threadId);
                    }
                    
                }
            }
            else
            {
                NSLog(@"%@",self.groupId);
                
                NSString *sqlStatement =[NSString stringWithFormat:@"SELECT Id,ZMsgId FROM tbl_chatUser where chatUserId='%@' and chatFriendId='%@' ",self.groupId,@"0"];
                
                sqlite3_stmt *compiledStatement;
                if (sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database,[sqlStatement cStringUsingEncoding:NSUTF8StringEncoding],-1,&compiledStatement,NULL )==SQLITE_OK)
                {
                    while (sqlite3_step(compiledStatement)==SQLITE_ROW)
                    {
                        self.zChatId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                        NSString *threadIdStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                        
                        self.threadId=[NSString stringWithFormat:@"%@",threadIdStr];
                        
                        NSLog(@"%@",self.zChatId);
                    }
                    
                }
                sqlite3_finalize(compiledStatement);
                
            }
            
            [self performSelectorOnMainThread:@selector(displayChatDataFromLocalDB) withObject:nil waitUntilDone:YES];
            
        }
        
    }
    
    moveTabG=FALSE;
    checkDisapper=TRUE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)DeleteChatInvocationDidFinish:(DeleteChatInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    
}

-(void)AddContactListInvocationDidFinish:(AddContactListInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [AppDelegate sharedAppDelegate].friendStatus=@"1";
        [self setRequestValue];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)BlockInvocationDidFinish:(BlockInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        blockStr=self.blockStatus;
        [blockButton setTag:[blockStr intValue]];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        self.blockStatus=blockStr;
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setRequestValue];
    
    
}
-(void)AcceptRejectOwnerRequestInvocationDidFinish:(AcceptRejectOwnerRequestInvocation *)invocation withResults:(NSString *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    if (result==nil || result==(NSString*)[NSNull null] || [result isEqualToString:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        NSString *sqlStatement1=[NSString stringWithFormat:@"delete from tbl_chat where MessageId='%@'",self.deleteMsgId];
        NSLog(@"%@",sqlStatement1);
        
        if (sqlite3_exec([AppDelegate sharedAppDelegate].database, [sqlStatement1 cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL)  == SQLITE_OK)
        {
            NSLog(@"success");
            
            
        }
        [service ChatDetailInvocation:gUserId friendId:self.friendId lastmsgId:self.lastMsgId type:[AppDelegate sharedAppDelegate].chatDetailType groupType:self.groupType groupId:self.groupId page:@"" delegate:self];
        
        
        
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1 {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self useImage:image];
    
}

- (void)useImage:(UIImage*)theImage
{
    
    UIImage *img=[theImage imageByScalingAndCroppingForSize:CGSizeMake(400, 400)];
    self.imageData = UIImageJPEGRepresentation(img, 0.1);
    
    NSDate *date = [NSDate date];
    time_t interval = (time_t) [date timeIntervalSince1970];
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    
    NSString *timestampStr = [NSString stringWithFormat:@"%ld%f", interval,timeInMiliseconds];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory=[documentsDirectory stringByAppendingPathComponent:timestampStr];
    NSString *savedImagePath = [documentsDirectory stringByAppendingFormat:@"%@",@"savedImage.jpg"];
    [self.imageData writeToFile:savedImagePath atomically:NO];
    
    [self performSelectorOnMainThread:@selector(SendChatOnLocalDB:) withObject:[[NSMutableArray alloc]initWithObjects:savedImagePath,@"2", nil] waitUntilDone:YES];
    
}
-(void)uploadImage
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue,
                   ^{
                       
                       dispatch_sync(dispatch_get_main_queue(),
                                     ^{
                                         NSArray *formfields = [NSArray arrayWithObjects:@"type",nil];
                                         
                                         NSArray *formvalues = [NSArray arrayWithObjects:@"2",nil];
                                         NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
                                         
                                         NSLog(@"%@",textParams);
                                         
                                         NSArray *photo = [NSArray arrayWithObjects:@"myimage1.png",nil];
                                         
                                         NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
                                         
                                         NSLog(@"%@",compositeData);
                                         
                                         
                                         [self performSelector:@selector(doPostWithImage:) withObject:compositeData afterDelay:0.1];
                                         NSLog(@"doPostWithImage1");
                                         
                                         
                                     });
                   });
    

    
   
	
}
- (void) doPostWithImage: (NSArray *) compositeData
{
    NSLog(@"doPostWithImage");
    
    if (results==nil) {
        
        results=[[NSMutableDictionary alloc] init];
    }
    
    NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSArray * _photo = [compositeData objectAtIndex:1];
    
    NSLog(@"doPostWithImage1");

	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"uploadmedia"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",imageData.length);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
    for (int i=0; i<[_photo count]; i++) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"2.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        
        // [body appendData:[NSData dataWithData:data]];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    for (id key in _textParams) {
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:[_textParams objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	
	NSLog(@"%@",returnString);
	
    [MBProgressHUD  hideHUDForView:self.view animated:YES];
    
	results=[returnString JSONValue];
	
	NSLog(@"%@",results);
    
    NSDictionary *responseDic=[results objectForKey:@"response"];
	
	if ([results count]>0) {
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strImageName=[responseDic objectForKey:@"image"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            
        }
        else
        {
            uploadFileName=strImageName;
            
           // NSData* msgData=[@"[Image File]" dataUsingEncoding:NSUTF8StringEncoding];
           // NSString *base64String = [QSStrings encodeBase64WithData:msgData];
            
            NSString *base64String=@"[Image File]";
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [service SendChatInvocation:gUserId friendId:self.friendId message:base64String type:@"2" imageName:uploadFileName audioName:@"" namecardId:@"" threadId:self.threadId groupId:self.groupId groupType:self.groupType publicPrivateType:[AppDelegate sharedAppDelegate].checkPublicPrivateStatus delegate:self];
            }
        }
    }
    
}

-(void)uploadAudio
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
     dispatch_async(queue,
     ^{
     
     dispatch_sync(dispatch_get_main_queue(),
     ^{
         //[self performSelector:@selector(doPostWithAudio:) withObject:compositeData afterDelay:0.1];

         NSArray *formfields = [NSArray arrayWithObjects:@"type",nil];
         
         NSArray *formvalues = [NSArray arrayWithObjects:@"3",nil];
         NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
         
         NSLog(@"%@",textParams);
         
         NSArray *photo = [NSArray arrayWithObjects:@"recording.caf",nil];
         
         NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
         

         [self doPostWithAudio:compositeData];
          
     });
     });
     
     

    
}
- (void) doPostWithAudio: (NSArray *) compositeData
{
    if (results==nil) {
        
        results=[[NSMutableDictionary alloc] init];
    }
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    
    NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSArray * _photo = [compositeData objectAtIndex:1];
    
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"uploadmedia"];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
    for (int i=0; i<[_photo count]; i++) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"audiofile\"; filename=\"1.caf\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"%d",self.imageData.length);
        
        [self.imageData retain];
        
        [body appendData:[NSData dataWithData:self.imageData]];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    for (id key in _textParams) {
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:[_textParams objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
    
	responseData = [[NSMutableData data] retain];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
   /* NSURLConnection * connection = [[NSURLConnection alloc]
                                    initWithRequest:request
                                    delegate:self startImmediately:NO];
    
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSDefaultRunLoopMode];
    [connection start];*/
   /* NSError *error=nil;
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    
	NSLog(@"%@",returnString);
    
    if(error)
    {
        NSLog(@"%@",[error description]);
    
    }
	
	results=[returnString JSONValue];
	
	NSLog(@"%@",results);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSDictionary *responseDic=[results objectForKey:@"response"];
	
	if ([results count]>0) {
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strAudioName=[responseDic objectForKey:@"audio"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            
        }
        else
        {
            uploadFileName=strAudioName;
            
            NSString *base64String=@"[Audio File]";

            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [service SendChatInvocation:gUserId friendId:self.friendId message:base64String type:@"3" imageName:uploadFileName audioName:@"" namecardId:@"" threadId:self.threadId groupId:self.groupId groupType:self.groupType publicPrivateType:[AppDelegate sharedAppDelegate].checkPublicPrivateStatus delegate:self];
            }
        }
        
    }*/
    
    [pool release];

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	[responseData setLength:0];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[responseData appendData:data];
	[responseData retain];
    
    NSLog(@"%d",responseData.length);
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	   
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	moveTabG=FALSE;
    
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	   
	results=[[NSMutableDictionary alloc] init];
	
	responseString= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseString retain];
    
    NSLog(@"%@",responseString);
	
	results = [responseString JSONValue];
	[responseData release];
	
 	NSLog(@"%@",results);
	
    NSDictionary *responseDic=[results objectForKey:@"response"];
	
	if ([results count]>0) {
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strAudioName=[responseDic objectForKey:@"audio"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            
        }
        else
        {
            uploadFileName=strAudioName;
            
            NSString *base64String=@"[Audio File]";
            
            int status=[[AppDelegate sharedAppDelegate] netStatus];
            
            if(status==0)
            {
                [service SendChatInvocation:gUserId friendId:self.friendId message:base64String type:@"3" imageName:uploadFileName audioName:@"" namecardId:@"" threadId:self.threadId groupId:self.groupId groupType:self.groupType publicPrivateType:[AppDelegate sharedAppDelegate].checkPublicPrivateStatus delegate:self];
            }
        }
        
    }
	
    [MBProgressHUD hideHUDForView:self.view animated:YES];

	moveTabG=FALSE;
	
}

-(NSString *)documentsDirectoryPath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentPath = [dirPaths objectAtIndex:0];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.documentPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.documentPath
								  withIntermediateDirectories:NO
												   attributes:nil
														error:NULL];
    }
    return self.documentPath;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    NSLog(@"%@",self.totalRecord);
    
    if ([self.checkScroll isEqualToString:@"YES"]) {
        
        NSInteger totalrecord=[self.totalRecord intValue];
        NSInteger count=[self.arrChatData count];
        
        NSLog(@"%f",[scrollView contentOffset].y);
       
        if ([scrollView contentOffset].y==-64) {
            
            NSLog(@"count %d",count);
            NSLog(@"totalrecord %d",totalrecord);
            
            if (count < totalrecord)
            {
                offset = scrollView.contentOffset.y;
                
                checkTablePosition=@"NO";
                page=page+1;
                
                NSString *pageStr=[NSString stringWithFormat:@"%d",page];
                
                NSLog(@"%@",pageStr);
                checkScroll=@"NO";
               
                [self displayChatDataFromLocalDB];
                
            }
        }
    }
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
}

-(void)viewWillDisappear:(BOOL)animated
{
    [objImageCache cancelDownload];
    objImageCache=nil;
    checkDisapper=FALSE;
    checkPN=@"NO";
    service=nil;
    [audioPlayer stop];
    

    if (checkAddress==TRUE) {
        
        [self.textView resignFirstResponder];
        
    }
    
    NSLog(@"viewWillDisappear");
}

-(void)viewDidUnload
{
    _arrChatData=nil;
    _arrTempChatData=nil;
    
    self.threadId=nil;
    self.friendId=nil;
    self.uploadFileName=nil;
    self.documentPath=nil;
    self.blockStatus=nil;
    self.zChatId=nil;
    self.recorderFilePath=nil;
    self.imageData=nil;
    self.totalRecord=nil;
    
    self.friendUserName=nil;
    self.friendUserImage=nil;
    self.groupType=nil;
    self.groupId=nil;
    
    self.timeinNSString=nil;
    self.lastMsgId=nil;
    self.deleteMsgId=nil;
    self.checkType=nil;
    self.checkScroll=nil;
    
}

-(void)dealloc
{
    self.threadId=nil;
    self.friendId=nil;
    self.uploadFileName=nil;
    self.documentPath=nil;
    self.blockStatus=nil;
    self.zChatId=nil;
    self.recorderFilePath=nil;
    self.imageData=nil;
    self.totalRecord=nil;
    
    self.friendUserName=nil;
    self.friendUserImage=nil;
    self.groupType=nil;
    self.groupId=nil;
    
    self.timeinNSString=nil;
    self.lastMsgId=nil;
    self.deleteMsgId=nil;
    self.checkType=nil;
    self.checkScroll=nil;
    
    [_arrChatData release];
    [_arrTempChatData release];
    
    [super dealloc];
}


@end

