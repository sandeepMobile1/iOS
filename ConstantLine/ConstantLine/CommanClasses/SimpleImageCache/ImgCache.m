//
//  ImgCache.m
//  iMixtapes
//
//  Created by Konstant on 30/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgCache.h"
#define TMP NSTemporaryDirectory()

@implementation ImgCache

- (void) cacheImage: (NSString *) ImageURLString
{
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
	
	NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[ImageURLString substringFromIndex:7]];
	[tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
	
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7];   // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	NSLog(@"%@",filename);
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
		
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
		[data writeToFile:uniquePath atomically:YES];
		[data release];
		
		
		/*
		 
		 UIImage *image = [[UIImage alloc] initWithData: data];
		 
		 // Do we want to round the corners?
		 // image = [self roundCorners: image]; // dont need in this app...
		 
		 // Is it PNG or JPG/JPEG?
		 // Running the image representation function writes the data from the image to a file
		 if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
		 {
		 [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
		 }
		 else if(
		 [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
		 [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
		 )
		 {
		 [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
		 }
		 
		 */
		
		
    }
	
	
}


- (UIImage *) getCachedImage: (NSString *) ImageURLString
{
	
    NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[ImageURLString substringFromIndex:7]];
	
	[tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
	
	NSString *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7]; // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
	NSLog(@"%@",filename);
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
		// image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
		
		NSData* imageData = [[NSData alloc] initWithContentsOfFile:uniquePath];
		image = [[[UIImage alloc] initWithData:imageData] autorelease];
		[imageData release];
		
    }
    else
    {
        // get a new one
        [self cacheImage: ImageURLString];
		
		NSData* imageData = [[NSData alloc] initWithContentsOfFile:uniquePath];
		image = [[[UIImage alloc] initWithData:imageData] autorelease];
		[imageData release];
		
		//NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:ImageURLString]];
		//image = [[UIImage alloc] initWithData:imageData];
        //image = [UIImage imageWithContentsOfFile: uniquePath];
    }
	
    return image;
	
	
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *) roundCorners: (UIImage*) img
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   // CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
   // [img release];
    
    return [UIImage imageWithCGImage:imageMasked];
	
}
- (void)dealloc
{
	
	[super dealloc];
	
}
@end


