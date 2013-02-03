//
//  ScrapItBusinessService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-10-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrapItBusinessService.h"
#import "JSON.h"

NSString * const SBS_API_LOCATION = @"api/business/";

@implementation ScrapItBusinessService

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    return master;
}

- (NSString *)retrieveURLForBusinessWithYellowPagesId:(NSString *)ypId {
    NSString *businessUrl = nil;
    NSString *request = [NSString stringWithFormat:@"%@%@%@", kScrapItServicesBaseUrl, SBS_API_LOCATION, ypId];
	NSURL *url = [NSURL URLWithString:request];
	NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
    if ([responseString isEqualToString:@"null"]) {
        return nil;
    } else {
        NSDictionary *results = [responseString JSONValue];
        businessUrl = [results valueForKey:@"url"];
	}
    
    return businessUrl;
}

@end
