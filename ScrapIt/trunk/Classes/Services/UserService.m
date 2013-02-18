//
//  UserService.m
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import "UserService.h"
#import "UserRepository.h"
#import "User.h"
#import "ProvinceService.h"
#import "Province.h"

@implementation UserService

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
    self = [super init];
    if (self) {
        _userRepository = [UserRepository sharedInstance];
        _provinceService = [ProvinceService sharedInstance];
    }
    
    return self;
}

- (User *)retrieveUser {
    User *user = [_userRepository retrieveUser];
    if (!user) {
        Province *defaultProvince = [_provinceService retrieveDefaultProvince];
        user = [[[User alloc] initWithProvince:defaultProvince] autorelease];
    }
    return user;
}
- (void)saveUser:(User *)user {
    [_userRepository saveUser:user];
}

@end
