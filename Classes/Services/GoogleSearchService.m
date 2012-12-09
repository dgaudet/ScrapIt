//
//  GoogleSearchService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleSearchService.h"
#import "Province.h"
#import "JSON.h"
#import "EncodingUtil.h"

NSString * const GOOGLE_OK_STATUS = @"OK";

@implementation GoogleSearchService

//ToDo: Clean up retrieve cityLocationResults and Coordinates for city, to be one call
//ToDo: fix city center for Quebec
//ToDo: Find the correct location when searching for a city such as Halifax, I assume we need to set the country to search for
//ToDo: thread retrieving city information
//ToDo: refactor all methods into class methods, and remove shared instance
//ToDo: clean up the city search method, it is a duplicate of other methods in the class

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

- (NSDictionary *)retrieveCityLocationResults:(NSString *)city inProvince:(Province *)province {
	//http://code.google.com/apis/maps/documentation/geocoding/
	//http://maps.googleapis.com/maps/api/geocode/xml?address=saskatoon,+sk&sensor=false
	NSString *address = [city stringByAppendingFormat:@", %@", province.code];
    NSString *encodedAddress = [EncodingUtil urlEncodedString:address];
	NSString *request = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true&region=ca", encodedAddress];
//    NSLog(@"Google Request: %@", request);
	NSURL *url = [NSURL URLWithString:request];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [responseString JSONValue];
	
	if ([[results valueForKey:@"status"] isEqualToString:GOOGLE_OK_STATUS]) {
		return results;
	}
	return nil;
}

- (CLLocationCoordinate2D)retrieveCoordinatesForCityResults:(NSDictionary *)results {
	NSDictionary *dataResults = [results valueForKey:@"results"];
	NSDictionary *geometry = [dataResults valueForKey:@"geometry"];
	NSDictionary *location = [geometry valueForKey:@"location"];
	
	double lat = [[[location valueForKey:@"lat"] objectAtIndex:0] doubleValue];
	double lng = [[[location valueForKey:@"lng"] objectAtIndex:0] doubleValue];
		
	CLLocationCoordinate2D coordinate = {lat,lng};
	return coordinate;
}

- (CLLocationCoordinate2D)retrieveCoordinatesForStreet:(NSString *)street city:(NSString *)city province:(NSString *)prov country:(NSString *)country error:(NSError **)error {
    NSString *searchAddress = [NSString stringWithString:street];
    if (city) {
        searchAddress = [searchAddress stringByAppendingFormat:@", %@", city];
    }
    if (prov) {
        searchAddress = [searchAddress stringByAppendingFormat:@", %@", prov];
    }
    
    NSString *encodedSearchAddress = [EncodingUtil urlEncodedString:searchAddress];
    NSString *request = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true&region=ca", encodedSearchAddress];
    
//    NSLog(@"Request: %@", request);
    
	NSURL *url = [NSURL URLWithString:request];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *results = [responseString JSONValue];
	
    CLLocationCoordinate2D coordinate = {0.0,0.0}; //default if now coordinates can be found
	if ([[results valueForKey:@"status"] isEqualToString:GOOGLE_OK_STATUS]) {
        coordinate = [[GoogleSearchService sharedInstance] retrieveCoordinatesForCityResults:results];
	} else {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"There was no address found with that name" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:errorDetail];
    }

	return coordinate;
}

@end
