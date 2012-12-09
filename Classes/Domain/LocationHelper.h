//
//  LocationHelper.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationHelperDelegate;

@interface LocationHelper : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate> {
    CLLocationManager *locationManager;
    id<LocationHelperDelegate> delegate;
}

@property (assign)id<LocationHelperDelegate> delegate;

-(CLLocation *)findCurrentLocation;

@end

@protocol LocationHelperDelegate <NSObject>

- (void)locationHelper:(LocationHelper *)locationHelper didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationHelper:(LocationHelper *)locationHelper didFailWithError:(NSError *)error;

@end
