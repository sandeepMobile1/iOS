//
//  Date_Picker_View.m
//  IPROMOT
//
//  Created by Adminmac on 17/12/12.
//  Copyright (c) 2012 ipromot. All rights reserved.
//

#import "DatePickerController.h"
//#import "HighResolution.h"
@implementation DatePickerController
@synthesize delegate;
@synthesize isOpen;
@synthesize toolBar,pickerView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createDatePickerView];
    }
    return self;
}
-(void)createDatePickerView{

    self.pickerView=[[[UIDatePicker alloc] initWithFrame:CGRectMake(0,44,self.frame.size.width,216)]autorelease];
    self.pickerView.datePickerMode=UIDatePickerModeDate;
    [self.pickerView addTarget:self action:@selector(picker_Select_Date) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pickerView];
    

    self.toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0,0, self.pickerView.frame.size.width, 44)]autorelease];
    self.toolBar.barStyle=UIBarStyleBlackOpaque;
   
   

    UIBarButtonItem *cancel=[[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_Btn_Click)] autorelease];
    UIBarButtonItem *done=[[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done_Btn_Click)] autorelease];
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    [self.toolBar setItems:[NSArray arrayWithObjects:cancel,flex,done, nil]];
    [toolBar setHidden:NO];
    [self addSubview:self.toolBar];
    //[self addSubview:toolBar];
    

}
-(void)picker_Select_Date{
    if([self.delegate respondsToSelector:@selector(GetDate:)]){
        //[self.delegate GetDate:pickerView.date];
    }
    
}
-(void)cancel_Btn_Click{
    if([self.delegate respondsToSelector:@selector(hideToolBar_With_Cancel)]){
        [self.delegate hideToolBar_With_Cancel];
    }
    
    
}
-(void)done_Btn_Click{
    if([self.delegate respondsToSelector:@selector(hideToolBar_With_Done)]){
        [self.delegate hideToolBar_With_Done];
        [self.delegate GetDate:pickerView.date];
    }
}
@end
