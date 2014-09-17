//
//  Config.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

extern NSString *WebserviceUrl;

extern NSString *databaseName; 
extern NSString *databasePath; 

//extern NSString *gTinyImageUrl;
extern NSString *gThumbImageUrl;
extern NSString *gThumbLargeImageUrl;
extern NSString *gLargeImageUrl;
extern NSString *gOriginalImageUrl;

extern NSString *gGroupThumbLargeImageUrl;
extern NSString *gOriginalPostImageUrl;

//extern NSString *gGroupImageUrl;
//extern NSString *gGroupTinyImageUrl;
//extern NSString *gGroupThumbImageUrl;
//extern NSString *gGroupLargeImageUrl;
//extern NSString *gGroupOriginalImageUrl;

//extern NSString *gTinyPostImageUrl;
//extern NSString *gThumbPostImageUrl;

extern NSString *gPostCafAudioUrl;
extern NSString *gPostMp3AudioUrl;

extern NSString *gUserEmail;
extern NSString *gDeviceToken;
extern NSString *gUserId;
extern NSString *gUserImage;
extern NSString *gUserName;
extern NSString *urlSchemeSearchText;
extern NSString *gSubscriptionPlan;
extern NSString *gSubscriptionCharge;
extern NSString *gFeetype;
extern bool moveTabG;
extern NSString *gCheckStartGroup;

extern NSMutableArray *gArrContactList;
extern NSMutableArray *gArrSearchContactList;
extern NSMutableArray *gArrRecomandedList;

extern NSData  *gUserImageData;

extern BOOL checkTabbar;
extern NSUserDefaults *defaults;

@end
