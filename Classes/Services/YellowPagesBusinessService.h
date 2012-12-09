//
//  YellowPagesBusinessService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class Business;
@class BusinessSummary;

@interface YellowPagesBusinessService : NSObject {

}

+ (id)sharedInstance;
- (NSArray *)retrieveBusinessesForCity:(NSString *)city;
- (NSArray *)retrieveBusinessesForCoordinates:(CLLocationCoordinate2D)coordinate;
- (Business *)retrieveBusinessFromBusinessSummary:(BusinessSummary *)business;
- (NSString *)encodeBusinessName:(NSString *)businessName;

@end
