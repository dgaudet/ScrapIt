//
//  SelectionTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewRow.h"

@interface SelectionTableViewRow : TableViewRow {
    NSString *label;
}

@property(nonatomic, retain)NSString *label;

- (id)initWithValue:(NSString *)val andLabel:(NSString *)lbl methodWhenSelected:(SEL)method;

@end
