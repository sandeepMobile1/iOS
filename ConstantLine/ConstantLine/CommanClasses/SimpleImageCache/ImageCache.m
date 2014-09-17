//
//  ImageCache.h
//  SurveySwipe
//
//  Created by Chandika Bhandari on 2/14/11.
//  Copyright 2011 SurveyAnalytics. All rights reserved.
//


#import "IconRecord.h"
#import "ImageCache.h"
@implementation ImageCache

@synthesize imageDownloadsInProgress=_imageDownloadsInProgress, delegate;


- (void)startDownloadForUrl:(NSString*) url withSize:(CGSize)size forIndexPath:(NSIndexPath*)path{
	if (!self.imageDownloadsInProgress) {
		NSMutableDictionary* dic = [[[NSMutableDictionary alloc] init] autorelease];
		self.imageDownloadsInProgress = dic;
	}
	
	if (!url || [url length] == 0) {
		return;
	}
	
	IconRecord* record = [_imageDownloadsInProgress objectForKey:url];
	if (record != Nil) {
		for (NSIndexPath* p in record.indexPaths) {
			if ([p compare:path] == NSOrderedSame) {
				return; // already downloading
			}
		}
		[record.indexPaths addObject:path];
		return; // already downloading.
	}
	
	record = [[[IconRecord alloc] init] autorelease];
	[record.indexPaths addObject:path];
	[_imageDownloadsInProgress setObject:record forKey:url];
	[record startDownloadWithUrl:url withParent:self withSize:size];
}

-(void) purge:(NSInteger)maxCount {
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
	if ([allDownloads count] >= maxCount) {
		[allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
		[_imageDownloadsInProgress removeAllObjects];
	}
}

- (UIImage*)iconForUrl:(NSString*)url {
	if (!url || [url length] == 0) {
		return Nil;
	}
	
	IconRecord *record = [self.imageDownloadsInProgress objectForKey:url];
	
	return [record icon];
}

- (void)cancelDownload {
	// terminate all pending download connections
	self.delegate = Nil;
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)downloadFinishedWithIconRecord:(IconRecord *)record {
	[self.delegate iconDownloadedForUrl:record.url forIndexPaths:record.indexPaths withImage:record.icon withDownloader:self];
}

@end


