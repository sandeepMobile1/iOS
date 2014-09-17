//
//  EditProfileViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DatePickerController.h"
#import "ConstantLineServices.h"
#import "ImageCache.h"
#import "UserProfileInvocation.h"

@interface EditProfileViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageCacheDelegate,UserProfileInvocationDelegate,UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    ConstantLineServices *service;
    ImageCache *objImageCache;

    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextField *txtChangePassword;
    IBOutlet UITextField *txtDisplayName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtContactEmail;
    IBOutlet UITextField *txtConpassword;
    IBOutlet UITextField *txtdob;
    IBOutlet UITextField *txtPassword;

    IBOutlet UIButton *btnRating1;
    IBOutlet UIButton *btnRating2;
    IBOutlet UIButton *btnRating3;
    IBOutlet UIButton *btnRating4;
    IBOutlet UIButton *btnRating5;

    IBOutlet UIImageView *imgView;
    
    UIAlertView *successAlert;
    
    IBOutlet UIToolbar *keyboardtoolbar;
	NSArray				*fieldsArray;
	IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
	int movementDistance;
	float movementDuration;
    
    UIAlertView *imageAlert;
    
    NSMutableDictionary *results;
    
    NSString *genderStr;
    
    //DatePickerController *datePicker;
    NSDateFormatter  *dateForMater;
    UIToolbar *toolBar;
    IBOutlet UIPickerView *pickerView;

    NSString *phoneNo;
    IBOutlet UINavigationBar *navigation;
    
    NSString *ratingStr;

    IBOutlet UILabel *lblNumOfGroup;
    
    NSString *localImageName;

    UIPopoverController *popoverController;

    IBOutlet UILabel *lblUploadImage;
    IBOutlet UILabel *lblTapTo;
    IBOutlet UITextView *txtIntro;

    int totalCharacterCout;
    
    NSInteger minYear ;
    NSInteger maxYear ;
    
    NSInteger bigRowCount;
    CGFloat rowHeight;
    NSInteger numberOfComponents;

}
@property(nonatomic,retain) IBOutlet UIButton *btnMale;
@property(nonatomic,retain) IBOutlet UIButton *btnFemale;
@property(nonatomic,retain) NSMutableArray *arrUserProfileData;
@property(nonatomic,retain) NSString *serverImageName;
@property(nonatomic,retain) NSData *imageData;
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSIndexPath *todayIndexPath;

-(void)nameOfYears;
-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)todayPath;
-(NSInteger)bigRowYearCount;
//-(NSString *)currentMonthName;
-(NSString *)currentYearName;


-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message;

-(IBAction)MaleButtonClick:(UIButton*)sender;
-(IBAction)FemaleButtonClick:(UIButton*)sender;
-(IBAction)btnSavePressed:(id)sender;
-(IBAction)btnCancelPressed:(id)sender;

- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextview;
-(BOOL)checkDataAndRegister;
-(IBAction)btnProfileImagePressed:(id)sender;

- (void) doPostWithText: (NSArray *) compositeData;
-(void)uploadData;

- (void) doPostWithImage: (NSArray *) compositeData;
-(void)uploadImage;

- (void)useImage:(UIImage*)theImage;

-(void)setvalues;
-(void)setRating;
-(void)setImage;

-(void)updateUserDetailOnLocalDB:(NSString*)imageId;

@end
