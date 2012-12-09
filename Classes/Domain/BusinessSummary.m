//
//  BusinessSummary.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusinessSummary.h"

@implementation BusinessSummary

@synthesize name, country, city, province, street, geoLocation, yellowPagesId;

- (id)initWithName:(NSString*)bus_name city:(NSString *)_city province:(NSString *)bus_prov street:(NSString *)bus_street 
	   geoLocation:(CLLocationCoordinate2D)bus_loc yellowPagesId:(NSString *)pagesId {
	self = [super init];
    if (self) {
        // Custom initialization.
		name = [NSString stringWithString:bus_name];
		[name retain];
		country = @"Canada";
		[country retain];
		city = [NSString stringWithString:_city];
		[city retain];
		province = [NSString stringWithString:bus_prov];
		[province retain];
		street = [NSString stringWithString:bus_street];
		[street retain];
		geoLocation = bus_loc;		
		yellowPagesId = pagesId;
		[yellowPagesId retain];
    }
	
	return self;
}

- (void)dealloc {
	[name release];
	[country release];
	[province release];
	[street release];
	[yellowPagesId release];
	[super dealloc];
}

@end
