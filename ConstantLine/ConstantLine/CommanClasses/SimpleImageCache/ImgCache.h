//
//  ImgCache.h
//  iMixtapes
//
//  Created by Konstant on 30/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgCache : NSObject {
	
}

- (void) cacheImage: (NSString *) ImageURLString;
- (UIImage *) getCachedImage: (NSString *) ImageURLString;
- (UIImage *) roundCorners: (UIImage*) img;

@end