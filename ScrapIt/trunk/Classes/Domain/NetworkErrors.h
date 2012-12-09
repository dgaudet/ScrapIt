//
//  NetworkErrors.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-11.
//
//

#import <Foundation/Foundation.h>

@interface NetworkErrors : NSObject

+ (NSError *)noWifiError;
+ (NSError *)downloadErrorWithMessage:(NSString *)message;

@end
