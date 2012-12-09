//
//  SelectionTableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectionTableViewRow.h"

NSString * const STVR_CELL_IDENTIFIER = @"STVR_CELL_IDENTIFIER";

@implementation SelectionTableViewRow

@synthesize label;

- (id)initWithValue:(NSString *)val andLabel:(NSString *)lbl methodWhenSelected:(SEL)method {
    self = [super initWithValue:val andMethod:method];
    if (self) {
        [lbl retain];
        label = lbl;
    }
    return self;
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView {
    NSString *CellIdentifier = STVR_CELL_IDENTIFIER;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.text = label;
    cell.detailTextLabel.text = value;
    
    return cell;
}

- (void)dealloc {
    [label release];
    [super dealloc];
}

@end
