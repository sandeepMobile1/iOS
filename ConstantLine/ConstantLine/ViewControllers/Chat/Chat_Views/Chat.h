//
//  Chat.h
//  Dolphin6
//
//  Created by Enuke Software on 09/12/11.
//  Copyright 2011 Enuke Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Chat : NSObject {

}

@property(nonatomic, retain) NSString *Id;
@property(nonatomic, retain) NSString *sUserName;
@property(nonatomic, retain) NSString *sUserType;
@property(nonatomic, retain) NSString *sProfile;
@property(nonatomic, retain) NSString *sData;
@property(nonatomic, retain) NSString *sTime;
@property(nonatomic, retain) NSString *status;
@property (nonatomic, assign)CGSize bubbleSize;
@property(nonatomic, retain) NSString *sUserImage;

@end
