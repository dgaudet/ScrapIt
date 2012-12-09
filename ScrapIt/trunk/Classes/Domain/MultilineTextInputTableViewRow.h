//
//  MultilineTextInputTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-01-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewRow.h"

@interface MultilineTextInputTableViewRow : TableViewRow {
    UITextView *textView;
    id delegate;
    int numberOfLines;
}

@property(nonatomic, readonly)UITextView *textView;
@property(nonatomic, readonly)int numberOfLines;
@property(nonatomic, retain)id delegate;

- (id)initWithValue:(NSString *)val andNumberOfLines:(int)numLines andDelegate:(id)del andMethod:(SEL)method;
- (CGFloat)heightForRow;

@end
