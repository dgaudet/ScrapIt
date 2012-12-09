//
//  DeviceService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-16.
//
//

#import <Foundation/Foundation.h>

@interface DeviceService : NSObject

+ (NSString *)getApplicationVersion;
+ (NSString *)getDeviceOSVersion;
+ (NSString *)getMachineType;

@end
