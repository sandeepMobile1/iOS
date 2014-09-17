//
//  StartGroupViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartGroupViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextView *txtView;
    IBOutlet UIImageView *imgGroup;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationBar *navigation;
    
    IBOutlet UILabel     *lblTrialPeriod;
    IBOutlet UILabel     *lblSubscription;
    IBOutlet UITextField *txtTrialPeriod;
    IBOutlet UITextField *txtSubscription;
    IBOutlet UITextField *txtcharge;
    IBOutlet UIImageView *imgSubscriptionArrow;
    
    IBOutlet UIImageView *imgMemberShip;
    IBOutlet UIImageView *imgTrial;
    IBOutlet UIImageView *imgMonthly;
    IBOutlet UIImageView *imgPrice;

    
    UIAlertView *imageAlert;
    NSMutableDictionary *results;

    int totalCharacterCout;
    
    UIAlertView *successAlert;
    
    NSString *groupCreatedDate;
    
    UIPopoverController *popoverController;
    
    IBOutlet UILabel *lblMemberSelected;
    
    IBOutlet UIButton *btnPublic;
    IBOutlet UIButton *btnPrivate;
    
    NSString *groupStatus;
    
    IBOutlet UILabel *lblUploadImage;
    IBOutlet UILabel *lblTapTo;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIToolbar *toolBar;

    NSMutableArray *pickerArray;
    NSString *checkPickerView;
    
    IBOutlet UIView *popOverView;
    IBOutlet UIImageView *imgPopOverView;
    IBOutlet UIImageView *imgBackPopOverView;
    IBOutlet UIScrollView *popOverScroll;

    IBOutlet UITextField *txtMemberShip;
}

@property(nonatomic,retain)NSString *localImageName;
@property(nonatomic,retain)NSData   *imageData;
@property(nonatomic,retain)NSString *groupUniqueMember;
@property(nonatomic,retain)NSString *groupId;

-(IBAction)btnAddMembersPressed:(id)sender;
-(IBAction)btnSubscriptionPressed:(id)sender;
-(IBAction)btnProfileImagePressed:(id)sender;
-(IBAction)btnTrialPressed:(id)sender;
-(IBAction)btnMonthlyFeePressed:(id)sender;
-(IBAction)btnchargePressed:(id)sender;
-(IBAction)btnDetailsPressed:(id)sender;
-(IBAction)btnOkPressed:(id)sender;
-(IBAction)btnCancelPressed:(id)sender;

- (void)scrollViewToCenterOfScreen:(UIView *)theView;

-(void)saveGroupDetailOnLocalDB;
-(void)saveGroupMemberOnLocalDB;

-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message;
-(BOOL)checkGroupData;

- (void) doPostWithText: (NSArray *) compositeData;
-(void)uploadData;
-(void)uploadImage;
- (void) doPostWithImage: (NSArray *) compositeData;
- (void)useImage:(UIImage*)theImage;
-(NSString *) genRandStringLength: (int) len;
@end
