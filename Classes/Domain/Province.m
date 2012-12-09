//
//  Province.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Province.h"

@implementation Province

@synthesize code, name;

- (id)initWithCode:(NSString *)provCode name:(NSString *)provName {
    self = [super init];
    if (self) {
        [provCode retain];
        code = provCode;
        [provName retain];
        name = provName;
    }
    
    return self;
}

- (NSComparisonResult)compare:(Province *)otherObject {
    return [self.name compare:otherObject.name];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Code: %@, Name: %@", code, name];
}

- (void)dealloc {
    [code release];
    [name release];
    [super dealloc];
}

@end
