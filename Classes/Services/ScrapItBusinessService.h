//
//  ScrapItBusinessService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-10-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class Business;
@class BusinessSummary;

@interface ScrapItBusinessService : NSObject

+ (_Nonnull id)sharedInstance;
- (void)retrieveBusinessesForCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(nonnull void(^)(NSArray * _Nonnull businesses, NSError * _Nullable error))completion;
- (void)businessFromBusinessSummary:(nonnull BusinessSummary *)summary completionBlock:(nonnull void(^)(Business * _Nullable business, NSError * _Nullable error))completion;

@end
