//
//  DeviceUtil.m
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+ (BOOL)isCurrentDeviceOSOlderThanIos5 {
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([[version substringToIndex:1] intValue] < 5) {
        //iOS 5
        return YES;
    } 
    return NO;
}

+ (BOOL)isCurrentDeviceOSOlderThanIos43 {
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([[version substringToIndex:1] intValue] <= 4) {
        if ([[version substringToIndex:3] intValue] < 3) {
            return YES;
        }
    }
    return NO;
}

@end
