//
//  IconRecord.h
//  SurveySwipe
//
//  Created by Chandika Bhandari on 2/29/11.
//  Copyright 2011 SurveyAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSURLConnection.h>

@class ImageCache;

@interface IconRecord : NSObject {
	ImageCache* _parent;
	NSMutableData* _activeDownload;
	NSURLConnection* _imageConnection;
}

@property(nonatomic, retain) NSString* url;
@property(nonatomic, retain) UIImage* icon;
@property(nonatomic, retain) NSMutableData *activeDownload;
@property(nonatomic, retain) NSURLConnection *imageConnection;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, retain) NSMutableArray* indexPaths;

-(void)startDownloadWithUrl:(NSString*)url withParent:(ImageCache*)downloader withSize:(CGSize)size;
-(void)cancelDownload;

@end
