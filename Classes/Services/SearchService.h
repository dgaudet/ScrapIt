//
//  SearchService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class Business;
@class BusinessSummary;
@class Province;
@class Reachability;

@interface SearchService : NSObject {
    Reachability *_reachability;
}

+ (id)sharedInstance;
- (NSArray *)retrievePlacemarksForCoordinates:(CLLocationCoordinate2D)coordinate error:(NSError **)error;
- (CLLocationCoordinate2D)retrieveCenterCoordinatesForCity:(NSString *)city inProvince:(Province *)province error:(NSError **)error;
- (CLLocationCoordinate2D)retrieveCoordinatesForStreet:(NSString *)street city:(NSString *)city province:(NSString *)prov country:(NSString *)country error:(NSError **)error;
- (Business *)retrieveBusinessFromBusinessSummary:(BusinessSummary *)businessSummary error:(NSError **)error;

@end
