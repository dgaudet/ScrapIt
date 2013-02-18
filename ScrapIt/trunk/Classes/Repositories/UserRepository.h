//
//  UserRepository.h
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import <Foundation/Foundation.h>
@class User;
@class ProvinceService;

@interface UserRepository : NSObject {
    NSUserDefaults *_userDefaults;
    ProvinceService *_provinceService;
}

+ (id)sharedInstance;
- (User *)retrieveUser;
- (void)saveUser:(User *)user;

@end
