//
//  Province.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject {
    NSString *code;
    NSString *name;
}

@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *name;

- (id)initWithCode:(NSString *)provCode name:(NSString *)provName;

@end
