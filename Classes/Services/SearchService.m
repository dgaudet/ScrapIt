//
//  SearchService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchService.h"
#import "PlaceMark.h"
#import "GoogleSearchService.h"
#import "Province.h"
#import "Business.h"
#import "BusinessSummary.h"
#import "ScrapItBusinessService.h"
#import "Reachability.h"
#import "NetworkErrors.h"
#import "AnalyticsService.h"

@interface SearchService (PrivateMethods)

- (NSArray *)generatePlacemarksFromBusinesses:(NSArray *)businesses;
    
@end

@implementation SearchService

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil) {
			master = [self new];
        }
	}
    return master;
}

- (id)init {
    self = [super init];
    if (self) {
        _reachability = [[Reachability reachabilityForInternetConnection] retain];
    }
    return self;
}

- (void)dealloc {
    [_reachability release];
    [super dealloc];
}

- (NSArray *)generatePlacemarksFromBusinesses:(NSArray *)businesses {
    if ([businesses count] > 0) {
        NSMutableArray *placemarks = [[[NSMutableArray alloc] init] autorelease];
		for (BusinessSummary *business in businesses) {
            PlaceMark *placemark = [[PlaceMark alloc] initWithCoordinate:business.geoLocation];
            placemark.title = [business.name capitalizedString];
            placemark.subtitle = business.street;
            placemark.businessSummary = business;
            [placemarks addObject:placemark]; 
            [placemark release];
		}
		return placemarks;
	}
	return nil;
}

- (NSArray *)retrievePlacemarksForCoordinates:(CLLocationCoordinate2D)coordinate error:(NSError **)error {
    if ([_reachability currentReachabilityStatus] == NotReachable) {
        if (*error != NULL) {
            *error = [NetworkErrors noWifiError];
        }
        return [NSArray array];
    }
    NSArray *businesses = [[ScrapItBusinessService sharedInstance] retrieveBusinessesForCoordinates:coordinate];
    [AnalyticsService logBusinessEventForStoresWithLocation:coordinate];
    return [self generatePlacemarksFromBusinesses:businesses];
}

- (void)businessFromBusinessSummary:(BusinessSummary *)businessSummary completionBlock:(void(^)(Business * _Nullable business, NSError * _Nullable error))completion {
    if ([_reachability currentReachabilityStatus] == NotReachable) {
        NSError *error = [NetworkErrors noWifiError];
        completion(NULL, error);
    }
    
    [[ScrapItBusinessService sharedInstance] businessFromBusinessSummary:businessSummary completionBlock:^(Business * _Nullable business, NSError * _Nullable error) {
        if (business != NULL) {
            [AnalyticsService logDetailViewEventForBusiness:businessSummary.name inCity:businessSummary.city andProvince:businessSummary.province];
        }
        completion(business, error);
    }];
}

- (CLLocationCoordinate2D)retrieveCenterCoordinatesForCity:(NSString *)city inProvince:(Province *)province error:(NSError **)error {
    if ([_reachability currentReachabilityStatus] == NotReachable) {
        if (*error != NULL) {
            *error = [NetworkErrors noWifiError];
        }
        return CLLocationCoordinate2DMake(0.0, 0.0);
    } else {
        NSDictionary *locationResults = [[GoogleSearchService sharedInstance] retrieveCityLocationResults:city inProvince:province];
        if (!locationResults) {
            if (*error != NULL) {
                *error = [NetworkErrors downloadErrorWithMessage:@"There was no city found with that name"];
            }
            return CLLocationCoordinate2DMake(0.0, 0.0);
        }
        [AnalyticsService logSearchEventForBusinessWithCity:city andProvince:province.name];
        return [[GoogleSearchService sharedInstance] retrieveCoordinatesForCityResults:locationResults];
    }
}

- (CLLocationCoordinate2D)retrieveCoordinatesForStreet:(NSString *)street city:(NSString *)city province:(NSString *)prov country:(NSString *)country error:(NSError **)error {
    return [[GoogleSearchService sharedInstance] retrieveCoordinatesForStreet:street city:city province:prov country:country error:error];
}

@end
