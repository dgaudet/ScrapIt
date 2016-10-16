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
#import "BusinessSummary.h"
#import <Google/Analytics.h>
#import <Crashlytics/Crashlytics.h>

NSString * const AS_City_Search_Key = @"City Search";
NSString * const AS_Business_Detail_Key = @"Business Detail View";
NSString * const AS_Business_Search_Key = @"Business Search";
NSString * const AS_Location_Event_Key = @"Geo Location";
NSString * const AS_External_Resource_Event_Key = @"User Viewed External Resource";
NSString * const AS_Email_Key = @"User Sent Email";
NSString * const AS_User_Tapped_Key = @"User Tapped";

@interface AnalyticsService (PrivateMethods)

+ (void)setupGoogleAnalytics;
+ (NSString *)businessSummaryDataForLogging:(BusinessSummary *)summary;
+ (void)logEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label;
+ (void)logEventThroughGoogleCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label;
+ (void)logEventThroughCrashlytics:(NSString *)value forKey:(NSString *)key;

@end

//ToDo: add events for actions on the about page

@implementation AnalyticsService

+ (void)startTrackingAnalytics {    
    [self setupGoogleAnalytics];
    [Crashlytics startWithAPIKey:kCrashlyticsCode];
}

+ (void)logSearchEventForBusinessWithCity:(NSString *)city andProvince:(NSString *)province {
    NSString *label = [NSString stringWithFormat:@"Province: %@, City: %@", province, city];
    [self logEventWithCategory:AS_Business_Search_Key withAction:AS_City_Search_Key withLabel:label];
}

+ (void)logBusinessEventForStoresWithLocation:(CLLocationCoordinate2D)location {
    NSString *latitude = [NSString stringWithFormat:@"%f", location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.longitude];
    NSString *label = [NSString stringWithFormat:@"Longitude: %@, Latitude: %@", longitude, latitude];
    
    [self logEventWithCategory:AS_Business_Search_Key withAction:AS_Location_Event_Key withLabel:label];
}

+ (void)logDetailViewEventForBusiness:(NSString *)businessName inCity:(NSString *)city andProvince:(NSString *)province {
    NSString *label = [NSString stringWithFormat:@"Business: %@, Province: %@, City: %@", businessName, province, city];
    
    [self logEventWithCategory:AS_Business_Detail_Key withAction:AS_City_Search_Key withLabel:label];
}

+ (void)logViewBusinessInMapsWithBusinessSummary:(BusinessSummary *)businessSummary {
    NSString *action = @"View in Maps";
    
    [self logEventThroughGoogleCategory:AS_Business_Detail_Key withAction:action withLabel:[self businessSummaryDataForLogging:businessSummary]];
    [self logEventThroughCrashlytics:AS_Business_Detail_Key forKey:action];
}

+ (void)logViewBusinessUrlInSafariWithBusinessSummary:(BusinessSummary *)businessSummary {
    NSString *action = @"View in Safari";
    [self logEventThroughGoogleCategory:AS_Business_Detail_Key withAction:action withLabel:[self businessSummaryDataForLogging:businessSummary]];
    [self logEventThroughCrashlytics:AS_Business_Detail_Key forKey:action];
}

+ (void)logCallBusinessWithBusinessSummary:(BusinessSummary *)businessSummary {
    NSString *action = @"Call Business";
    [self logEventThroughGoogleCategory:AS_Business_Detail_Key withAction:action withLabel:[self businessSummaryDataForLogging:businessSummary]];
    [self logEventThroughCrashlytics:AS_Business_Detail_Key forKey:action];
}

+ (void)logViewedArtworkEvent {
    NSString *action = @"Viewed Artwork";
    [self logEventThroughGoogleCategory:AS_External_Resource_Event_Key withAction:action withLabel:nil];
    [self logEventThroughCrashlytics:AS_External_Resource_Event_Key forKey:action];
}

+ (void)logViewedYellowpagesEvent {
    NSString *action = @"Viewed Yellowpages";
    [self logEventThroughGoogleCategory:AS_External_Resource_Event_Key withAction:action withLabel:nil];
    [self logEventThroughCrashlytics:AS_External_Resource_Event_Key forKey:action];
}

+ (void)logEmailedSupportEvent {
    NSString *action = @"Support Email";
    [self logEventThroughGoogleCategory:AS_Email_Key withAction:action withLabel:nil];
    [self logEventThroughCrashlytics:AS_Email_Key forKey:action];
}

+ (void)logClickedSearchEvent {
    NSString *action = @"Search by city/province";
    [self logEventThroughGoogleCategory:AS_User_Tapped_Key withAction:action withLabel:nil];
    [self logEventThroughCrashlytics:AS_User_Tapped_Key forKey:action];
}

+ (void)logClickedFindStoresWithLocationEvent {
    NSString *action = @"Search by Current Location";
    [self logEventThroughGoogleCategory:AS_User_Tapped_Key withAction:action withLabel:nil];
    [self logEventThroughCrashlytics:AS_User_Tapped_Key forKey:action];
}

+ (void)logScreenViewWithName:(NSString *)name {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

+ (void)setupGoogleAnalytics {
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    
#ifdef Test
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
#endif
}

+ (NSString *)businessSummaryDataForLogging:(BusinessSummary *)summary {
    return [NSString stringWithFormat:@"Business: %@, Province: %@, City: %@", summary.name, summary.province, summary.city];
}

+ (void)logEventWithCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label {
    [self logEventThroughGoogleCategory:category withAction:action withLabel:label];
    [self logEventThroughCrashlytics:action forKey:category];
}

+ (void)logEventThroughGoogleCategory:(NSString *)category withAction:(NSString *)action withLabel:(NSString *)label {
    //[[GAI sharedInstance].defaultTracker sendEventWithCategory:category withAction:action withLabel:label withValue:nil];
}

+ (void)logEventThroughCrashlytics:(NSString *)value forKey:(NSString *)key {
    [Crashlytics setObjectValue:value forKey:key];
    NSString *lastActionString = [NSString stringWithFormat:@"Key: %@ - Value: %@", key, value];
    [Crashlytics setObjectValue:lastActionString forKey:@"last_UI_action"];
}

@end
