//
//  UserRepository.m
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import "UserRepository.h"

@implementation UserRepository

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

- (User *)retrieveUser {
    return nil;
}

- (void)saveUser:(User *)user {
    
}

@end
