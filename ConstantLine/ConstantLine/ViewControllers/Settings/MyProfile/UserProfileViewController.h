//
//  UserProfileViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "UserProfileInvocation.h"

@interface UserProfileViewController : UIViewController <ImageCacheDelegate,UserProfileInvocationDelegate>

{
    IBOutlet UIScrollView *scrollView;
    
    ImageCache *objImageCache;
    
    IBOutlet UILabel *lbluserName;
    IBOutlet UILabel *lblDispName;
    IBOutlet UILabel *lblEmail;
    IBOutlet UILabel *lblContactEmail;
    IBOutlet UILabel *lblGender;
    IBOutlet UILabel *lblDob;
    IBOutlet UILabel *lblNumOfGroup;
    IBOutlet UILabel *lblGroup;
    IBOutlet UILabel *lblPassword;

    
    IBOutlet UIImageView *imgView;
    IBOutlet UIImageView *imgBackView;
    IBOutlet UITextView *txtIntro;

    IBOutlet UIButton *btnRating1;
    IBOutlet UIButton *btnRating2;
    IBOutlet UIButton *btnRating3;
    IBOutlet UIButton *btnRating4;
    IBOutlet UIButton *btnRating5;
    IBOutlet UINavigationBar *navigation;
    
    IBOutlet UIButton *btnAddContacts;
    IBOutlet UIButton *btnEdit;
    IBOutlet UIButton *btnChat;
    
    
    NSString *ratingStr;
    ConstantLineServices *service;
    
    
}
@property(nonatomic,retain) NSMutableArray *arrUserProfileData;
@property(nonatomic,retain) NSString *ratingStr;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *navTitle;
@property(nonatomic,retain) NSString *checkBackButton;

-(IBAction)btnratingPressed1:(id)sender;
-(IBAction)btnratingPressed2:(id)sender;
-(IBAction)btnratingPressed3:(id)sender;
-(IBAction)btnratingPressed4:(id)sender;
-(IBAction)btnratingPressed5:(id)sender;

-(void)setvalues;
-(void)setRating;
-(void)setImage;

@end
