//
//  UserService.h
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import <Foundation/Foundation.h>
@class User;

@interface UserService : NSObject

- (User *)retrieveUser;
- (void)saveUser:(User *)user;

@end
