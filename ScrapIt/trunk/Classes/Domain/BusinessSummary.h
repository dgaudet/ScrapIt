//
//  BusinessSummary.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusinessSummary : NSObject {
	NSString *name;
	NSString *country;
	NSString *city;
	NSString *province;
	NSString *street;
	CLLocationCoordinate2D geoLocation;
	NSString *businessId;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *city;
@property (nonatomic, readonly) NSString *province;
@property (nonatomic, readonly) NSString *street;
@property (nonatomic, readonly) CLLocationCoordinate2D geoLocation;
@property (nonatomic, readonly) NSString *businessId;

- (id)initWithName:(NSString*)bus_name city:(NSString *)_city province:(NSString *)bus_prov street:(NSString *)bus_street 
	   geoLocation:(CLLocationCoordinate2D)bus_loc businessId:(NSString *)pagesId;

@end
