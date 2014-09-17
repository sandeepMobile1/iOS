//
//  EditProfileViewController.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "JSON.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserProfileData.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "UIImageExtras.h"
#import "QSStrings.h"

@implementation EditProfileViewController



@synthesize btnMale,btnFemale,serverImageName,imageData,date,todayIndexPath;
@synthesize years = _years;
@synthesize arrUserProfileData=_arrUserProfileData;

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
    
    bigRowCount = 1000;
    rowHeight = 44.f;
    numberOfComponents = 2;
    
    [scrollView setContentSize:CGSizeMake(320, 800)];

    
    txtIntro.text=@"";
    
    if (self.arrUserProfileData!=nil) {
        
        self.arrUserProfileData=nil;
    }
    self.arrUserProfileData=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Edit Profile"];
    
    
    [imgView.layer setBorderWidth:2.0];
    [imgView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    navigation=self.navigationController.navigationBar;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    
    imgView.layer.cornerRadius =44;
    imgView.clipsToBounds = YES;
    [imgView.layer setBorderWidth:5.0];
    [imgView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    phoneNo=@"";
    
    fieldsArray = [[NSArray alloc] initWithObjects:txtContactEmail,txtdob,genderStr,nil];
    
    scrollView.backgroundColor=[UIColor clearColor];
    
   /* dateForMater=[[NSDateFormatter alloc] init];
    dateForMater.dateStyle = NSDateFormatterMediumStyle;
    [dateForMater setDateFormat:@"yyyy-MM-dd"];
    */
    
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton]autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    if (service!=nil) {
        service=nil;
    }
    service=[[ConstantLineServices alloc] init];
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    if(status==0)
    {
        moveTabG=TRUE;
        
        if (service!=nil) {
            service=nil;
        }
        if (objImageCache!=nil) {
            objImageCache=nil;
        }
        objImageCache=[[ImageCache alloc] init];
        objImageCache.delegate=self;
        
        service=[[ConstantLineServices alloc] init];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service UserProfileInvocation:gUserId delegate:self]; 
    }
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (objImageCache==nil) {
        objImageCache=[[ImageCache alloc] init];
        objImageCache.delegate=self;
    }
   

    self.years=[[NSMutableArray alloc]init];

    if (pickerView==nil) {
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            float height=200;
            pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-(height-20), 320,height)] autorelease];
            height=200;
            toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-(height-20), 320, 40)] autorelease];
            toolBar.barStyle=UIBarStyleDefault;
            pickerView.backgroundColor=[UIColor whiteColor];
        }
        else
        {
            if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
            {
                pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0, 204+IPHONE_FIVE_FACTOR, 320, 200)] autorelease];
                toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, 164+IPHONE_FIVE_FACTOR, 320, 40)] autorelease];
            }
            else
            {
                pickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0, 204, 320, 200)] autorelease];
                toolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, 164, 320, 40)] autorelease];
            }
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

-(void)viewWillDisappear:(BOOL)animated
{
    [objImageCache cancelDownload];
    objImageCache=nil;
    
    service=nil;
}
-(void)setvalues
{
    UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
    txtContactEmail.text=data.contact_email;
    txtDisplayName.text=data.display_name;
    txtEmail.text=data.email;
    txtPassword.text=data.password;
    txtdob.text=data.dob;
    ratingStr=data.rating;
    lblNumOfGroup.text=data.num_of_groups;
    txtIntro.text=data.intro;
    
    if ([data.gender isEqualToString:@"male"]) {
        
        [btnMale setSelected:YES];
        genderStr=@"1";
    }
    else
    {
        [btnFemale setSelected:YES];
        genderStr=@"2";


    }
    
    if ([data.user_image length]>0) {
        
        self.serverImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.user_image];

    }
    
    NSLog(@"%@",data.rating);
    
    [self setRating];
    [self setImage];
}
-(void)setRating
{
    if ([ratingStr isEqualToString:@""] || [ratingStr isEqualToString:@"0"]) {
        
        [btnRating1 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        
    }
    else if([ratingStr isEqualToString:@"1"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    
    else if([ratingStr isEqualToString:@"2"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"3"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"4"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"grey_star.png"] forState:UIControlStateNormal];
    }
    else if([ratingStr isEqualToString:@"5"])
    {
        [btnRating1 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating2 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating3 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating4 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
        [btnRating5 setImage:[UIImage imageNamed:@"green_star.png"] forState:UIControlStateNormal];
    }
}
-(void)setImage
{
    UserProfileData *data=[self.arrUserProfileData objectAtIndex:0];
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.user_image];
    
    NSLog(@"%@",imageurl);
    
    
    if (data.user_image==nil || data.user_image==(NSString *)[NSNull null] || [data.user_image isEqualToString:@""]) {
        
        [lblTapTo setHidden:FALSE];
        [lblUploadImage setHidden:FALSE];
        [imgView setImage:[UIImage imageNamed:@"user_pic.png"]];
        
    } 
    else
    {
        [lblTapTo setHidden:TRUE];
        [lblUploadImage setHidden:TRUE];

            UIImage *img = [objImageCache iconForUrl:imageurl];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(180, 180);
                }
                else{
                    kImgSize_1=CGSizeMake(180, 180);
                }
                
                
                
                [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
                
            }
            
            else {
                
                [imgView setImage:img];
            }
        }
    
    
}
-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self setImage];
}
-(void)backButtonClick:(UIButton *)sender{
    
    if (moveTabG==FALSE) {
        
        [self resignTextview];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
   
}
-(IBAction)btnCancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)checkDataAndRegister{
    
    [txtContactEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    txtDisplayName.text= [txtDisplayName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    txtEmail.text= [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([txtDisplayName.text length]<=0 || txtDisplayName.text == nil || [txtDisplayName.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter screen name"];
        return NO;
    }
        if ([txtDisplayName.text length]<3 || [txtDisplayName.text length]>25)
    {
        [self showAlertViewWithTitel:@"" Message:@"Screen name should be at least 3 Characters and maximum 25 Characters"];
        return NO;
    }
    if ([txtEmail.text length]<=0 || txtEmail.text == nil || [txtEmail.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter email id "];
        return NO;
    }
    if ([txtContactEmail.text length]<=0 || txtContactEmail.text == nil || [txtContactEmail.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter contact email "];
        return NO;
    }
    if ([genderStr length]<=0 || genderStr == nil || [genderStr isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please select gender"];
        return NO;
    }
    
    if ([txtdob.text length]<=0 || txtdob.text == nil || [txtdob.text isEqualToString:@""]==TRUE)
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter date of birth"];
        return NO;
    }
    
      if (!validateEmail(txtEmail.text))
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter valid email id"];
        return NO;
    }
    if (!validateEmail(txtContactEmail.text))
    {
        [self showAlertViewWithTitel:@"" Message:@"Please enter valid contact email id"];
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
    [alertView release];
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
-(IBAction)btnSavePressed:(id)sender
{    
    BOOL isDataValid=[self checkDataAndRegister];
    
    if(isDataValid){
        
        int status=[[AppDelegate sharedAppDelegate] netStatus];
        
        if(status==0)
        {
            moveTabG=TRUE;
            
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            [self resignTextview];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if (self.imageData==nil) {
                
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
}

-(void)hideDatePicker
{
    [pickerView setHidden:TRUE];
    [toolBar setHidden:TRUE];
   
    
}

/*-(void)hideKeyBoard:(UITextField *)sender{
    [sender resignFirstResponder];
}

#pragma mark DatePickerController Delegate

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
}*/

-(IBAction)btnProfileImagePressed:(id)sender
{
    imageAlert=[[UIAlertView alloc] initWithTitle:nil message:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take from camera",@"Take from library", nil];
    [imageAlert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AC_USER_PROFILE_UPDATED_SUCCESSFULLY object:nil];


        [self.navigationController popViewControllerAnimated:YES];
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
               // [[self navigationController] presentModalViewController:picker animated:YES];
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

    //[self dismissModalViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];

   
	
}
- (void)useImage:(UIImage*)theImage
{
    self.imageData=nil;
    localImageName=@"";
    self.serverImageName=@"";

    UIImage *img=[theImage imageByScalingAndCroppingForSize:CGSizeMake(300, 300)];
	self.imageData = UIImageJPEGRepresentation(img, 0.1);	
}	

-(void)uploadData
{
    NSString * base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)txtIntro.text,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                   kCFStringEncodingUTF8 )autorelease];
    
    NSArray *formfields = [NSArray arrayWithObjects:@"user_id",@"email_id",@"display_name",@"contactEmail",@"gender",@"dob",@"intro",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,txtEmail.text,txtDisplayName.text,txtContactEmail.text,genderStr,txtdob.text,base64String,nil];
	NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
		
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,nil ];
	
	[self performSelector:@selector(doPostWithText:) withObject:compositeData afterDelay:0.1];
    
}
- (void) doPostWithText: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
        
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"edit_profile"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",self.imageData.length);
    
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
		
        
        if ([results count]>0) {
            
            NSString *strMessage=[responseDic objectForKey:@"success"];
            NSString *strMessageError=[responseDic objectForKey:@"error"];
            NSString *image=[responseDic objectForKey:@"userImage"];

            
            if(strMessage==nil || strMessage==(NSString*)[NSNull null])
            {                
                UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
                [Alert show];
                [Alert release];
            }
            else
            {
                gUserEmail=[txtEmail.text retain];
                
                NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
                NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
                
                if([AppDelegate sharedAppDelegate].rememberTag==1)
                {
                    
                    if(plist_dict == nil)
                    {
                        plist_dict = [[NSMutableDictionary alloc] init];
                    }
                    [plist_dict setObject:[NSString stringWithFormat:@"%@",txtEmail.text] forKey:@"loginusernane"];
                    [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].password] forKey:@"loginpassword"];
                    [plist_dict setObject:@"yes" forKey:@"keepmelogin"];
                    [plist_dict writeToFile:plistPath atomically:YES];
                    
                }
                else
                {
                    [plist_dict setObject:@"no" forKey:@"keepmelogin"];
                    [plist_dict writeToFile:plistPath atomically:YES];
                    
                }

                self.serverImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,image];

                [self updateUserDetailOnLocalDB:self.serverImageName];

                
                successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
                [successAlert show];
            }
        }
        
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    moveTabG=FALSE;
}
-(void)uploadImage
{
    self.serverImageName=@"";
    
    NSString * base64String = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)txtIntro.text,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                   kCFStringEncodingUTF8 )autorelease];
    NSArray *formfields = [NSArray arrayWithObjects:@"user_id",@"email_id",@"contactEmail",@"display_name",@"gender",@"dob",@"intro",nil];
	
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,txtEmail.text,txtContactEmail.text,txtDisplayName.text,genderStr,txtdob.text,base64String,nil];
	NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray *photo = [NSArray arrayWithObjects:@"myimage1.png",nil];
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
	
	[self performSelector:@selector(doPostWithImage:) withObject:compositeData afterDelay:0.1];

}
- (void) doPostWithImage: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
    
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	
	NSArray * _photo = [compositeData objectAtIndex:1];
	
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"edit_profile"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",self.imageData.length);
    
   	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
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
		
        
        if ([results count]>0) {
            
            NSString *strMessage=[responseDic objectForKey:@"success"];
            NSString *strMessageError=[responseDic objectForKey:@"error"];
            NSString *image=[responseDic objectForKey:@"userImage"];
            
            
            if(strMessage==nil || strMessage==(NSString*)[NSNull null])
            {                
                UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
                [Alert show];
                [Alert release];
            }
            else
            {
                gUserEmail=[txtEmail.text retain];
                
                NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *plistPath = [rootPath stringByAppendingPathComponent:@"plistData.plist"];
                NSMutableDictionary *plist_dict = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
                
                if([AppDelegate sharedAppDelegate].rememberTag==1)
                {
                    
                    if(plist_dict == nil)
                    {
                        plist_dict = [[NSMutableDictionary alloc] init];
                    }
                    [plist_dict setObject:[NSString stringWithFormat:@"%@",txtEmail.text] forKey:@"loginusernane"];
                    [plist_dict setObject:[NSString stringWithFormat:@"%@",[AppDelegate sharedAppDelegate].password] forKey:@"loginpassword"];
                    
                    [plist_dict setObject:@"yes" forKey:@"keepmelogin"];
                    [plist_dict writeToFile:plistPath atomically:YES];
                    
                }
                else
                {
                    [plist_dict setObject:@"no" forKey:@"keepmelogin"];
                    [plist_dict writeToFile:plistPath atomically:YES];
                    
                }
                
                gUserImage=[image retain];

                self.serverImageName=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,image];
                
                [self updateUserDetailOnLocalDB:self.serverImageName];
                
                
                successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
                [successAlert show];
            }
        }
        
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    moveTabG=FALSE;
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollViewToCenterOfScreen:textView];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    /*  if (range.length==0)
     {
     
     if ([text isEqualToString:@"\n"])
     {
     [textView resignFirstResponder];
     [textView resignFirstResponder];
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: 0.25];
     [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
     [UIView commitAnimations];
     
     return YES;
     
     }
     
     }
     return YES;
     */
    
    
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSLog(@"input %d chars", newText.length);
    
    totalCharacterCout=60-newText.length;
    
    if (totalCharacterCout>=0 && totalCharacterCout<=60) {
        
        
        if ([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
        }
        return YES;
        
    }else{
        if ([text isEqualToString:@"\n"])
        {
            
            [textView resignFirstResponder];
            [textView resignFirstResponder];
            [UIView beginAnimations: @"anim" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.25];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView commitAnimations];
            
            
        }
        return NO;
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
    [txtEmail resignFirstResponder];
    [txtDisplayName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtContactEmail resignFirstResponder];
    [txtConpassword resignFirstResponder];
    [txtdob resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtIntro resignFirstResponder];
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

#pragma ------------
#pragma Webservice delegate

-(void)UserProfileInvocationDidFinish:(UserProfileInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSDictionary *responsedic=[result objectForKey:@"response"];
    
    [self.arrUserProfileData removeAllObjects];
    
    NSString *errorStr=[responsedic objectForKey:@"error"];
    
    if (errorStr==nil || errorStr==(NSString*)[NSNull null]) {
        
        NSMutableArray *responseArray=[responsedic objectForKey:@"success"];
        
        NSLog(@"%d",[responseArray count]);
        
        if ([responseArray count]>0) {
            
            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"display_name",@"dob",@"email",@"gender",@"no_of_groups",@"rating",@"user_id",@"user_image",@"user_name",@"contactEmail",@"password",@"intro",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {   
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                UserProfileData *data=[[[UserProfileData alloc] init] autorelease];
                
                data.user_id= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                data.user_name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                data.display_name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"display_name"]];
                data.email=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"email"]];   
                data.gender=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"gender"]];
                data.dob=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"dob"]];
                data.rating=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"rating"]];
                data.user_image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
                data.contact_email=[arrValue valueForKey:@"contactEmail"];
                data.password=[arrValue valueForKey:@"password"];

                data.num_of_groups= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"no_of_groups"]];
                data.intro= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"intro"]];

                if ([data.num_of_groups isEqualToString:@""]) {
                    
                    data.num_of_groups=@"0";
                }
                
                NSLog(@"%@",data.rating);
                
                [self.arrUserProfileData addObject:data];
            }
            
            [arrOfResponseField release];
            
            [self setvalues];
            
            
        }
        
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    moveTabG=FALSE;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)updateUserDetailOnLocalDB:(NSString*)imageId
{
        
        NSString *sqlStatement1=[NSString stringWithFormat:@"update tbl_user set UserName=? ,DisplayName = ? ,EmailId = ?, PhoneNo = ? ,Gender = ? ,Dob = ? ,Rating = ?, Unpaid_revenue = ?,UserImage = ? where UserId = '%@' ",gUserId];
        
        NSLog(@"%@",sqlStatement1);
        
        const char *sqlStatement=[sqlStatement1 UTF8String];
        
        sqlite3_stmt *compiledStatement;
                
               
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text( compiledStatement, 1, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [txtDisplayName.text  UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [txtEmail.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 4, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text( compiledStatement, 5, [genderStr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 6, [txtdob.text UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text( compiledStatement, 7, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 8, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 9, [imageId UTF8String], -1, SQLITE_TRANSIENT);

        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        } else {
            
            NSLog( @"Update into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            
        }
        sqlite3_finalize(compiledStatement);
        
        
    moveTabG=FALSE;

}
#pragma Mark-----------
#pragma Mark Sqlite methods

- (void)viewDidUnload
{
    _arrUserProfileData=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [_arrUserProfileData release];
    
     [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
