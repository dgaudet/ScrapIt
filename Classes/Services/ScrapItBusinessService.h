//
//  ScrapItBusinessService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-10-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ScrapItBusinessService : NSObject

+ (id)sharedInstance;
- (NSString *)retrieveURLForBusinessWithYellowPagesId:(NSString *)ypId;
- (NSArray *)retrieveBusinessesForCoordinates:(CLLocationCoordinate2D)coordinate;

@end
