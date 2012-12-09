//
//  TextInputTableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TextInputTableViewRow.h"
#import "ScrapItTableViewController.h"

NSString * const TITVR_CELL_IDENTIFIER = @"TITVR_CELL_IDENTIFIER";
int const TITVR_TEXTFIELD_TAG = 2;

@implementation TextInputTableViewRow

@synthesize label, textField, delegate;

- (id)initWithValue:(NSString *)val andLabel:(NSString *)lbl andDelegate:(id)del andMethod:(SEL)method {
    self = [super initWithValue:val andMethod:method];
    if (self) {
        [lbl retain];
        label = lbl;
        delegate = del;
        selector = method;
        textField = [[UITextField alloc] init];
    }
    
    return self;
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView {
    NSString *CellIdentifier = TITVR_CELL_IDENTIFIER;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		
        textField.frame = CGRectMake(50.0, 10.0, 230.0, 25.0);
        textField.tag = TITVR_TEXTFIELD_TAG;
        textField.delegate = delegate;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        textField.textColor = cell.detailTextLabel.textColor;
        textField.textAlignment = UITextAlignmentRight;
		[cell.contentView addSubview:textField];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UITextField *cellTextField = (UITextField*)[cell viewWithTag:TITVR_TEXTFIELD_TAG];	
	cellTextField.placeholder = value;
    cell.textLabel.text = label;
    
    return cell;
}

-(NSString *)value {
    return textField.text;
}

- (void)dismissKeyboard {
    [textField resignFirstResponder];
}

- (void)dealloc {
    [textField release];
    [label release];
    [super dealloc];
}

@end
