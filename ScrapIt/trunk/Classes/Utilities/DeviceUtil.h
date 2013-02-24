//
//  DeviceUtil.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtil : NSObject

+ (CGSize)screenSize;
+ (BOOL)isCurrentDeviceIPhone5;
+ (BOOL)isCurrentDeviceOSOlderThanIos5;
+ (BOOL)isCurrentDeviceOSOlderThanIos43;

@end
