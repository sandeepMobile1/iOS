//
//  PaypalViewController.h
//  ConstantLine
//
//  Created by Pramod Sharma on 18/11/13.
//
//

#import <UIKit/UIKit.h>
#import "ConstantLineServices.h"
#import "DatePickerController.h"
#import "SendCreditCardDetailInvocation.h"
#import "AcceptRejectGroupChatInvocation.h"

@interface PaypalViewController : UIViewController <UITextFieldDelegate,DatePickerControllerDelegate,SendCreditCardDetailInvocationDelegate,AcceptRejectGroupChatInvocationDelegate,UIAlertViewDelegate>
{
    ConstantLineServices *service;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextField *txtCreditCardName;
    IBOutlet UITextField *txtCrediCardAccount;
    IBOutlet UITextField *txtCreditCardType;
    IBOutlet UITextField *txtCreditTypeExpiryDate;
    IBOutlet UITextField *txtCrnNumber;

    UIAlertView *successAlert;
    
    IBOutlet UIToolbar *keyboardtoolbar;
	NSArray				*fieldsArray;
	IBOutlet	UIBarButtonItem		*barButton;
    
    int value;
	int movementDistance;
	float movementDuration;
    IBOutlet UINavigationBar *navigation;

    DatePickerController *datePicker;
    NSDateFormatter  *dateForMater;
    UIToolbar *toolBar;
}

@property(nonatomic,retain)NSString *groupUserTableId;
@property(nonatomic,retain)NSString *userId;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *groupOwnerId;
@property(nonatomic,retain)NSString *checkAcceptRequest;

-(IBAction)btnSubmitPressed:(id)sender;
- (IBAction) dismissKeyboard:(id)sender;
- (IBAction) next;
- (IBAction) previous;
-(void) slideFrame:(BOOL) up;
-(IBAction) slideFrameDown;
- (void)scrollViewToCenterOfScreen:(UIView *)theView;
-(void)resignTextview;
-(BOOL)checkCreditCardDaTa;
-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message;

@end
