//
//  JsonHelper.m
//  ScrapIt
//
//  Created by Dean on 2013-02-13.
//
//

#import "JsonHelper.h"

@implementation JsonHelper

+ (NSObject *)objectForJsonValue:(NSObject *)value {
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}

+ (NSString *)stringForJsonValue:(NSObject *)value {
    if ([value isKindOfClass:[NSString class]]) {
        return [self stringOrNil:(NSString *)value];
    }
    return nil;
}

+ (NSString *)stringOrNil:(NSString *)value {
    if (value.length < 1) {
        return nil;
    } else {
        return value;
    }
}

@end
