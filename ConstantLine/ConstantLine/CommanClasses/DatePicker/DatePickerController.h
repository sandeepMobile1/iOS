//
//  Date_Picker_View.h
//  IPROMOT
//
//  Created by Adminmac on 17/12/12.
//  Copyright (c) 2012 ipromot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerControllerDelegate<NSObject>
-(void)GetDate:(NSDate *)Selected_DOB;
-(void)hideToolBar_With_Done;
-(void)hideToolBar_With_Cancel;
@end

@interface DatePickerController :UIView{
     
    UISegmentedControl *control;
    
    id <DatePickerControllerDelegate> delegate;
    
}
@property(nonatomic,strong)id <DatePickerControllerDelegate> delegate;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic, strong)UIDatePicker *pickerView;
@property(nonatomic, strong)UIToolbar *toolBar;

-(void)createDatePickerView;
@end
