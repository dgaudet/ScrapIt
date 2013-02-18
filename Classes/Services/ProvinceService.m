//
//  ProvinceService.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProvinceService.h"
#import "Province.h"

@implementation ProvinceService

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil) {
			master = [self new];            
        }
	}
    return master;
}

- (id)init {
    Province *saskatchewan = [[Province alloc] initWithCode:@"sk" name:@"Saskatchewan"];
    Province *alberta = [[Province alloc] initWithCode:@"ab" name:@"Alberta"];
    Province *manitoba = [[Province alloc] initWithCode:@"mb" name:@"Manitoba"];
    Province *britishColumbia = [[Province alloc] initWithCode:@"bc" name:@"British Columbia"];
    Province *northWestTerritories = [[Province alloc] initWithCode:@"nt" name:@"Northwest Territories"];
    Province *newBrunswick = [[Province alloc] initWithCode:@"nb" name:@"New Brunswick"];
    Province *newfoundLand = [[Province alloc] initWithCode:@"nl" name:@"Newfoundland and Labrador"];
    Province *novaScotia = [[Province alloc] initWithCode:@"ns" name:@"Nova Scotia"];
    Province *nunavut = [[Province alloc] initWithCode:@"nu" name:@"Nunavut"];
    Province *princeEdwardIsland = [[Province alloc] initWithCode:@"pe" name:@"Prince Edward Island"];
    Province *ontario = [[Province alloc] initWithCode:@"on" name:@"Ontario"];
    Province *quebec = [[Province alloc] initWithCode:@"qc" name:@"Quebec"];
    Province *yukon = [[Province alloc] initWithCode:@"yt" name:@"Yukon"];
    _provincesSet = [[NSSet alloc] initWithObjects:saskatchewan, alberta, manitoba, britishColumbia, northWestTerritories, newBrunswick, newfoundLand, novaScotia, nunavut, princeEdwardIsland, ontario, quebec, yukon, nil];
    [saskatchewan release];
    [alberta release];
    [manitoba release];
    [britishColumbia release];
    [northWestTerritories release];
    [novaScotia release];
    [newBrunswick release];
    [newfoundLand release];
    [nunavut release];
    [princeEdwardIsland release];
    [ontario release];
    [quebec release];
    [yukon release];
    return self;
}

- (NSSet *)retrieveAllProvinces {
    return [NSSet setWithSet:_provincesSet];
}

- (Province *)retrieveProvinceWithCode:(NSString *)code {
    for (Province *prov in _provincesSet) {
        if ([prov.code caseInsensitiveCompare:code] == NSOrderedSame) {
            return prov;
        }
    }
    return nil;
}

- (Province *)retrieveProvinceWithName:(NSString *)name {
    for (Province *prov in _provincesSet) {
        if ([prov.name caseInsensitiveCompare:name] == NSOrderedSame) {
            return prov;
        }
    }
    return nil;
}

- (Province *)retrieveDefaultProvince {
    return [self retrieveProvinceWithCode:@"sk"];
}

- (void)dealloc {
    [_provincesSet release];
    [super dealloc];
}

@end
