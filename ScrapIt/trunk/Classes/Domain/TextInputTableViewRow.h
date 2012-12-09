//
//  TextInputTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewRow.h"

@interface TextInputTableViewRow : TableViewRow {
    NSString *label;
    UITextField *textField;
    id delegate;
}

@property(nonatomic, retain)NSString *label;
@property(nonatomic, readonly)UITextField *textField;
@property(nonatomic, retain)id delegate;

- (id)initWithValue:(NSString *)val andLabel:(NSString *)lbl andDelegate:(id)del andMethod:(SEL)method;
- (void)dismissKeyboard;

@end
