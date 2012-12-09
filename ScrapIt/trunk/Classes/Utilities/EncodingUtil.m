//
//  EncodingUtil.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EncodingUtil.h"

@implementation EncodingUtil

+ (NSString *)urlEncodedString:(NSString *)string {
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)string,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return [encodedString autorelease];
}

@end
