//
//  MapViewController.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class UILoadingAlertView;

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *mapView;
	CLLocationCoordinate2D mapCenter;
	NSArray *placemarksForCity;
    UILoadingAlertView *alertView;
}

@property (nonatomic, retain) NSArray *placemarksForCity;
@property (nonatomic) CLLocationCoordinate2D mapCenter;

@end
