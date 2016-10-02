//
//  PlaceMark.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-05-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceMark.h"
#import "BusinessSummary.h"

@implementation PlaceMark

@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
@synthesize businessSummary;

- (NSString *)subtitle{
	return subtitle;
}
- (NSString *)title{
	return title;
}

- (BusinessSummary *)businessSummary{
	return businessSummary;
}


-(id)initWithCoordinate:(CLLocationCoordinate2D) coord{
	coordinate = coord;
	return self;
}

- (void)dealloc {
    [subtitle release];
    [title release];
    [businessSummary release];
    [super dealloc];
}

@end
