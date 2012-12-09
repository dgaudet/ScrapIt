//
//  NetworkErrors.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-11.
//
//

#import "NetworkErrors.h"

@implementation NetworkErrors

+ (NSError *)noWifiError {
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Sorry you currently have no internet connection" forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:errorInfo];
}

+ (NSError *)downloadErrorWithMessage:(NSString *)message {
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:errorInfo];
}

@end
