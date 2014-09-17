//
//  RegistrationViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationInvocation.h"
#import "ConstantLineServices.h"
#import "DatePickerController.h"

@interface RegistrationViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DatePickerControllerDelegate,UIPopoverControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    ConstantLineServices *service;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtDisplayName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConpassword;
    IBOutlet UITextField *txtdob;
        
     UIPopoverController *popoverController;
    
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
    
   // DatePickerController *datePicker;
    NSDateFormatter  *dateForMater;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIToolbar *toolBar;

    
    NSString *phoneNo;
    IBOutlet UINavigationBar *navigation;
    
    BOOL insertFlag;
    NSString *localImageName;
    NSString *serverImageName;
    NSString *imageId;

    IBOutlet UILabel *lblUploadImage;
    IBOutlet UILabel *lblTapTo;
    
    NSInteger minYear ;
    NSInteger maxYear ;
}

@property(nonatomic,retain) IBOutlet UIButton *btnMale;
@property(nonatomic,retain) IBOutlet UIButton *btnFemale;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain)NSData *imageData;
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSIndexPath *todayIndexPath;

-(void)nameOfYears;
-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)todayPath;
-(NSInteger)bigRowYearCount;
-(NSString *)currentYearName;


-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message;

-(IBAction)MaleButtonClick:(UIButton*)sender;
-(IBAction)FemaleButtonClick:(UIButton*)sender;
-(IBAction)btnRegisterPressed:(id)sender;

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
-(void)saveDataInLocalDB;



@end
