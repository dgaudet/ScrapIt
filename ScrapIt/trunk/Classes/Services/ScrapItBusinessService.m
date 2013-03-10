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
#import "Constants.h"
#import "JsonHelper.h"
#import "NetworkErrors.h"

NSString * const SBS_Bus_By_Id_Location = @"api/v1/business/";
NSString * const SBS_Bus_By_City_Location = @"api/v1/businessByCity/";
NSString * const SBS_Bus_By_Geo_Location = @"api/v1/businessByGeoLocation";
NSString * const SBS_Bus_By_Details_Location = @"api/v1/businessByDetails";

@interface ScrapItBusinessService (PrivateMethods)

- (NSString *)searchUrlWithCoordinates:(CLLocationCoordinate2D)coordinate;
- (NSString *)searchUrlWithBusinessSummary:(BusinessSummary *)business;
- (NSArray *)retrieveBusinessesFromUrl:(NSString *)searchUrl;
- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *)store;
- (NSString *)getLongFormProvinceFromAbbreviation:(NSString *)provinceCode;
- (NSString *)encodeBusinessName:(NSString *)businessName;

@end

@implementation ScrapItBusinessService

//ScrapIt python app
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

- (NSString *)retrieveURLForBusinessWithId:(NSString *)ypId {
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

- (Business *)retrieveBusinessFromBusinessSummary:(BusinessSummary *)business error:(NSError **)error {
	NSString *request = [self searchUrlWithBusinessSummary:business];
	NSURL *url = [NSURL URLWithString:request];
    NSError *requestError = nil;
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&requestError];
    if (requestError) {
        *error = [NetworkErrors downloadErrorWithMessage:@"There was a problem retrieving that business please try again later."];
        return nil;
    }
	NSArray *results = [responseString JSONValue];
	
	NSString *phoneNum, *busUrl;
	if ([results valueForKey:@"phoneNumber"]) {
		phoneNum = [JsonHelper stringForJsonValue:[results valueForKey:@"phoneNumber"]];
	}
	if ([results valueForKey:@"url"]) {
        busUrl = [JsonHelper stringForJsonValue:[results valueForKey:@"url"]];
	}
	return [[[Business alloc] initWithBusinessSummary:business phoneNumber:phoneNum url:busUrl] autorelease];
}

- (NSString *)encodeBusinessName:(NSString *)businessName {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"[\\W]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *encodedName = [businessName stringByReplacingOccurrencesOfString:@"-" withString:@"--"];
    encodedName = [regEx stringByReplacingMatchesInString:encodedName options:0 range:NSMakeRange(0, [businessName length]) withTemplate:@"-"];
    encodedName = [encodedName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedName;
}

- (NSString *)searchUrlWithCoordinates:(CLLocationCoordinate2D)coordinate {
    NSString *queryParams = [NSString stringWithFormat:@"longitude=%.8f&latitude=%.8f", coordinate.longitude, coordinate.latitude];
    return [NSString stringWithFormat:@"%@%@?%@", kScrapItServicesBaseUrl, SBS_Bus_By_Geo_Location, queryParams];
}

- (NSString *)searchUrlWithBusinessSummary:(BusinessSummary *)business {
    NSString *encodedName = [self encodeBusinessName:business.name];
    NSString *encodedProvice = [self getLongFormProvinceFromAbbreviation:business.province];
    NSString *queryParams = [NSString stringWithFormat:@"id=%@&province=%@&name=%@", business.businessId, encodedProvice, encodedName];
    return [NSString stringWithFormat:@"%@%@?%@", kScrapItServicesBaseUrl, SBS_Bus_By_Details_Location, queryParams];
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
	NSString *businessId = [NSString stringWithString:[store valueForKey:@"business_id"]];
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
		BusinessSummary *business = [[[BusinessSummary alloc] initWithName:name city:city province:province street:street geoLocation:location businessId:businessId] autorelease];
		
		return business;
	} else {
        NSError *error = nil;
        CLLocationCoordinate2D location = [[SearchService sharedInstance] retrieveCoordinatesForStreet:street city:city province:province country:@"ca" error:&error];
        if(!error){
            BusinessSummary *business = [[[BusinessSummary alloc] initWithName:name city:city province:province street:street geoLocation:location businessId:businessId] autorelease];
            return business;
        }
    }
	
	return nil;
}

- (NSString *)getLongFormProvinceFromAbbreviation:(NSString *)provinceCode {
    NSString *provinceName = @"Saskatchewan";
    provinceCode = [provinceCode lowercaseString];
    NSDictionary *countryNameDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Alberta", @"ab",
                                     @"Manitoba", @"mb",
                                     @"British-Columbia", @"bc",
                                     @"Northwest-Territories", @"nt",
                                     @"New-Brunswick", @"nb",
                                     @"Newfoundland-and-Labrador", @"nl",
                                     @"Nova-Scotia", @"ns",
                                     @"Nunavut", @"nu",
                                     @"Prince-Edward-Island", @"pe",
                                     @"Ontario", @"on",
                                     @"Quebec", @"qc",
                                     @"Yukon", @"yt",
                                     nil];
    if ([countryNameDict objectForKey:provinceCode]) {
        provinceName = [countryNameDict objectForKey:provinceCode];
    }
    return provinceName;
}

@end
