//
//  User.m
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import "User.h"
#import "Province.h"

@implementation User

@synthesize province;

- (id)initWithProvince:(Province *)prov {
    self = [super init];
    if (self) {
        [prov retain];
        province = prov;
    }
    return self;
}

- (NSString *)description {
    return self.province.description;
}

- (void)dealloc {
    [province release];
    [super dealloc];
}

@end
