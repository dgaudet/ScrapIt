//
//  Business.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class BusinessSummary;

@interface Business : NSObject {
}

@property (nonatomic, readonly) BusinessSummary *businessSummary;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, retain) NSString *url;

- (id)initWithBusinessSummary:(BusinessSummary*)bus_summary phoneNumber:(NSString *)phone_num url:(NSString *)_url;

@end
