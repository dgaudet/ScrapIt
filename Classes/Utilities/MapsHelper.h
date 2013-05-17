//
//  MapsHelper.h
//  ScrapIt
//
//  Created by Dean on 2013-05-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@class Business;

@interface MapsHelper : NSObject

+ (void)loadMapsWithLocation:(Business *)business;

@end
