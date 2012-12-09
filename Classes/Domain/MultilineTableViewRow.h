//
//  MultilineTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-03-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewRow.h"

@interface MultilineTableViewRow : TableViewRow {
    UIFont *_font;
    UITextAlignment _alignment;
}

@property UITextAlignment textAlignment;

@end
