//
//  DeviceService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-16.
//
//

#import "DeviceService.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation DeviceService

+ (NSString *)getApplicationVersion {
    NSString *versionString = @"CFBundleVersion";
//    NSString *versionString = @"CFBundleVersionString";
    NSString *shortBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:versionString];
    return shortBundleVersion;
}

+ (NSString *)getDeviceOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getMachineType {
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    // Done with this
    free(name);
    
    return machine;
}

@end
