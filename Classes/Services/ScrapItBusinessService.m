//
//  ScrapItBusinessService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-10-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrapItBusinessService.h"
#import "JSON.h"
#import "EncodingUtil.h"
#import "Business.h"
#import "BusinessSummary.h"
#import "SearchService.h"

NSString * const SBS_Bus_By_Id_Location = @"api/business/";
NSString * const SBS_Bus_By_City_Location = @"api/businessByCity/";
NSString * const SBS_Bus_By_Geo_Location = @"api/businessByGeoLocation";

@interface ScrapItBusinessService (PrivateMethods)

- (NSString *)searchUrlWithCoordinates:(CLLocationCoordinate2D)coordinate;
- (NSArray *)retrieveBusinessesFromUrl:(NSString *)searchUrl;
- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *)store;

@end

@implementation ScrapItBusinessService

//ToDo: ensure that businesses that have special chars in their name still work, they may be double encoded
//ScrapIt python app
//ToDo: find out how to pull longitude and latitude from the google db object
//ToDo: find out how to parse parameters from the url request in python
//ToDo: get the phones and merchant url in python
//ToDo: see if I can get the correct ip from headers, so I can pass them to the Yellow Pages service
//ToDo: have the python app fail if you don't have enough query params ie: missing latitude, but have longitude

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    return master;
}

- (NSString *)retrieveURLForBusinessWithYellowPagesId:(NSString *)ypId {
    NSString *businessUrl = nil;
    NSString *request = [NSString stringWithFormat:@"%@%@%@", kScrapItServicesBaseUrl, SBS_Bus_By_Id_Location, ypId];
	NSURL *url = [NSURL URLWithString:request];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
    if ([responseString isEqualToString:@"null"]) {
        return nil;
    } else {
        NSDictionary *results = [responseString JSONValue];
        businessUrl = [results valueForKey:@"url"];
	}
    
    return businessUrl;
}

- (NSArray *)retrieveBusinessesForCoordinates:(CLLocationCoordinate2D)coordinate {
    NSString *request = [self searchUrlWithCoordinates:coordinate];
    
    //    NSLog(@"request: %@", request);
    return [self retrieveBusinessesFromUrl:request];    
}

- (NSString *)searchUrlWithCoordinates:(CLLocationCoordinate2D)coordinate {
    NSString *queryParams = [NSString stringWithFormat:@"longitude=%.8f&latitude=%.8f", coordinate.longitude, coordinate.latitude];
    return [NSString stringWithFormat:@"%@%@?%@", kYellowPagesBaseUrlLocal, SBS_Bus_By_Geo_Location, queryParams];
}

- (NSArray *)retrieveBusinessesFromUrl:(NSString *)searchUrl {
    NSURL *url = [NSURL URLWithString:searchUrl];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [responseString JSONValue];
	NSArray *stores = [NSArray arrayWithArray:[results valueForKey:@"items"]];
	
	NSMutableArray *businesses = [[[NSMutableArray alloc] init] autorelease];
	if ([stores count] > 0) {
		for (NSDictionary *store in stores) {
			BusinessSummary *business = [self retrieveBusinessFromDictionary: store];
			if(business) {
				[businesses addObject:business];
			}
		}
		return businesses;
	}
	return nil;
}

- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *)store {
	NSString *name = [NSString stringWithString:[store valueForKey:@"name"]];
	NSString *yellowPagesId = [NSString stringWithString:[store valueForKey:@"yellowpages_id"]];
	NSString *city;
	NSString *province;
	NSString *street;
	
	if ([store valueForKey:@"address"]) {
		NSDictionary *address = [NSDictionary dictionaryWithDictionary:[store valueForKey:@"address"]];
		city = [NSString stringWithString:[address valueForKey:@"city"]];
		province = [NSString stringWithString:[address valueForKey:@"province"]];
		street = [NSString stringWithString:[address valueForKey:@"street"]];
	}
	if ([[store valueForKey:@"geoCode"] isKindOfClass:[NSDictionary class]]) {
		NSDictionary *geoCode = [NSDictionary dictionaryWithDictionary:[store valueForKey:@"geoCode"]];
		double lat = [[geoCode valueForKey:@"latitude"] doubleValue];
		double longitude = [[geoCode valueForKey:@"longitude"] doubleValue];
		CLLocationCoordinate2D location = {lat, longitude};
		BusinessSummary *business = [[[BusinessSummary alloc] initWithName:name city:city province:province street:street geoLocation:location yellowPagesId:yellowPagesId] autorelease];
		
		return business;
	} else {
        NSError *error = nil;
        CLLocationCoordinate2D location = [[SearchService sharedInstance] retrieveCoordinatesForStreet:street city:city province:province country:@"ca" error:&error];
        if(!error){
            BusinessSummary *business = [[[BusinessSummary alloc] initWithName:name city:city province:province street:street geoLocation:location yellowPagesId:yellowPagesId] autorelease];
            return business;
        }
    }
	
	return nil;
}

@end
