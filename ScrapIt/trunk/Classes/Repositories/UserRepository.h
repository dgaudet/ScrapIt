//
//  UserRepository.h
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import <Foundation/Foundation.h>
@class User;

@interface UserRepository : NSObject

+ (id)sharedInstance;
- (User *)retrieveUser;
- (void)saveUser:(User *)user;

@end
