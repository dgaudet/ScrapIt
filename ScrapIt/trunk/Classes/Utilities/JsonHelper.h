//
//  JsonHelper.h
//  ScrapIt
//
//  Created by Dean on 2013-02-13.
//
//

#import <Foundation/Foundation.h>

@interface JsonHelper : NSObject

+ (NSString *)stringForJsonValue:(NSObject *)value;
+ (NSString *)stringOrNil:(NSString *)value;

@end
