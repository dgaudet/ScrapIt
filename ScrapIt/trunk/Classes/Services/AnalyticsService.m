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

NSString * const AS_City_Search_Key = @"City Search";
NSString * const AS_Business_Detail_Key = @"Business Detail View";
NSString * const AS_Business_Search_Key = @"Business Search";
NSString * const AS_Location_Event_Key = @"Geo Location";
NSString * const AS_External_Resource_Event_Key = @"User Viewed External Resource";
NSString * const AS_Email_Key = @"User Sent Email";
NSString * const AS_User_Tapped_Key = @"User Tapped";

@interface AnalyticsService (PrivateMethods)

+ (NSString *)businessSummaryDataForLogging:(BusinessSummary *)summary;
+ (void)logEventThroughCrashlytics:(NSString *)value forKey:(NSString *)key;

@end

//ToDo: add events for actions on the about page

@implementation AnalyticsService

+ (void)startTrackingAnalytics {    
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingCode];
    [Crashlytics startWithAPIKey:kCrashlyticsCode];
}

+ (void)logSearchEventForBusinessWithCity:(NSString *)city andProvince:(NSString *)province {
    NSString *label = [NSString stringWithFormat:@"Province: %@, City: %@", province, city];
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Business_Search_Key withAction:AS_City_Search_Key withLabel:label withValue:nil];
    [self logEventThroughCrashlytics:AS_City_Search_Key forKey:AS_City_Search_Key];
}

+ (void)logBusinessEventForStoresWithLocation:(CLLocationCoordinate2D)location {
    NSString *latitude = [NSString stringWithFormat:@"%f", location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.longitude];
    NSString *label = [NSString stringWithFormat:@"Longitude: %@, Latitude: %@", longitude, latitude];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Business_Search_Key withAction:AS_Location_Event_Key withLabel:label withValue:nil];
    [self logEventThroughCrashlytics:AS_Location_Event_Key forKey:AS_Business_Search_Key];
}

+ (void)logDetailViewEventForBusiness:(NSString *)businessName inCity:(NSString *)city andProvince:(NSString *)province {
    NSString *label = [NSString stringWithFormat:@"Business: %@, Province: %@, City: %@", businessName, province, city];
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Business_Detail_Key withAction:AS_City_Search_Key withLabel:label withValue:nil];
    [self logEventThroughCrashlytics:AS_City_Search_Key forKey:AS_Business_Detail_Key];
}

+ (void)logViewBusinessInMapsWithBusinessSummary:(BusinessSummary *)businessSummary {
    NSString *action = @"View in Maps";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Business_Detail_Key withAction:action withLabel:[self businessSummaryDataForLogging:businessSummary] withValue:nil];
    [self logEventThroughCrashlytics:AS_Business_Detail_Key forKey:action];
}

+ (void)logViewBusinessUrlInSafariWithBusinessSummary:(BusinessSummary *)businessSummary {
    NSString *action = @"View in Safari";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Business_Detail_Key withAction:action withLabel:[self businessSummaryDataForLogging:businessSummary] withValue:nil];
    [self logEventThroughCrashlytics:AS_Business_Detail_Key forKey:action];
}

+ (void)logCallBusinessWithBusinessSummary:(BusinessSummary *)businessSummary {
    NSString *action = @"Call Business";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Business_Detail_Key withAction:action withLabel:[self businessSummaryDataForLogging:businessSummary] withValue:nil];
    [self logEventThroughCrashlytics:AS_Business_Detail_Key forKey:action];
}

+ (void)logViewedArtworkEvent {
    NSString *action = @"Viewed Artwork";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_External_Resource_Event_Key withAction:action withLabel:nil withValue:nil];
    [self logEventThroughCrashlytics:AS_External_Resource_Event_Key forKey:action];
}

+ (void)logViewedYellowpagesEvent {
    NSString *action = @"Viewed Yellowpages";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_External_Resource_Event_Key withAction:action withLabel:nil withValue:nil];
    [self logEventThroughCrashlytics:AS_External_Resource_Event_Key forKey:action];
}

+ (void)logEmailedSupportEvent {
    NSString *action = @"Support Email";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_Email_Key withAction:action withLabel:nil withValue:nil];
    [self logEventThroughCrashlytics:AS_Email_Key forKey:action];
}

+ (void)logClickedSearchEvent {
    NSString *action = @"Search by city/province";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_User_Tapped_Key withAction:action withLabel:nil withValue:nil];
    [self logEventThroughCrashlytics:AS_User_Tapped_Key forKey:action];
}

+ (void)logClickedFindStoresWithLocationEvent {
    NSString *action = @"Search by Current Location";
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:AS_User_Tapped_Key withAction:action withLabel:nil withValue:nil];
    [self logEventThroughCrashlytics:AS_User_Tapped_Key forKey:action];
}

+ (void)logScreenViewWithName:(NSString *)name {
    [[GAI sharedInstance].defaultTracker sendView:name];
}

+ (NSString *)businessSummaryDataForLogging:(BusinessSummary *)summary {
    return [NSString stringWithFormat:@"Business: %@, Province: %@, City: %@", summary.name, summary.province, summary.city];
}

+ (void)logEventThroughCrashlytics:(NSString *)value forKey:(NSString *)key {
    [Crashlytics setObjectValue:value forKey:key];
    NSString *lastActionString = [NSString stringWithFormat:@"Key: %@ - Value: %@", key, value];
    [Crashlytics setObjectValue:lastActionString forKey:@"last_UI_action"];
}

@end
