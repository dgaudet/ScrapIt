//
//  PlaceMark.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-05-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class BusinessSummary;


@interface PlaceMark : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
	NSString *title;
	BusinessSummary *businessSummary;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) BusinessSummary *businessSummary;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle;
- (NSString *)title;
- (BusinessSummary *)businessSummary;

@end
