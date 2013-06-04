//
//  MapsHelper.m
//  ScrapIt
//
//  Created by Dean on 2013-05-16.
//
//

#import "MapsHelper.h"
#import "EncodingUtil.h"
#import "Business.h"
#import "BusinessSummary.h"
#import "DeviceUtil.h"

@interface MapsHelper (PrivateMethods)

+ (void)loadMapsIniOS6AndAboveWithLocation:(Business *)business;
+ (void)loadMapsBelowiOS6WithLocation:(Business *)business;

@end

@implementation MapsHelper

+ (void)loadMapsWithLocation:(Business *)business {
    Class itemClass = [MKMapItem class];
    
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        [self loadMapsIniOS6AndAboveWithLocation:business];
    } else {
        [self loadMapsBelowiOS6WithLocation:business];
    }
}

+ (void)loadMapsIniOS6AndAboveWithLocation:(Business *)business {
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: business.businessSummary.street,
                              (NSString *)kABPersonAddressCityKey: business.businessSummary.city,
                              (NSString *)kABPersonAddressStateKey: business.businessSummary.province,
                              (NSString *)kABPersonAddressCountryCodeKey: @"CA"
                              };
    MKPlacemark *placemark = [[[MKPlacemark alloc] initWithCoordinate:business.businessSummary.geoLocation addressDictionary:address] autorelease];
    MKMapItem *businessMapItem = [[[MKMapItem alloc] initWithPlacemark:placemark] autorelease];
    [businessMapItem setName:business.businessSummary.name];
    [businessMapItem setPhoneNumber:business.phoneNumber];
    [businessMapItem setUrl:[NSURL URLWithString:business.url]];
    [businessMapItem openInMapsWithLaunchOptions:nil];
    
//    NSArray *mapItems = [NSArray arrayWithObjects:[MKMapItem mapItemForCurrentLocation], businessMapItem, nil];
//    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving };
//    
//    [MKMapItem openMapsWithItems:mapItems launchOptions:options];
}

+ (void)loadMapsBelowiOS6WithLocation:(Business *)business {
    NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f+(%@)", business.businessSummary.geoLocation.latitude, business.businessSummary.geoLocation.longitude, [EncodingUtil urlEncodedString:business.businessSummary.name]];
    NSURL *url = [NSURL URLWithString:urlText];
    [[UIApplication sharedApplication] openURL:url];
}

+ (NSString *)locationServicesSettingsLocation {
    //iOS 6.1.3
    NSString *locationLocation = @"Settings -> Privacy -> Location Services";
    
    if ([DeviceUtil isCurrentDeviceOSMainVersionEqualTo:5]) {
        locationLocation = @"Settings -> Location Services";
    }
    if ([DeviceUtil isCurrentDeviceOSOlderThanIos5]) {
        locationLocation = @"Settings -> General -> Location Services";
    }
    
    return [NSString stringWithFormat:@"You must go to %@ to Allow us to Determine Your Location", locationLocation];
}

@end
