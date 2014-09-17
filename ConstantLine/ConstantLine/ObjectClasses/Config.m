//
//  Config.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Config.h"

@implementation Config

// 64 url

NSString *databaseName  = @"WellConnectedDB.sqlite";
NSString *databasePath  = @"";

NSString *WebserviceUrl=@"https://wellconnected.ehealthme.com/web_services/";

NSString *gThumbImageUrl=@"https://wellconnected.ehealthme.com/uploads/user/thumb/";
NSString *gThumbLargeImageUrl=@"https://wellconnected.ehealthme.com/uploads/user/thumb1/";
NSString *gLargeImageUrl=@"https://wellconnected.ehealthme.com/uploads/user/large/";
NSString *gOriginalImageUrl=@"https://wellconnected.ehealthme.com/uploads/user/";
NSString *gGroupThumbLargeImageUrl=@"https://wellconnected.ehealthme.com/uploads/groupimages/thumb1/";
NSString *gOriginalPostImageUrl=@"https://wellconnected.ehealthme.com/uploads/chat/image/";

NSString *gPostCafAudioUrl=@"https://wellconnected.ehealthme.com/uploads/chat/audio/caf/";
NSString *gPostMp3AudioUrl=@"https://wellconnected.ehealthme.com/uploads/chat/audio/mp3/";
////////////////

//// 64 url
/*NSString *gThumbImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/user/thumb/";
NSString *gThumbLargeImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/user/thumb1/";
NSString *gLargeImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/user/large/";
NSString *gOriginalImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/user/";
NSString *gGroupThumbLargeImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/groupimages/thumb1/";
NSString *gOriginalPostImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/chat/image/";

NSString *gPostCafAudioUrl=@"http://64.15.136.251:8080/wellconnected/uploads/chat/audio/caf/";
NSString *gPostMp3AudioUrl=@"http://64.15.136.251:8080/wellconnected/uploads/chat/audio/mp3/";
*/
///////////////


//NSString *gTinyImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/user/tiny/";

/*NSString *gTinyPostImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/chat/image/tiny/";
NSString *gThumbPostImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/chat/image/thumb/";  

NSString *gGroupTinyImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/groupimages/tiny/";
NSString *gGroupThumbImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/groupimages/thumb/";
NSString *gGroupLargeImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/groupimages/large/";
NSString *gGroupOriginalImageUrl=@"http://64.15.136.251:8080/wellconnected/uploads/groupimages";*/


NSString *gUserId=@"";
NSString *gUserEmail=@"";
NSString *gDeviceToken=@"";
NSString *gSubscriptionPlan=@"";
NSString *gSubscriptionCharge=@"";
NSString *gFeetype=@"";
NSString *gUserImage=@"";
NSString *gUserName=@"";
NSString *urlSchemeSearchText=@"";
NSMutableArray *gArrContactList;
NSMutableArray *gArrSearchContactList;
NSMutableArray *gArrRecomandedList;
NSString *gCheckStartGroup=@"";

bool moveTabG=TRUE;
BOOL checkTabbar=FALSE;
NSUserDefaults *defaults=nil;
NSData *gUserImageData=nil;
@end
