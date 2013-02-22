//
//  AnalyticsService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-16.
//
//

#import "AnalyticsService.h"
#import "DeviceUtil.h"
#import "Constants.h"
#import "DeviceService.h"
#import "GAI.h"
#import "BusinessSummary.h"
#import <Crashlytics/Crashlytics.h>

NSString * const FS_City_Search_Key = @"CitySearch";
NSString * const FS_Location_Search_Key = @"LocationSearch";
NSString * const FS_Business_View_Key = @"BusinessDetailView";
NSString * const FS_City_Event_Key = @"City";
NSString * const FS_Province_Event_Key = @"Province";
NSString * const FS_Business_Event_Key = @"Business";
NSString * const FS_Latitude_Event_Key = @"Latitude";
NSString * const FS_Longitude_Event_Key = @"Longitude";
NSString * const FS_App_Version_Event_Key = @"ApplicationVersion";
NSString * const FS_Device_Version_Event_Key = @"DeviceVersion";
NSString * const FS_Machine_Type_Event_Key = @"MachineType";

@interface AnalyticsService (PrivateMethods)

+ (NSDictionary *)eventForCitySearchWithCity:(NSString *)city inProvince:(NSString *)province;
+ (NSDictionary *)deviceDataDictionary;
+ (NSString *)businessSummaryDataForLogging:(BusinessSummary *)summary;

@end

//ToDo: ensure information about the device is being tracked
//ToDo: add events for actions on the about page

@implementation AnalyticsService

+ (void)startTrackingAnalytics {    
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingCode];
    [Crashlytics startWithAPIKey:@"a5e729783a2ccbc18626b6a118870aae9c94ed75"];
}

+ (void)logSearchEventForBusinessWithCity:(NSString *)city andProvince:(NSString *)province {
    NSString *label = [NSString stringWithFormat:@"Province: %@, City: %@", province, city];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"Business Search" withAction:@"City Search" withLabel:label withValue:nil];
}

+ (void)logBusinessEventForStoresWithLocation:(CLLocationCoordinate2D)location {
    NSString *latitude = [NSString stringWithFormat:@"%f", location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.longitude];
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary setObject:latitude forKey:FS_Latitude_Event_Key];
    [eventDictionary setObject:longitude forKey:FS_Longitude_Event_Key];
    [eventDictionary addEntriesFromDictionary:[self deviceDataDictionary]];
    
    NSString *label = [NSString stringWithFormat:@"Longitude: %@, Latitude: %@", longitude, latitude];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"Business Search" withAction:@"Geo Location" withLabel:label withValue:nil];
}

+ (void)logDetailViewEventForBusiness:(NSString *)businessName inCity:(NSString *)city andProvince:(NSString *)province {
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary addEntriesFromDictionary:[self eventForCitySearchWithCity:city inProvince:province]];
    [eventDictionary setObject:businessName forKey:FS_Business_Event_Key];
    
    NSString *label = [NSString stringWithFormat:@"Business: %@, Province: %@, City: %@", businessName, province, city];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"Business Detail View" withAction:@"City Search" withLabel:label withValue:nil];
}

+ (void)logViewBusinessInMapsWithBusinessSummary:(BusinessSummary *)businessSummary {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"Business Detail View" withAction:@"View in Maps" withLabel:[self businessSummaryDataForLogging:businessSummary] withValue:nil];
}

+ (void)logViewBusinessUrlInSafariWithBusinessSummary:(BusinessSummary *)businessSummary {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"Business Detail View" withAction:@"View in Safari" withLabel:[self businessSummaryDataForLogging:businessSummary] withValue:nil];
}

+ (void)logCallBusinessWithBusinessSummary:(BusinessSummary *)businessSummary {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"Business Detail View" withAction:@"Call Business" withLabel:[self businessSummaryDataForLogging:businessSummary] withValue:nil];
}

+ (void)logViewedArtworkEvent {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"User Viewed External Resource" withAction:@"Viewed Artwork" withLabel:nil withValue:nil];
}

+ (void)logViewedYellowpagesEvent {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"User Viewed External Resource" withAction:@"Viewed Yellowpages" withLabel:nil withValue:nil];
}

+ (void)logEmailedSupportEvent {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"User Sent Email" withAction:@"Support Email" withLabel:nil withValue:nil];
}

+ (void)logClickedSearchEvent {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"User Tapped" withAction:@"Search by city/province" withLabel:nil withValue:nil];
}

+ (void)logClickedFindStoresWithLocationEvent {
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"User Tapped" withAction:@"Search by Current Location" withLabel:nil withValue:nil];
}

+ (void)logScreenViewWithName:(NSString *)name {
    [[GAI sharedInstance].defaultTracker sendView:name];
}

+ (NSDictionary *)eventForCitySearchWithCity:(NSString *)city inProvince:(NSString *)province {
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary setObject:city forKey:FS_City_Event_Key];
    [eventDictionary setObject:province forKey:FS_Province_Event_Key];
    [eventDictionary addEntriesFromDictionary:[self deviceDataDictionary]];    
    return eventDictionary;
}

+ (NSDictionary *)deviceDataDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[DeviceService getApplicationVersion] forKey:FS_App_Version_Event_Key];
    [dictionary setObject:[DeviceService getDeviceOSVersion] forKey:FS_Device_Version_Event_Key];
    [dictionary setObject:[DeviceService getMachineType] forKey:FS_Machine_Type_Event_Key];
    return dictionary;
}

+ (NSString *)businessSummaryDataForLogging:(BusinessSummary *)summary {
    return [NSString stringWithFormat:@"Business: %@, Province: %@, City: %@", summary.name, summary.province, summary.city];
}

@end
