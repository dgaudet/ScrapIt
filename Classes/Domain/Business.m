//
//  Business.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Business.h"
#import "BusinessSummary.h"

@implementation Business

@synthesize businessSummary, phoneNumber, url;

- (id)initWithBusinessSummary:(BusinessSummary*)bus_summary phoneNumber:(NSString *)phone_num url:(NSString *)_url {
	self = [super init];
    if (self) {
        // Custom initialization.
        [bus_summary retain];
		businessSummary = bus_summary;
		[phone_num retain];
        phoneNumber = phone_num;
        [_url retain];
		url	= _url;
    }
	
	return self;
}

- (void)dealloc {
	[businessSummary release];
	[phoneNumber release];
	[url release];
	[super dealloc];
}

@end
