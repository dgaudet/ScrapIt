//
//  GoogleSearchService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Province;

@interface GoogleSearchService : NSObject {

}

+ (id)sharedInstance;
- (NSDictionary *)retrieveCityLocationResults:(NSString *)city inProvince:(Province *)province;
- (CLLocationCoordinate2D)retrieveCoordinatesForCityResults:(NSDictionary *)results;
- (CLLocationCoordinate2D)retrieveCoordinatesForStreet:(NSString *)street city:(NSString *)city province:(NSString *)prov country:(NSString *)country error:(NSError **)error;

@end
