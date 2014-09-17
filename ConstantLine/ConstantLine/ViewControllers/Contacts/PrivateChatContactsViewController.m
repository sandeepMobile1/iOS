//
//  PrivateChatContactsViewController.m
//  ConstantLine
//
//  Created by Pramod Sharma on 21/11/13.
//
//

#import "PrivateChatContactsViewController.h"
#import "Config.h"
#import "ContactListData.h"
#import "ContactTableViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "sqlite3.h"
#import "CommonFunction.h"
#import "ChatViewController.h"

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface PrivateChatContactsViewController ()

@end

@implementation PrivateChatContactsViewController

@synthesize tblView,checkView,localImageName,groupUniqueMember,groupId,selectedMemberId,selectedMemberName;

@synthesize arrContactList=_arrContactList;
@synthesize arrSelectedContactList=_arrSelectedContactList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];

    
    if (self.arrContactList==nil) {
        
        self.arrContactList=[[NSMutableArray alloc] init];
    }
   
    if (self.arrSelectedContactList==nil) {
        
        self.arrSelectedContactList=[[NSMutableArray alloc] init];
    }
    
    [[AppDelegate sharedAppDelegate] setNavigationBarCustomTitle:self.navigationItem naviGationController:self.navigationController NavigationTitle:@"Contacts"];
    
    // Do any additional setup after loading the view from its nib.
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
     [backButton setFrame:CGRectMake(0,0, 53,53)];
    [backButton setTitle: @"" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:ARIALFONT_BOLD size:14];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[[UIBarButtonItem alloc]initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[doneButton setImage:[UIImage imageNamed:@"done_btn.png"] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    [doneButton setFrame:CGRectMake(0,7, 50,29)];
    [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *doneButtoView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)]autorelease];
    [doneButtoView addSubview:doneButton];
    
    UIBarButtonItem *rightBtn=[[[UIBarButtonItem alloc]initWithCustomView:doneButtoView]autorelease];
    self.navigationItem.rightBarButtonItem=rightBtn;

    [tblView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sep"]]];

}
-(IBAction)doneButtonClick:(id)sender
{
    NSString *membersIdList=@"";
    NSString *membersNameList=@"";
    
    if ([self.arrSelectedContactList count]>0) {
        
        if ([self.arrSelectedContactList count]>1) {
          
            membersIdList=[[self.arrSelectedContactList objectAtIndex:0] objectForKey:@"FID"];
            membersNameList=[[self.arrSelectedContactList objectAtIndex:0] objectForKey:@"FNAME"];
            
            for (int i=1; i<[self.arrSelectedContactList count]; i++)
            {
                membersIdList=[membersIdList stringByAppendingFormat:@"%@",@","];
                membersNameList=[membersNameList stringByAppendingFormat:@"%@",@","];
                
                membersIdList=[membersIdList stringByAppendingFormat:@"%@",[[self.arrSelectedContactList objectAtIndex:i]objectForKey:@"FID"]];
                membersNameList=[membersNameList stringByAppendingFormat:@"%@",[[self.arrSelectedContactList objectAtIndex:i]objectForKey:@"FNAME"]];
                
            }
            
            self.selectedMemberId=membersIdList;
            self.selectedMemberName=membersNameList;
            
            NSLog(@"%@",self.selectedMemberName);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSLog(@"%@",gUserImage);
             NSLog(@"%@",gUserImageData);
            
            if (gUserImage==nil || gUserImage==(NSString*)[NSNull null] || [gUserImage isEqualToString:@""]) {
                
                [self performSelector:@selector(uploadData) withObject:nil afterDelay:0.1];

            }
            else{
                
                [self performSelector:@selector(uploadImage) withObject:nil afterDelay:0.1];

            }
            

            
            

        }
        
        else{
            
            NSString *idStr=[[self.arrSelectedContactList objectAtIndex:0] objectForKey:@"FID"];
            NSString *nameStr=[[self.arrSelectedContactList objectAtIndex:0] objectForKey:@"FNAME"];
          
            ChatViewController *objChatViewController =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            
            [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";
            objChatViewController.friendUserName=nameStr;
            objChatViewController.groupType=@"0";
            objChatViewController.friendId=idStr;
            objChatViewController.groupId=@"0";
            objChatViewController.groupTitle=@"";

            
            [self.navigationController pushViewController:objChatViewController animated:YES];
            
            [objChatViewController release];
        }
        
        
    }

   
}
- (void)didReceiveBackgroundNotification:(NSNotification*) note
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] Showtabbar];
}
-(void)backButtonClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [lblNoResult setHidden:TRUE];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 568)];
           
        }
        else
        {
           [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 568-IPHONE_FIVE_FACTOR)];
                
            
        }
        
    }
    else{
        
        if ([AppDelegate sharedAppDelegate].appType==kDeviceTypeTalliPhone)
        {
            
            
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 480+IPHONE_FIVE_FACTOR-10)];
                
            
        }
        else
        {
            
                [self.tblView setFrame:CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, 480-10)];
                
            
            
            
        }
        
    }

    
    [AppDelegate sharedAppDelegate].navigationClassReference=self.navigationController;
    
    navigation=self.navigationController.navigationBar;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
    else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:2.0/255.0 green:203.0/255.0  blue:210.0/255.0 alpha:1.0];
    }
   
    
    int status=[[AppDelegate sharedAppDelegate] netStatus];
    
    [self.tblView setContentOffset:CGPointMake(0, 0)];
    
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
        
        tblView.delegate=self;
        tblView.dataSource=self;
        
        [tblView setHidden:TRUE];
        
        service=[[ConstantLineServices alloc] init];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [service ContactListInvocation:gUserId delegate:self];
        
    }
}
#pragma mark Delegate
#pragma mark TableView Delegate And DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount=0;
    
    rowCount=[self.arrContactList count];
        
    return rowCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int height=0;
    
    height=60;
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    
    cell = (AddMembersTableViewCell*)[self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (Nil == cell)
    {
        cell = [AddMembersTableViewCell createTextRowWithOwner:self withDelegate:self];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
    
    cell.lblName.text= data.name;
    
    NSString *imageurl=[NSString stringWithFormat:@"%@%@",gThumbLargeImageUrl,data.image];
    
    if (data.image==nil || data.image==(NSString *)[NSNull null] || [data.image isEqualToString:@""]) {
        
        
        [cell.imgView setImage:[UIImage imageNamed:@"pic_bg.png"]];
        
    }
    else
    {
        NSLog(@"%@",data.image);
        
        if (imageurl && [imageurl length] > 0) {
            
            UIImage *img = [objImageCache iconForUrl:imageurl];
            
            if (img == Nil) {
                
                CGSize kImgSize_1;
                if ([[UIScreen mainScreen] scale] == 1.0)
                {
                    kImgSize_1=CGSizeMake(35, 35);
                }
                else{
                    kImgSize_1=CGSizeMake(35*2, 35*2);
                }
                
                [objImageCache startDownloadForUrl:imageurl withSize:kImgSize_1 forIndexPath:indexPath];
                
                
            }
            
            else {
                
                [cell.imgView setImage:img];
            }
            
        }
        
        
        
    }
    
    if ([self.checkView isEqualToString:@"addPrivate"]) {
        
        BOOL checkMarkFlag=TRUE;
        
        NSString *fId=data.userId;
        
        for (int i=0; i<[self.arrSelectedContactList count]; i++) {
            
            NSString *selectedFriendId=[[self.arrSelectedContactList objectAtIndex:i] objectForKey:@"FID"];
            
            if([selectedFriendId isEqualToString:fId])
            {
                
                checkMarkFlag=FALSE;
                break;
                
            }
            else {
                
                
                checkMarkFlag=TRUE;
            }
            
        }
        
        NSLog(@"%d",[self.arrSelectedContactList count]);
        
        if (checkMarkFlag==FALSE) {
            
            [cell.btnSelectFriend setTitle:@"1" forState:UIControlStateReserved];
            
            cell.btnSelectFriend.tag=1;
            [cell.btnSelectFriend setSelected:YES];
            
        }
        else
        {
            cell.btnSelectFriend.tag=0;
            [cell.btnSelectFriend setTitle:@"0" forState:UIControlStateReserved];
            
            [cell.btnSelectFriend setSelected:NO];
            
        }

    }
    else
    {
        [cell.btnSelectFriend setHidden:TRUE];

    }
    
    if ([data.userId isEqualToString:@"100"]) {
        
        [cell.btnSelectFriend setHidden:TRUE];

    }
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.checkView isEqualToString:@"chat"]) {
        
        ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
        [AppDelegate sharedAppDelegate].addressContactId=data.userId;
        [AppDelegate sharedAppDelegate].addressContactName=data.name;
        [AppDelegate sharedAppDelegate].checkaddressContact=@"YES";

        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    service=nil;
    [objImageCache cancelDownload];
    objImageCache=nil;
    tblView.delegate=nil;
    tblView.dataSource=nil;
}

-(void)iconDownloadedForUrl:(NSString*)url forIndexPaths:(NSArray*)paths withImage:(UIImage*)img withDownloader:(ImageCache*)downloader
{
    [self.tblView reloadData];
}
-(void) buttonSelectFriend:(AddMembersTableViewCell *)cellValue
{
    NSLog(@"%d",[self.arrSelectedContactList count]);
    NSIndexPath * indexPath = [self.tblView indexPathForCell:cellValue];
    
    ContactListData *data=[self.arrContactList objectAtIndex:indexPath.row];
    
    NSString *status=[cellValue.btnSelectFriend titleForState:UIControlStateReserved];
    NSString *fId=data.userId;
    NSString *fName=data.userName;
    
    NSLog(@"%d",cellValue.tag);

    if ([status isEqualToString:@"0"]) {
        
        [cellValue.btnSelectFriend setTag:1];
        [cellValue.btnSelectFriend setSelected:YES];
        
        [self.arrSelectedContactList addObject:[NSDictionary dictionaryWithObjectsAndKeys:fId,@"FID",fName,@"FNAME", nil]];
    }
    
    else
    {
        [cellValue.btnSelectFriend setTag:0];
        [cellValue.btnSelectFriend setSelected:NO];

        int object=0;
        
        for (int i=0; i<[self.arrSelectedContactList count]; i++) {
           
            NSString *idStr=[[self.arrSelectedContactList objectAtIndex:i] objectForKey:@"FID"];
            
            if ([idStr isEqualToString:fId]) {
                
                object=i;
                break;
            }
        }
        
        NSLog(@"%d",object);
        
        [self.arrSelectedContactList removeObjectAtIndex:object];
        
    }
    
    [self.tblView reloadData];
}
#pragma ----------
#pragma web service delegate

-(void)ContactListInvocationDidFinish:(ContactListInvocation *)invocation withResults:(NSDictionary *)result withMessages:(NSString *)msg withError:(NSError *)error
{
    NSLog(@"%@",result);
    
    [self.arrContactList removeAllObjects];
    [self.arrSelectedContactList removeAllObjects];
    
    if (msg==nil || msg==(NSString*)[NSNull null]) {
        
        if ([result count]>0) {
            
            NSMutableArray *responseArray=[result objectForKey:@"contacts"];

            NSMutableArray *arrOfResponseField=[[NSMutableArray alloc] initWithObjects:@"user_id",@"user_image",@"user_name",@"request_status",@"displayname",nil];
            
            for (NSMutableArray *arrValue in responseArray) {
                
                for (int i=0;i<[arrOfResponseField count];i++) {
                    
                    if ([arrValue valueForKey:[arrOfResponseField objectAtIndex:i]]==[NSNull null]) {
                        
                        [arrValue setValue:@"" forKey:[arrOfResponseField objectAtIndex:i]];
                    }
                }
                
                if (![[arrValue valueForKey:@"user_id"] isEqualToString:@"100"]) {
                    
                    ContactListData *data=[[[ContactListData alloc] init] autorelease];
                    
                    data.userId= [NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_id"]];
                    data.image=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_image"]];
                    data.name=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                    data.userName=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"user_name"]];
                    
                    data.status=[NSString stringWithFormat:@"%@",[arrValue valueForKey:@"request_status"]];
                    if ([data.status isEqualToString:@"2"]) {

                    [self.arrContactList addObject:data];
                        
                    }
                }
                
               
            }
            
            [arrOfResponseField release];
            
        }
        
        
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
        [alert release];
        
    }
    
    if ([self.arrContactList count]>0) {
        
        [self.tblView setHidden:FALSE];

        [doneButton setEnabled:TRUE];
        [lblNoResult setHidden:TRUE];

    }
    else
    {
        [self.tblView setHidden:TRUE];
        [doneButton setEnabled:FALSE];
        [lblNoResult setHidden:FALSE];

    }
    
    [self.tblView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    moveTabG=FALSE;
}
-(void)uploadData
{
    
    NSString *chatId=[self genRandStringLength:40];
    
    NSArray *formfields = [NSArray arrayWithObjects:@"userId",@"groupTitle",@"groupIntro",@"subscriptionCharge",@"subscriptionPeriod",@"groupMember",@"threadId",@"groupType",nil];
    NSLog(@"%@",selectedMemberName);
	 NSLog(@"%@",selectedMemberId);
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,self.selectedMemberName,@"",@"",@"",self.selectedMemberId,chatId,@"1",nil];
	
    NSLog(@"%@",formvalues);
    
    NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,nil ];
	
	//[self performSelectorOnMainThread:@selector(doPostWithText:) withObject:compositeData waitUntilDone:YES];
    
    [self performSelector:@selector(doPostWithText:) withObject:compositeData afterDelay:0.1];

    
}
- (void) doPostWithText: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
    
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"create_group"];
    
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
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strMessageError=[responseDic objectForKey:@"error"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            self.groupId=[responseDic objectForKey:@"groupId"];
            self.groupUniqueMember=[responseDic objectForKey:@"groupCode"];

            self.localImageName=@"";
            
            //[self performSelectorOnMainThread:@selector(saveGroupDetailOnLocalDB) withObject:nil waitUntilDone:YES];
            
            successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            
            
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)uploadImage
{
    
    NSString *chatId=[self genRandStringLength:40];
    
    NSArray *formfields = [NSArray arrayWithObjects:@"userId",@"groupTitle",@"groupIntro",@"subscriptionCharge",@"subscriptionPeriod",@"groupMember",@"threadId",@"groupType",nil];
    NSLog(@"%@",selectedMemberName);
    NSLog(@"%@",selectedMemberId);
    NSArray *formvalues = [NSArray arrayWithObjects:gUserId,self.selectedMemberName,@"",@"",@"",self.selectedMemberId,chatId,@"1",nil];
	
    NSLog(@"%@",formvalues);
    
    NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
	
	NSLog(@"%@",textParams);
	
	NSArray *photo = [NSArray arrayWithObjects:@"myimage1.png",nil];
	
	NSArray * compositeData = [NSArray arrayWithObjects: textParams,photo,nil ];
	
    //[self performSelector:@selector(doPostWithImage:) withObject:compositeData afterDelay:0.1];

	[self performSelectorOnMainThread:@selector(doPostWithImage:) withObject:compositeData waitUntilDone:YES];
    
}
- (void) doPostWithImage: (NSArray *) compositeData
{
    results=[[NSMutableDictionary alloc] init];
	
	NSDictionary * _textParams =[compositeData objectAtIndex:0];
	
	NSArray * _photo = [compositeData objectAtIndex:1];
	
	NSString *urlString= [NSString stringWithFormat:@"%@",WebserviceUrl];
	urlString=[urlString stringByAppendingFormat:@"create_group"];
    
    NSLog(@"%@",urlString);
    NSLog(@"%d",gUserImageData.length);
    
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
		[body appendData:[NSData dataWithData:gUserImageData]];
		
		// [body appendData:[NSData dataWithData:data]];
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
        
        NSString *strMessage=[responseDic objectForKey:@"success"];
        NSString *strMessageError=[responseDic objectForKey:@"error"];
        
        if(strMessage==nil || strMessage==(NSString*)[NSNull null])
        {
            UIAlertView *Alert =[[UIAlertView alloc] initWithTitle:nil message:strMessageError delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [Alert show];
            [Alert release];
        }
        else
        {
            self.groupId=[responseDic objectForKey:@"groupId"];
            NSString *image=[responseDic objectForKey:@"groupImage"];
            self.groupUniqueMember=[responseDic objectForKey:@"groupCode"];
            
            self.localImageName=[NSString stringWithFormat:@"%@%@",gGroupThumbLargeImageUrl,image];
            
            //[self performSelectorOnMainThread:@selector(saveGroupDetailOnLocalDB) withObject:nil waitUntilDone:YES];
            
            successAlert =[[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil,nil];
            [successAlert show];
            
            
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==successAlert) {
        
        ChatViewController *objChatViewController =[[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil] autorelease];
        
        [AppDelegate sharedAppDelegate].checkPublicPrivateStatus=@"1";
        
        objChatViewController.friendUserName=@"";
        objChatViewController.groupType=@"1";
        objChatViewController.friendId=@"0";
        objChatViewController.groupId=self.groupId;
        objChatViewController.threadId=self.groupUniqueMember;
        objChatViewController.groupTitle=@"";

        [self.navigationController pushViewController:objChatViewController animated:YES];
        
    }
}
-(NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}
#pragma mark----------------
#pragma sqlite methods

-(void)saveGroupDetailOnLocalDB
{
    NSString *idStr=@"";
    NSString *groupType=@"1";
    
    
    const char *sqlStatement = "Insert into tbl_group (groupId,groupName,groupIconId,groupIntro,groupCreated,groupRating,groupSubCharge,groupSubPeriod,groupType,groupUniqueDeg,OwnerId) values(?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        
        
        sqlite3_bind_text( compiledStatement, 1, [self.groupId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 2, [selectedMemberName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 3, [self.localImageName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 4, [@""  UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 6, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text( compiledStatement, 7, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 8, [@"" UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text( compiledStatement, 9, [groupType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 10, [self.groupUniqueMember UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text( compiledStatement, 11, [gUserId UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
        
        NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        
    } else {
        
        NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
        idStr=[NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database)];
        
    }
    sqlite3_finalize(compiledStatement);
    
    if (![idStr isEqualToString:@""]) {
        
        [self saveGroupMemberOnLocalDB];
    }
    
}
-(void)saveGroupMemberOnLocalDB
{
    for (int i=0; i<[self.arrSelectedContactList count]; i++) {
        
        NSString *memberId=[[AppDelegate sharedAppDelegate].arrSelectedContactList objectAtIndex:i];
        
        const char *sqlStatement = "Insert into tbl_group_member (groupId,memberId) values(?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2([AppDelegate sharedAppDelegate].database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            
            sqlite3_bind_text( compiledStatement, 1, [self.groupId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [memberId UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            
            NSLog( @"Error: %s", sqlite3_errmsg([AppDelegate sharedAppDelegate].database) );
        }
        else {
            
            NSLog( @"Insert into row id = %lld",sqlite3_last_insert_rowid([AppDelegate sharedAppDelegate].database));
            
        }
        sqlite3_finalize(compiledStatement);
        
    }
}
-(void)viewDidUnload
{
    _arrContactList=nil;
    _arrSelectedContactList=nil;
    self.selectedMemberId=nil;
    self.selectedMemberName=nil;
    self.checkView=nil;
    self.localImageName=nil;
    self.groupUniqueMember=nil;
    self.groupId=nil;
    
    
}
-(void)dealloc
{
    [_arrContactList release];
    [_arrSelectedContactList release];
    self.selectedMemberId=nil;
    self.selectedMemberName=nil;
    self.checkView=nil;
    self.localImageName=nil;
    self.groupUniqueMember=nil;
    self.groupId=nil;

     [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
