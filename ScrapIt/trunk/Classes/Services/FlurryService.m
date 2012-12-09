//
//  FlurryService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-16.
//
//

#import "FlurryService.h"
#import "Flurry.h"
#import "DeviceUtil.h"
#import "Constants.h"
#import "DeviceService.h"

void flurryServiceUncaughtExceptionHandler(NSException *exception) {
    if (![DeviceUtil isCurrentDeviceOSOlderThanIos43]) {
        [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
    }
}

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

@interface FlurryService (PrivateMethods)

+ (NSDictionary *)eventForCitySearchWithCity:(NSString *)city inProvince:(NSString *)province;
+ (NSDictionary *)deviceDataDictionary;

@end

@implementation FlurryService

+ (void)startFlurry {
    [Flurry startSession:@"P3DCXVKMTQSDJH53M85D"];
}

+ (void)logSearchEventForBusinessWithCity:(NSString *)city andProvince:(NSString *)province {
    [Flurry logEvent:FS_City_Search_Key withParameters:[self eventForCitySearchWithCity:city inProvince:province]];
}

+ (void)logBusinessEventForStoresWithLocation:(CLLocationCoordinate2D)location {
    NSString *latitude = [NSString stringWithFormat:@"%f", location.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.longitude];
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary setObject:latitude forKey:FS_Latitude_Event_Key];
    [eventDictionary setObject:longitude forKey:FS_Longitude_Event_Key];
    [eventDictionary addEntriesFromDictionary:[self deviceDataDictionary]];
    [Flurry logEvent:FS_Location_Search_Key withParameters:eventDictionary];
}

+ (void)logDetailViewEventForBusiness:(NSString *)businessName inCity:(NSString *)city andProvince:(NSString *)province {
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary addEntriesFromDictionary:[self eventForCitySearchWithCity:city inProvince:province]];
    [eventDictionary setObject:businessName forKey:FS_Business_Event_Key];
    [Flurry logEvent:FS_Business_View_Key withParameters:eventDictionary];
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

@end
