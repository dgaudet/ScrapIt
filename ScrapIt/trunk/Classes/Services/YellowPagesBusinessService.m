//
//  YellowPagesBusinessService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YellowPagesBusinessService.h"
#import "JSON.h"
#import "BusinessSummary.h"
#import "Business.h"
#import "SearchService.h"
#import "EncodingUtil.h"
#import "Constants.h"

NSString * const BASE_URL = kYellowPagesBaseUrl;
NSString * const SEARCH_TERM = @"scrapbook";

@interface YellowPagesBusinessService (PrivateMethods)

- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *) store;
- (NSString *)getLongFormProvinceFromAbbreviation:(NSString *)provinceCode;
- (NSArray *)retrieveBusinessesFromUrl:(NSString *)searchUrl;
- (NSString *)searchUrlWithLocation:(NSString *)location;

@end

//ToDo: fix business names to remove accents from letters
//ToDo: gracefully handle errors returned when retreiving business data
//ToDo: thread retrieving businesses
//ToDo: thread retrieving retrieveBusinessFromBusinessSummary
//ToDo: handle multiple pages of results ie Toronto
//ToDo: handle what would happen if you requested business details and it failed

@implementation YellowPagesBusinessService

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

- (NSArray *)retrieveBusinessesForCity:(NSString *)city {
	//http://code.google.com/apis/maps/documentation/webservices/
	//https://maps.googleapis.com/maps/api/place/search/json?location=52.134331,-106.64772&radius=500&types=establishment&name=yesterday&sensor=false&key=AIzaSyDTawuHftPN6J8HyH_A1bT5gQTQ9wOZfE4
	//google api console
	//yellow pages .ca - looks like it is better for canada anyway
	//http://api.yellowapi.com/FindBusiness/?what=scrapbook&where=Saskatoon&fmt=XML&pgLen=10&apikey=a1s2d3f4g5h6j7k8l9k6j5j4&UID=127.0.0.1
	//http://api.yellowapi.com/FindBusiness/?what=scrapbook&where=Saskatoon&fmt=JSON&pgLen=10&apikey=a1s2d3f4g5h6j7k8l9k6j5j4&UID=127.0.0.1
	NSString *encodedCity = [EncodingUtil urlEncodedString:city];
	NSString *request = [self searchUrlWithLocation:encodedCity];
    
    //    NSLog(@"request: %@", request);
    return [self retrieveBusinessesFromUrl:request];
}

- (NSArray *)retrieveBusinessesForCoordinates:(CLLocationCoordinate2D)coordinate {
    NSString *coordinateString = [NSString stringWithFormat:@"cZ%.8f,%.8f", coordinate.longitude, coordinate.latitude];
    NSString *request = [self searchUrlWithLocation:coordinateString];
    
    //    NSLog(@"request: %@", request);
    return [self retrieveBusinessesFromUrl:request];

}

- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *) store {
	NSString *name = [NSString stringWithString:[store valueForKey:@"name"]];
	NSString *yellowPagesId = [NSString stringWithString:[store valueForKey:@"id"]];
	NSString *city;
	NSString *province;
	NSString *street;
	
	if ([store valueForKey:@"address"]) {
		NSDictionary *address = [NSDictionary dictionaryWithDictionary:[store valueForKey:@"address"]];
		city = [NSString stringWithString:[address valueForKey:@"city"]];
		province = [NSString stringWithString:[address valueForKey:@"prov"]];
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

- (Business *)retrieveBusinessFromBusinessSummary:(BusinessSummary *)business {
	//http://api.yellowapi.com/GetBusinessDetails/?prov=Saskatchewan&city=Saskatoon&bus-name=Michaels&listingId=2409271&fmt=XML&apikey=a1s2d3f4g5h6j7k8l9k6j5j4&UID=127.0.0.1
	//http://api.yellowapi.com/GetBusinessDetails/?prov=Saskatchewan&city=Saskatoon&bus-name=just-scrap-it&listingId=4436892fmt=XML&apikey=a1s2d3f4g5h6j7k8l9k6j5j4&UID=127.0.0.1
//	NSString *encodedCity = [EncodingUtil urlEncodedString:business.city];
	NSString *encodedName = [self encodeBusinessName:business.name];
	NSString *request = [NSString stringWithFormat:@"%@/GetBusinessDetails/?prov=%@&bus-name=%@&listingId=%@&fmt=JSON&apikey=%@&UID=127.0.0.1", 
						 BASE_URL, [self getLongFormProvinceFromAbbreviation:business.province], encodedName, business.yellowPagesId, kYellowPagesApiKey];
//	NSLog(@"Request: %@", request);
	NSURL *url = [NSURL URLWithString:request];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSArray *results = [responseString JSONValue];
	
	NSString *phoneNum, *busUrl;
	if ([results valueForKey:@"phones"]) {
		NSArray *phones = [NSArray arrayWithArray:[results valueForKey:@"phones"]];
		NSDictionary *phoneDictionary = [NSDictionary dictionaryWithDictionary:[phones objectAtIndex:0]];
		phoneNum = [NSString stringWithString:[phoneDictionary valueForKey:@"dispNum"]];
	}
	if ([results valueForKey:@"merchantUrl"]) {
		busUrl = [NSString stringWithString:[results valueForKey:@"merchantUrl"]];
	}
	return [[[Business alloc] initWithBusinessSummary:business phoneNumber:phoneNum url:busUrl] autorelease];
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

- (NSString *)encodeBusinessName:(NSString *)businessName {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"[\\W]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *encodedName = [businessName stringByReplacingOccurrencesOfString:@"-" withString:@"--"];
    encodedName = [regEx stringByReplacingMatchesInString:encodedName options:0 range:NSMakeRange(0, [businessName length]) withTemplate:@"-"];
    return encodedName;
}

- (NSString *)searchUrlWithLocation:(NSString *)location {
    return [NSString stringWithFormat:@"%@/FindBusiness/?what=%@&where=%@&fmt=JSON&pgLen=100&apikey=%@&UID=127.0.0.1", BASE_URL, SEARCH_TERM, location, kYellowPagesApiKey];
}

- (NSArray *)retrieveBusinessesFromUrl:(NSString *)searchUrl {    
    NSURL *url = [NSURL URLWithString:searchUrl];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [responseString JSONValue];
	NSArray *stores = [NSArray arrayWithArray:[results valueForKey:@"listings"]];
	
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

@end
