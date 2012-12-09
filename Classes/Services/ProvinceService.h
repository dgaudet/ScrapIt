//
//  ProvinceService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Province;

@interface ProvinceService : NSObject {
    NSSet *_provincesSet;
}

+ (id)sharedInstance;
- (NSSet *)retrieveAllProvinces;
- (Province *)retrieveProvinceWithCode:(NSString *)code;
- (Province *)retrieveProvinceWithName:(NSString *)name;

@end
