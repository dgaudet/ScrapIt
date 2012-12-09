//
//  TableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewRow.h"

@implementation TableViewRow

@synthesize value, selector;

- (id)initWithValue:(NSString *)val andMethod:(SEL)method {
    self = [super init];
    if (self) {
        [val retain];
        value = val;
        selector = method;
    }
    
    return self;
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView{
    return nil;
}

- (CGFloat)heightForRow {
    return 45.0;
}

- (void)dealloc {
    [value release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Value: %@", value];
}

@end
