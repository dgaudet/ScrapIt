//
//  MultilineTextInputTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-01-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewRow.h"

@interface MultilineTwoRowTableViewRow : TableViewRow {
    UIFont *_font;
    NSTextAlignment _alignment;
    NSString *_value2;
}

@property NSTextAlignment textAlignment;
@property UITableViewCellSelectionStyle cellSelectionStyle;

- (id)initWithValue:(NSString *)val andValueTwo:(NSString *)val2 andMethod:(SEL)method;

@end
