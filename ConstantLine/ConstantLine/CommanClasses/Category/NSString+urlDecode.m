//
//  NSString+urlDecode.m
//  EasyOrderKorea
//
//  Created by Pramod Sharma on 01/04/13.
//  Copyright (c) 2013 info@octalsoftware.com. All rights reserved.
//

#import "NSString+urlDecode.h"

@implementation NSString (urlDecode)

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

-(NSString *) getEncodedData:(NSString *)text
{
    NSString *encoded = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                            NULL,
                                                                            (CFStringRef)text,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                            kCFStringEncodingUTF8 ) autorelease];
    return encoded;
}

@end
