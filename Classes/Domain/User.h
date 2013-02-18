//
//  User.h
//  ScrapIt
//
//  Created by Dean on 2013-02-17.
//
//

#import <Foundation/Foundation.h>
@class Province;

@interface User : NSObject

@property (nonatomic, retain) Province *province;

- (id)initWithProvince:(Province *)prov;

@end
