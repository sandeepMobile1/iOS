//
//  SubscriptionPlanViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionPlanViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UINavigationBar *navigation;
    IBOutlet UILabel *lblSubscriptionPeriod;
    IBOutlet UILabel *lblCharge;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIToolbar *toolBar;

   // NSMutableArray *arrFirstComponantList;
   // NSMutableArray *arrSecondComponantList;
    
    NSMutableArray *pickerArray;
    NSString *checkPickerView;
    
}

@property(nonatomic,retain)NSString *planStr;
@property(nonatomic,retain)NSString *chargeStr;

-(IBAction)btnSubscriptionPressed:(id)sender;
-(IBAction)btnChargePressed:(id)sender;

@end
