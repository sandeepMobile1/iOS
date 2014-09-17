//
//  FriendProfileViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 10/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "AddContactListInvocation.h"
#import "FriendProfileInvocation.h"
#import "ClearIndivisualChatInvocation.h"

@interface FriendProfileViewController : UIViewController <ImageCacheDelegate,AddContactListInvocationDelegate,FriendProfileInvocationDelegate,ClearIndivisualChatInvocationDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    
    IBOutlet UIScrollView *scrollView;
    
    ImageCache *objImageCache;
    
    UIAlertView *addContactAlert;
    
    IBOutlet UILabel *lbluserName;
    IBOutlet UILabel *lblDispName;
    IBOutlet UILabel *lblEmail;
    IBOutlet UILabel *lblPhoneNumber;
    IBOutlet UILabel *lblGender;
    IBOutlet UILabel *lblDob;
    IBOutlet UILabel *lblNumOfGroup;
    IBOutlet UILabel *lblGroup;
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *btnRating1;
    IBOutlet UIButton *btnRating2;
    IBOutlet UIButton *btnRating3;
    IBOutlet UIButton *btnRating4;
    IBOutlet UIButton *btnRating5;
    IBOutlet UINavigationBar *navigation;
    
    IBOutlet UIButton *btnAddContacts;
    IBOutlet UIButton *btnEdit;
    IBOutlet UIButton *btnChat;
    
    IBOutlet UIImageView *imgBackView;
    IBOutlet UITextView *txtIntro;
    
    NSString *ratingStr;
    ConstantLineServices *service;
     NSString *checkPN;
    
    UIAlertView *clearAlert;
     UIAlertView *clearSuccessAlert;
    
    IBOutlet UIButton *btnClear;
    
    UITextView *alertTextField;
    int totalCharacterCount;

}
@property(nonatomic,retain) NSMutableArray *arrUserProfileData;
@property(nonatomic,retain) NSMutableArray *arrImageAudioPath;


@property(nonatomic,retain) NSString *ratingStr;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *navTitle;
@property(nonatomic,retain) NSString *checkView;
@property(nonatomic,retain) NSString *checkChatButtonStatus;
@property(nonatomic,retain) NSString *threadId;

-(IBAction)btnratingPressed1:(id)sender;
-(IBAction)btnratingPressed2:(id)sender;
-(IBAction)btnratingPressed3:(id)sender;
-(IBAction)btnratingPressed4:(id)sender;
-(IBAction)btnratingPressed5:(id)sender;
-(IBAction)btnAddContactPressed:(id)sender;
-(IBAction)btnClearPressed:(id)sender;

-(void)setvalues;
-(void)setRating;
-(void)setImage;
-(void)getAllImagePath;
-(void)getAllAudioPath;
-(void)deleteAllChat;

-(void)removeALlImageAudioFromPlist;

@end

