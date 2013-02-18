//
//  UserRepository.m
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import "UserRepository.h"
#import "Province.h"
#import "User.h"
#import "ProvinceService.h"

NSString *const UR_User_Province_Code = @"Province_Code";

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

- (id)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _provinceService = [ProvinceService sharedInstance];
    }
    
    return self;
}

- (User *)retrieveUser {
    NSString *provinceCode = [_userDefaults stringForKey:UR_User_Province_Code];
    if (provinceCode) {
        Province *province = [_provinceService retrieveProvinceWithCode:provinceCode];
        User *user = [[User alloc] initWithProvince:province];
        return [user autorelease];
    }
    return nil;
}

- (void)saveUser:(User *)user {
    [_userDefaults setObject:user.province.code forKey:UR_User_Province_Code];
}

@end
