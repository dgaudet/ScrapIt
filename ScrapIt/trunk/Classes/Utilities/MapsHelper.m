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

@interface MapsHelper (PrivateMethods)

+ (void)loadMapsIniOS6AndAboveWithLocation:(Business *)business;
+ (void)loadMapsBelowiOS6WithLocation:(Business *)business;

@end

@implementation MapsHelper

+ (void)loadMapsWithLocation:(Business *)business {
    Class itemClass = [MKMapItem class];
    
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        [self loadMapsIniOS6AndAboveWithLocation:business];
    }
    [self loadMapsBelowiOS6WithLocation:business];
}

+ (void)loadMapsIniOS6AndAboveWithLocation:(Business *)business {
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: business.businessSummary.street,
                              (NSString *)kABPersonAddressCityKey: business.businessSummary.city,
                              (NSString *)kABPersonAddressStateKey: business.businessSummary.province,
                              (NSString *)kABPersonAddressCountryCodeKey: @"CA"
                              };
    MKPlacemark *placemark = [[[MKPlacemark alloc] initWithCoordinate:business.businessSummary.geoLocation addressDictionary:address] autorelease];
    MKMapItem *mapItem = [[[MKMapItem alloc] initWithPlacemark:placemark] autorelease];
    [mapItem setName:business.businessSummary.name];
    [mapItem setPhoneNumber:business.phoneNumber];
    [mapItem setUrl:[NSURL URLWithString:business.url]];
    [mapItem openInMapsWithLaunchOptions:nil];
}

+ (void)loadMapsBelowiOS6WithLocation:(Business *)business {
    NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f+(%@)", business.businessSummary.geoLocation.latitude, business.businessSummary.geoLocation.longitude, [EncodingUtil urlEncodedString:business.businessSummary.name]];
    NSURL *url = [NSURL URLWithString:urlText];
    [[UIApplication sharedApplication] openURL:url];
}

@end
