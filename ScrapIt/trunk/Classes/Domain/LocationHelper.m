//
//  LocationHelper.m
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationHelper.h"
#import "DeviceUtil.h"

//ToDo: possibly have the calling class pass in mehtods to be called when manager fails or when a location is found
//ToDo: when setting up locaiton manager, if there is already a location set, check the timestamp, if it is older than "an hour" then don't return it or something

@interface LocationHelper (PrivateMethods)

- (void)initializeLocationManager;
- (void)setupLocationManager;
- (void)displayCheckSettingsAlert;
- (BOOL)canSendUserToSettings;

@end

@implementation LocationHelper

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        [self initializeLocationManager];
    }
    return self;
}

- (void)initializeLocationManager {
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setPurpose:@"Used to Find stores close to you"];
        [locationManager setDelegate:self];
    }
}

- (void)setupLocationManager {
    NSLog(@"Authorization status before start: %i", [CLLocationManager authorizationStatus]);
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        if ([DeviceUtil isCurrentDeviceOSOlderThanIos5]) {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            [locationManager startUpdatingLocation];
        } else {
            [locationManager startMonitoringSignificantLocationChanges];
        }
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self displayCheckSettingsAlert];
        if ([delegate respondsToSelector:@selector(locationHelper:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:nil];
            [self.delegate locationHelper:self didFailWithError:error];
        }
    }
    
}

- (BOOL)canSendUserToSettings {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]]) {
        return YES;
    }
    return NO;
}

-(CLLocation *)findCurrentLocation {
    [self setupLocationManager];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        if(locationManager.location){
            return locationManager.location;
        }
    } 
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if ([delegate respondsToSelector:@selector(locationHelper:didUpdateToLocation:fromLocation:)]) {
        [self.delegate locationHelper:self didUpdateToLocation:newLocation fromLocation:oldLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([delegate respondsToSelector:@selector(locationHelper:didFailWithError:)]) {
        [self.delegate locationHelper:self didFailWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"DID_CHANGE_AUTH_STATUS - Authorization status has changed: %i", status);
}

- (void)displayCheckSettingsAlert {
    if ([self canSendUserToSettings]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn On Location Services to Allow us to Determine Your Location"
                                                        message:[locationManager purpose]
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        [alert show];
        [alert release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services are currently off.\nYou must go to Settings -> General -> Location Services to Allow us to Determine Your Location"
                                                        message:[locationManager purpose]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {    
    if ([alertView cancelButtonIndex] != buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
}

- (void)dealloc {
    [locationManager release];
    [super dealloc];
}

@end

/*
 * Test Scenario's for use current location button
 * Location services completely off, click button???
 * Never used the app
 ** Should be asked to turn on location settings
 ** User clicked ok
 *** should continue on and later call didUpdateToLocation on delegate
 ** User clicked No
 *** should call didFailWithError
 
 * Used the app before, Current location not null
 ** setup will be able to return a location
 ** didUpdateToLocation will also be called
 
 * Used the app before, Current location same as old location
 ** setup will be able to return the location
 ** didUpdateToLocation will also be called with current location for both old and new location
 
 * Used the app before, just start app, current location different from old location
 ** setup will be able to return the old location
 ** didUpdateToLocation will also be called with new location and old location
 
 * Said no when asked to use location services - should be the same as when Location services are completely off
 ** clicked find again
 *** either after closing app or not
 ** Should be notified that you can modify settings in order to get this to work
 **  should call didFailWithError
 *** iOS 5 should have a settings button to lead you to the settings app
 **** Click cancel in iOS 5, or ok in iOS 4
 ***** message box just disappears
 **** Click settings in iOS 5
 ***** should be sent to location services in settings app
 ****** If user turns on location services for app
 ******* didUpdateToLocation will be called when switching to app(If it was running in background)
 
 * said yes, then while the app is running, you go to settings and turn it off for the app only
 ** When bringing app back into focus
 *** didChangeAuthStatus called
 *** didFailWithError called 
 
 * said yes, then while the app is running, you go to settings and turn it off all location Services
 ** When bringing app back into focus
 *** didChangeAuthStatus called
 *** automatically asked to turn on location services by os
*/