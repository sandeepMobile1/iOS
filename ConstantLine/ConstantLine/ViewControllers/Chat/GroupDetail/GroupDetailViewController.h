//
//  GroupDetailViewController.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import "ConstantLineServices.h"
#import "GroupDetailInvocation.h"

@interface GroupDetailViewController : UIViewController <GroupDetailInvocationDelegate,ImageCacheDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imgGroupView;
    IBOutlet UIImageView *imgGroupBackView;
    IBOutlet UILabel *lblGroupTitle;
    IBOutlet UILabel *lblGroupOwner;
    IBOutlet UILabel *lblSubscriptionCharge;
    IBOutlet UILabel *lblConnectedMembers;
    IBOutlet UITextView *txtgroupDescription;
    IBOutlet UILabel *lblCreated;
    
    IBOutlet UIButton *btnRating1;
    IBOutlet UIButton *btnRating2;
    IBOutlet UIButton *btnRating3;
    IBOutlet UIButton *btnRating4;
    IBOutlet UIButton *btnRating5;
    IBOutlet UINavigationBar *navigation;
    
    IBOutlet UIButton *btnPaid;
    
     ImageCache *objImageCache;
    ConstantLineServices *service;
    

}
@property(nonatomic,retain) NSString *ratingStr;
@property(nonatomic,retain) NSMutableArray *arrGroupDetail;
@property(nonatomic,retain) NSString *groupId;
//-(IBAction)btnPaidPressed:(id)sender;
-(NSString *) stringByStrippingHTML:(NSString*)intro;

-(void)setvalues;
-(void)setRating;
-(void)setImage;
-(void)setScrollFrame;
@end
