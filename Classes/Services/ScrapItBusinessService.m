//
//  ScrapItBusinessService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-10-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrapItBusinessService.h"
#import "EncodingUtil.h"
#import "Business.h"
#import "BusinessSummary.h"
#import "SearchService.h"
#import "Constants.h"
#import "JsonHelper.h"
#import "NetworkErrors.h"

NSString * const SBS_Bus_By_Geo_Location = @"api/v1/businessByGeoLocation";
NSString * const SBS_Bus_By_Details_Location = @"api/v1/businessByDetails";
NSString * const SBS_API_Key_Prefix = @"apikey";

@interface ScrapItBusinessService (PrivateMethods)

- (NSString *)searchUrlWithCoordinates:(CLLocationCoordinate2D)coordinate;
- (NSString *)searchUrlWithBusinessSummary:(BusinessSummary *)business;
- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *)store;
- (NSString *)getLongFormProvinceFromAbbreviation:(NSString *)provinceCode;
- (Business *)businessFromDataArray:(NSArray *)data withBusinessSummary:(BusinessSummary *)summary;
- (NSString *)encodeBusinessName:(NSString *)businessName;

@end

@implementation ScrapItBusinessService

//ScrapIt python app
//ToDo: have the python app fail if you don't have enough query params ie: missing latitude, but have longitude

+ (nonnull id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    return master;
}

- (void)retrieveBusinessesForCoordinates:(CLLocationCoordinate2D)coordinate completionBlock:(nonnull void(^)(NSArray * _Nonnull businesses, NSError * _Nullable error))completion {
    NSString *request = [self searchUrlWithCoordinates:coordinate];
    NSURL *url = [NSURL URLWithString:request];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *businessRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable requestError) {
        NSMutableArray *businesses = [[[NSMutableArray alloc] init] autorelease];
        NSError *error = NULL;
        if (!requestError) {
            if (data) {
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (jsonArray) {
                    NSArray *stores = [NSArray arrayWithArray:[jsonArray valueForKey:@"items"]];
                    if ([stores count] > 0) {
                        for (NSDictionary *store in stores) {
                            BusinessSummary *business = [self retrieveBusinessFromDictionary: store];
                            if(business) {
                                [businesses addObject:business];
                            }
                        }
                    }
                }
            }
        }
        if (requestError) {
            error = [NetworkErrors downloadErrorWithMessage:@"There was a problem retrieving businesses please try again later."];
        }
        completion(businesses, error);
    }];
    [businessRequestTask resume];
}

- (void)businessFromBusinessSummary:(nonnull BusinessSummary *)summary completionBlock:(nonnull void(^)(Business * _Nullable business, NSError * _Nullable error))completion {
    NSString *request = [self searchUrlWithBusinessSummary:summary];
    NSURL *url = [NSURL URLWithString:request];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *businessRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable requestError) {
        Business *businessFromRequest = NULL;
        NSError *error = NULL;
        if (!requestError) {
            if (data) {
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (jsonArray) {
                    businessFromRequest = [self businessFromDataArray:jsonArray withBusinessSummary:summary];
                }
            }
        }
        if (businessFromRequest == NULL || requestError) {
            error = [NetworkErrors downloadErrorWithMessage:@"There was a problem retrieving that business please try again later."];
        }
        completion(businessFromRequest, error);
    }];
    [businessRequestTask resume];
}

- (Business *)businessFromDataArray:(NSArray *)data withBusinessSummary:(BusinessSummary *)summary {
    NSString *phoneNum = @"", *busUrl = @"";
    if ([data valueForKey:@"phoneNumber"]) {
        phoneNum = [JsonHelper stringForJsonValue:[data valueForKey:@"phoneNumber"]];
    }
    if ([data valueForKey:@"url"]) {
        busUrl = [JsonHelper stringForJsonValue:[data valueForKey:@"url"]];
    }
    return [[[Business alloc] initWithBusinessSummary:summary phoneNumber:phoneNum url:busUrl] autorelease];
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
    return [NSString stringWithFormat:@"%@%@?%@=%@&%@", kScrapItServicesBaseUrl, SBS_Bus_By_Geo_Location, SBS_API_Key_Prefix, kScrapItServicesApiKey, queryParams];
}

- (NSString *)searchUrlWithBusinessSummary:(BusinessSummary *)business {
    NSString *encodedName = [self encodeBusinessName:business.name];
    NSString *encodedProvice = [self getLongFormProvinceFromAbbreviation:business.province];
    NSString *queryParams = [NSString stringWithFormat:@"id=%@&province=%@&name=%@", business.businessId, encodedProvice, encodedName];
    return [NSString stringWithFormat:@"%@%@?%@=%@&%@", kScrapItServicesBaseUrl, SBS_Bus_By_Details_Location, SBS_API_Key_Prefix, kScrapItServicesApiKey, queryParams];
}

- (BusinessSummary *)retrieveBusinessFromDictionary:(NSDictionary *)store {
	NSString *name = [NSString stringWithString:[store valueForKey:@"name"]];
	NSString *businessId = [NSString stringWithString:[store valueForKey:@"business_id"]];
	NSString *city = @"";
	NSString *province = @"";
	NSString *street = @"";
	
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
