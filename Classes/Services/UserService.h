//
//  UserService.h
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import <Foundation/Foundation.h>
@class User;
@class UserRepository;
@class ProvinceService;

@interface UserService : NSObject {
    UserRepository *_userRepository;
    ProvinceService *_provinceService;
}

+ (id)sharedInstance;
- (User *)retrieveUser;
- (void)saveUser:(User *)user;

@end
