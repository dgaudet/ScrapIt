//
//  ApplicationError.m
//  ScrapIt
//
//  Created by Dean on 2016-10-30.
//
//

#import "ApplicationError.h"

@implementation ApplicationError

+ (NSError *)generalError {
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Sorry an error occurred please try again later" forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:errorInfo];
}

@end
