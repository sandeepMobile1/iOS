//
//  RegistrationViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "Config.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "sqlite3.h"
#import "CommonFunction.h"
#import "QSStrings.h"
#import "UIImageExtras.h"

@implementation RegistrationViewController

const NSInteger bigRowCount = 1000;
const CGFloat rowHeight = 44.f;
const NSInteger numberOfComponents = 2;

@synthesize btnMale,btnFemale,userId,imageData,date,todayIndexPath;
@synthesize years = _years;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
   
    self.years=[[NSMutableArray alloc]init];
    
    [lblTapTo setHidden:FALSE];
    [lblUploadImage setHidden:FALSE];
   
    self.btnMale.selected=YES;
    genderStr=@"1";
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Register"];
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
  
    
    imgView.layer.cornerRadius =40;
    imgView.clipsToBounds = YES;
    
    [imgView.layer setBorderWidth:3.0];
    [imgView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    
    
    fieldsArray = [[NSArray alloc] initWithObjects:txtDisplayName,txtEmail,txtPassword,txtConpassword,txtdob,nil];
    
    scrollView.backgroundColor=[UIColor clearColor];
    
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    service=[[ConstantLineServices alloc] init];
    
        
    if (pickerView==nil) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                [scrollView setContentSize:CGSizeMake(0,150)];
                pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-86,320,200)] autorelease];
                toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-116, 320, 40)] autorelease];
            }
            else
            {
                [scrollView setContentSize:CGSizeMake(0,150)];
                pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-180,320,200)] autorelease];
                toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-220, 320, 40)] autorelease];
            }
            
            toolBar.barStyle=UIBarStyleDefault;
            pickerView.backgroundColor=[UIColor whiteColor];
            
        }
        else
        {
            [scrollView setContentSize:CGSizeMake(0,260)];
            pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-220, 320, 200)] autorelease];
            toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 40)] autorelease];
        }
        
        [pickerView setDelegate:self];
        [pickerView setShowsSelectionIndicator:TRUE];
        [self.view addSubview:pickerView];
    }
    UIBarButtonItem *btnAccessDone4 = [[[UIBarButtonItem alloc]
                                        initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnPickerDonePressed:)]autorelease];
	
	
	UIBarButtonItem *btnFlex4=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]autorelease];
    
    
    
    [toolBar setBackgroundColor:[UIColor blackColor]];
    [toolBar setItems:[NSArray arrayWithObjects:btnFlex4,btnAccessDone4,nil]];
    [toolBar setTintColor:[UIColor blackColor]];
    
    [self.view addSubview:toolBar];
    [toolBar setHidden:TRUE];
	[pickerView setHidden:TRUE];
    
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc]init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date1=[dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentdatestr=[dateFormatter stringFromDate:date1];
    
    minYear = [currentdatestr integerValue]-100;
    maxYear = [currentdatestr integerValue];
        
    [self nameOfYears];
    
    [self todayPath];

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark--------
#pragma picker methods
-(IBAction)btnPickerDonePressed:(id)sender
{
    NSString *selectedStr=[self.years objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    [pickerView setHidden:TRUE];
    [toolBar setHidden:TRUE];
    txtdob.text=[NSString stringWithFormat:@"%@",selectedStr];
            
  
}
-(NSDate *)date
{
    NSString *year = [self.years objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy"];
    NSDate *date1 = [formatter dateFromString:[NSString stringWithFormat:@"%@",year]];
    return date1;
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return 300;
}

-(UIView *)pickerView: (UIPickerView *)pickerView
           viewForRow: (NSInteger)row
         forComponent: (NSInteger)component
          reusingView: (UIView *)view
{
    BOOL selected = NO;
    
    NSString *yearName = [self.years objectAtIndex:row];
    NSString *currenrYearName  = [self currentYearName];
    if([yearName isEqualToString:currenrYearName] == YES)
    {
        selected = YES;
    }
    
    UILabel *returnView = nil;
    if(view.tag == 43)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent: component selected: selected];
    }
    returnView.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.years count];
}

#pragma mark - Util


-(NSInteger)bigRowYearCount
{
    return [self.years count]  * bigRowCount;
}


-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.years objectAtIndex:row];
}


-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
    
    CGRect frame = CGRectMake(0.f, 0.f,300,rowHeight);
    
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.userInteractionEnabled = NO;
    
    label.tag = 43;
    
    return label;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

-(NSArray *)nameOfMonths
{
    return @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
}

-(void)nameOfYears
{
    
    for(NSInteger year = minYear; year <= maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%i", year];
        [self.years addObject:yearStr];
    }
}
-(void)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    NSString *year  = [self currentYearName];
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            row = [self.years indexOfObject:cellYear];
            [pickerView selectRow:row inComponent:0 animated:YES];
            break;
        }
    }
    
}


-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

-(void)backButtonClick:(UIButton *)sender{
    
    [self resignTextview];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)checkDataAndRegister{
    
    
    txtDisplayName.text= [txtDisplayName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtEmail.text= [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtPassword.text= [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtConpassword.text= [txtConpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
 
    if ([txtDisplayName.text length]<=0 || txtDisplayName.text == nil || [txtDisplayName.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter Screen name"];
        return NO;
    }
    
    if ([txtDisplayName.text length]<3 || [txtDisplayName.text length]>25)
    {
        [self showAlertViewWithTitel:@"" Message:@"Screen name should be at least 3 Characters and maximum 25 Characters"];
        return NO;
    }
    if ([txtEmail.text length]<=0 || txtEmail.text == nil || [txtEmail.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter email id "];
        return NO;
    }
    
    if ([txtPassword.text length]<=0 || txtPassword.text == nil || [txtPassword.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter your password"];
        return NO;
    }
    if ([txtConpassword.text length]<=0 || txtConpassword.text == nil || [txtConpassword.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter confirm password"];
        return NO;
    }
    if ([txtdob.text length]<=0 || txtdob.text == nil || [txtdob.text isEqual:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter date of birth"];
        return NO;
    }
    if ([genderStr length]<=0 || genderStr == nil || [genderStr isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please select gender"];
        return NO;
    }
    
    if (!validateEmail(txtEmail.text))
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter valid email id"];
        return NO;
    }
    
    if ([txtPassword.text length]<6 || [txtPassword.text length]>15)
    {
        [self showAlertViewWithTitel:@"" Message:@"Password should be at least 6 Characters and maximum 15 Characters"];
        return NO;
    }
    
    if (![txtPassword.text isEqualToString: txtConpassword.text]) {
        
        [self showAlertViewWithTitel:@"" Message:@"Password  and Confirm Password  do not match"];
        return NO;
        
    }
    
    return YES;
    
}
-(void)showAlertViewWithTitel:(NSString *)title Message:(NSString *)message{
    
    [self resignTextview];
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}
-(IBAction)MaleButtonClick:(UIButton *)sender{
    if ([sender isSelected]){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
        genderStr=@"1";
        [btnFemale setSelected:NO];
    }
    
}
-(IBAction)FemaleButtonClick:(UIButton*)sender{
    if ([sender isSelected]){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
        genderStr=@"2";
        [self.btnMale setSelected:NO];
    }
}
-(IBAction)btnRegisterPressed:(id)sender
{
    BOOL isDataValid=[self checkDataAndRegister];
    
    if(isDataValid){
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            [self resignTextview];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            if(self.imageData==nil)
            {
                [self performSelector:@selector(uploadData) withObject:nil afterDelay:0.1];
                
            }
            else
            {
                [self performSelector:@selector(uploadImage) withObject:nil afterDelay:0.1];
                
            }
            
            
        }
        
        
    }
    
}
-(void)showDatePicker{
    
    [self resignTextview];
    
    [pickerView setHidden:FALSE];
    [toolBar setHidden:FALSE];
    /*if (!datePicker.isOpen) {
        
        CGRect datePickerFrame;
        
       
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
              datePicker=[[DatePickerController alloc] initWithFrame:CGRectMake(0,getFloatY(IPHONE_FOUR_HEIGHT),getFloatY(320),216)];
                [datePicker.pickerView setMaximumDate:[NSDate date]];
                datePicker.delegate=self;
                
                datePickerFrame = datePicker.frame;
                
                if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                    
                    datePickerFrame.origin.y =160+IPHONE_FIVE_FACTOR+40;
                else
                {
                    
                    datePickerFrame.origin.y =160+40;
                }
                
            

            datePicker.toolBar.barStyle=UIBarStyleDefault;
            datePicker.backgroundColor=[UIColor whiteColor];
        }
    else{
        datePicker=[[DatePickerController alloc] initWithFrame:CGRectMake(0,getFloatY(IPHONE_FOUR_HEIGHT),getFloatY(320),216)];
            [datePicker.pickerView setMaximumDate:[NSDate date]];
            datePicker.delegate=self;
            
            datePickerFrame = datePicker.frame;
            
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
                
                datePickerFrame.origin.y =160+IPHONE_FIVE_FACTOR;
            else
            {
                
                datePickerFrame.origin.y =160;
            }
        }
        
        datePicker.delegate=self;
        datePicker.isOpen=YES;
        [datePicker setHidden:FALSE];
        [self.view addSubview:datePicker];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [datePicker setFrame:datePickerFrame];
        [UIView commitAnimations];
        
        [self scrollViewToCenterOfScreen:txtdob];
        
        
    }*/
    
    
    
}

-(void)hideDatePicker
{
    [pickerView setHidden:TRUE];
    [toolBar setHidden:TRUE];

    /*CGRect datePickerFrame = datePicker.frame;
   
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone) {
                
                datePickerFrame.origin.y =480+IPHONE_FIVE_FACTOR;
            }
            else{
                datePickerFrame.origin.y =480;
            }

    }
    else{
        
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone) {
                
                datePickerFrame.origin.y =480+IPHONE_FIVE_FACTOR;
            }
            else{
                datePickerFrame.origin.y =480;
            }
        
    }
    
    datePicker.isOpen=NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [datePicker setFrame:datePickerFrame];
    [UIView commitAnimations];*/
    
}
/*-(void)hideKeyBoard:(UITextField *)sender{
    [sender resignFirstResponder];
}*/

//#pragma mark DatePickerController Delegate

-(void)GetDate:(NSDate *)Selected_DOB{
    
    
    
    txtdob.text=[dateForMater stringFromDate:Selected_DOB];
    
    
}
-(void)hideToolBar_With_Done{
    
   
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(hideDatePicker) withObject:nil afterDelay:0.1];
        
        if ([txtdob.text isEqualToString:@""]) {
            
            txtdob.text=[dateForMater stringFromDate:[NSDate date]];
            
    }
    
}
-(void)hideToolBar_With_Cancel{
   
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        [UIView commitAnimations];
        
        [self performSelector:@selector(hideDatePicker) withObject:nil afterDelay:0.1];
    }

-(IBAction)btnProfileImagePressed:(id)sender
{
    imageAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take from camera",@"Take from library", nil];
    [imageAlert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        if (buttonIndex==0) {
          
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else if(alertView==imageAlert)
    {
        if (buttonIndex==1) {
            
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                
                    UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
                    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    //[[self navigationController] presentModalViewController:picker animated:YES];
                
                [self presentViewController:picker animated:YES completion:nil];

                
               
            }
            else {
               
                UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
                picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = NO;
                //[[self navigationController] presentModalViewController:picker animated:YES];
                [self presentViewController:picker animated:YES completion:nil];
    
                
            }
            
        }
        else if(buttonIndex==2)
        {
                UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
                picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = NO;
                //[[self navigationController] presentModalViewController:picker animated:YES];

            [self presentViewController:picker animated:YES completion:nil];

            
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [self useImage:image];
    [imgView setImage:image];
    [lblTapTo setHidden:TRUE];
    [lblUploadImage setHidden:TRUE];

    [self dismissViewControllerAnimated:YES completion:nil];

	
}
- (void)useImage:(UIImage*)theImage
{
    self.imageData=nil;

    UIImage *img=[theImage imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
	self.imageData = UIImageJPEGRepresentation(img, 0.1);
	
}	

-(void)uploadData
{
    
    
    
    NSArray *formfields = [NSArray arrayWithObjects:@"email_id",@"display_name",@"password",@"gender",@"dob",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:txtEmail.text,txtDisplayName.text,txtPassword.text,genderStr,txtdob.text,nil];
	NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
    
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,nil ];
	
	
	[self doPostWithText:compositeData];
    
}
- (void) doPostWithText: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
    
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"register"];
    
    NSLog(@"%@",urlString);
    
    
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease] ;
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
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
	
	results=[returnString JSONValue];
	
	NSLog(@"%@",results);
    
    NSDictionary *responseDic=[results objectForKey:@"response"];
	
    if ([results count]>0) {
        
        self.imageData=nil;
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strMessageError=[responseDic objectForKey:@"error"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            gUserEmail=@"";
            
            [imgView setImage:[UIImage imageNamed:@"user_pic"]];
            
            [lblTapTo setHidden:FALSE];
            [lblUploadImage setHidden:FALSE];
            
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            gUserEmail=[txtEmail.text retain];
            userId=[responseDic objectForKey:@"userId"];
            NSString *image=[responseDic objectForKey:@"userImage"];
            serverImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,image];
            
            [self saveDataInLocalDB];
            
            successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            [successAlert release];
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)uploadImage
{
    
    NSArray *formfields = [NSArray arrayWithObjects:@"email_id",@"display_name",@"password",@"gender",@"dob",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:txtEmail.text,txtDisplayName.text,txtPassword.text,genderStr,txtdob.text,nil];
	NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray *photo = [NSArray arrayWithObjects:@"myimage1.png",nil];
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
	
	
	[self doPostWithImage:compositeData];
    
}
- (void) doPostWithImage: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSArray * _photo = [compositeData objectAtIndex:1];
	
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"register"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",self.imageData.length);

	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease] ;
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
		[body appendData:[NSData dataWithData:self.imageData]];
		
		// [body appendData:[NSData dataWithData:data]];
		self.imageData=nil;
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
	
	results=[returnString JSONValue];
	
	NSLog(@"%@",results);
    
    NSDictionary *responseDic=[results objectForKey:@"response"];
	
    if ([results count]>0) {
        
        self.imageData=nil;
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strMessageError=[responseDic objectForKey:@"error"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            gUserEmail=@"";
            
            [lblTapTo setHidden:FALSE];
            [lblUploadImage setHidden:FALSE];
            
            [imgView setImage:[UIImage imageNamed:@"user_pic"]];
            
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            gUserEmail=[txtEmail.text retain];
            userId=[responseDic objectForKey:@"userId"];
            NSString *image=[responseDic objectForKey:@"userImage"];
            serverImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,image];
            
            [self saveDataInLocalDB];
            
            successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            [successAlert release];
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


#pragma mark ------------Delegate-----------------
#pragma mark Sqlite method


-(void)saveDataInLocalDB
{
    
    
    const char *sqlStatement = "Insert into tbl_user (UserId,UserName,UserImage,DisplayName,EmailId,PhoneNo,Gender,Dob,Rating,Unpaid_revenue) values(?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
        
        sqlite3_bind_text( compiledStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 2, [txtDisplayName.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 3, [serverImageName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 4, [txtDisplayName.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 5, [txtEmail.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 6, [phoneNo UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 7, [genderStr UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 8, [txtdob.text UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 10, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
        
        NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
    } 
    else {
        
        NSLog( @"Insert into row id = %lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
        
        
        
        
    }
    sqlite3_finalize(compiledStatement);
    
    
}

#pragma mark ------------Delegate-----------------
#pragma mark TextFieldDelegate

- (void)scrollViewToTextField:(UITextField*)textField
{
    [scrollView setContentOffset:CGPointMake(0, ((UITextField*)textField).frame.origin.y-25) animated:YES];
    [scrollView setContentSize:CGSizeMake(100,200)];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    
    if (textField==txtdob) {
        
        [self performSelector:@selector(showDatePicker) withObject:nil afterDelay:0.01];            
        
    }
    else
    {
        [self hideDatePicker];
        [self scrollViewToCenterOfScreen:textField];
        [textField setInputAccessoryView:keyboardtoolbar];
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            keyboardtoolbar.barStyle = UIBarStyleDefault;
        }
        for (int n=0; n<[fieldsArray count]; n++) 
        {
            if ([fieldsArray objectAtIndex:n]==textField) 
            {
                if (n==[fieldsArray count]-2) 
                {
                    [barButton setStyle:UIBarButtonItemStyleDone];
                }
            }
        }
    }
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==txtdob) {
        
        [self performSelector:@selector(showDatePicker) withObject:nil afterDelay:0.01];       
        return NO;
    }
    else
    {
        [self hideDatePicker];
        return YES;
    }
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
    CGFloat availableHeight = applicationFrame.size.height - 245;           	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
	
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField) {
		[textField resignFirstResponder];
        
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.25];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
	}
	return YES;
}
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        
        if (theTextField.text.length==1) {
            
            if (theTextField==txtDisplayName) {
                
                NSString *abc = txtDisplayName.text;
                
                abc = [NSString stringWithFormat:@"%@%@",[[abc substringToIndex:1] uppercaseString],[abc substringFromIndex:1] ];
                
                txtDisplayName.text=abc;
            }
           
        }
        
        if (![myCharSet characterIsMember:c]) {
            
            if ([string isEqualToString:@" "]) {
                
            }
            else
            {
                return NO;
            }
            
        }
    }
    
    return YES;
} 
- (IBAction) next
{
	for (int n=0; n<[fieldsArray count]; n++) 
	{
		if ([[fieldsArray objectAtIndex:n] isEditing] && n!=[fieldsArray count]-1) 
		{
            
            if (n==[fieldsArray count]-2) {
                
                [self performSelector:@selector(showDatePicker) withObject:nil afterDelay:0.01];            
                break;
            }
            
            
            else
            {
                [[fieldsArray objectAtIndex:n+1] becomeFirstResponder];
				
				if (n+1==[fieldsArray count]-1) 
				{
					[barButton setTitle:@"Done"];
					[barButton setStyle:UIBarButtonItemStyleDone];
				}else 
				{
					[barButton setTitle:@"Done"];
					[barButton setStyle:UIBarButtonItemStyleDone];
				}
				
				break;
                
                
            }
			
            
		}
		
    }
}

- (IBAction) previous
{
	for (int n=0; n<[fieldsArray count]; n++) 
	{       
        
		if ([[fieldsArray objectAtIndex:n] isEditing]&& n!=0) 
		{
            
            [[fieldsArray objectAtIndex:n-1] becomeFirstResponder];
            [barButton setTitle:@"Done"];
            [barButton setStyle:UIBarButtonItemStyleDone];
            
            break;
		}
        
	}
}
-(void)resignTextview
{
    [txtUsername resignFirstResponder];
    [txtDisplayName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConpassword resignFirstResponder];
    [txtdob resignFirstResponder];
    
    
}

- (IBAction) dismissKeyboard:(id)sender
{
	
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.25];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];
    
    
    [self resignTextview];
    
}

-(IBAction) slideFrameUp:(UITextField *)textField
{
	if (textField.tag == 3) {
		value = 1;
	}
	else if(textField.tag == 4) {
		value = 2;
	}
	else if(textField.tag == 5) {
		value = 3;
	}
	[self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
	[self slideFrame:NO];
}
-(void) slideFrame:(BOOL) up
{
    NSLog(@"11111");
    
	if(value == 1){
        
        NSLog(@"2222");
        
        
		movementDistance = 70; 
		movementDuration = 0.3f;
	}
	else if(value == 2) {
		movementDistance = 120; 
		movementDuration = 0.3f;
	}
	else if(value == 3){
		movementDistance = 210; 
		movementDuration = 0.3f; 
	}
	int movement = (up ? -movementDistance : movementDistance);
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
	self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	[UIView commitAnimations];
}

- (void)viewDidUnload
{
    _years=nil;
    self.imageData=nil;
    self.userId=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_years release];
    self.imageData=nil;
    self.userId=nil;
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
