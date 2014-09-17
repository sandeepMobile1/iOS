//
//  AppConstant.h
//  SnagFu
//
//  Created by octal i-phone2 on 7/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import "AppDelegate.h"

#ifndef SnagFu_AppConstant_h
#define SnagFu_AppConstant_h

#define GEORGIAFONT @"Georgia"
#define ARIALFONT @"Arial"
#define ARIALFONT_BOLD @"Arial-BoldMT"

#define  IPHONE_FIVE_FACTOR 88
#define  IPHONE_FIVE_HEIGHT 568
#define  IPHONE_FOUR_HEIGHT 480

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

inline static BOOL validateEmail(NSString *emailID)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailID];
}

inline static CGSize getLabelHeightForArialFont(NSString *fontName,NSString* str, float fontSize)
{
    CGSize maximumLabelSize;
    maximumLabelSize= CGSizeMake(290,1000);
    
    
    CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:fontName size:fontSize]
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize;
}

inline static
CGFloat	scaleFacterForHeight(){
    
    if ([AppDelegate sharedAppDelegate].appType==3){
        
        if( [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft )
        {
            
            return 1.6375;
            
        }else{
            
            return 2.13f;
        }
    }
    
    return 1.0f;
}

inline static NSString * getStringAfterTriming(NSString *text)
{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
inline static float getFloatX(float x)
{
    return x*1.7375f;
}

inline static

float getFloatY(float y)
{
    return y*scaleFacterForHeight();
}

enum DeviceType{
    kDeviceTypeiPhone=1,
    kDeviceTypeTalliPhone=2,
    kDeviceTypeiPad=3
};

#endif
