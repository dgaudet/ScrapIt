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

+ (_Nonnull id)sharedInstance;
- (CLLocationCoordinate2D)retrieveCenterCoordinatesForCity:(NSString * _Nonnull)city inProvince:(Province * _Nonnull)province error:(NSError **)error;
- (CLLocationCoordinate2D)retrieveCoordinatesForStreet:(NSString * _Nonnull)street city:(NSString * _Nonnull)city province:(NSString *)prov country:(NSString * _Nonnull)country error:(NSError **)error;
- (void)retrievePlacemarksForCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(nonnull void(^)(NSArray * _Nonnull placemarks, NSError * _Nullable error))completion;
- (void)businessFromBusinessSummary:(BusinessSummary * _Nonnull)businessSummary completionBlock:(nonnull void(^)(Business * _Nullable business, NSError * _Nullable error))completion;

@end
