//
//  MultilineTextInputTableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 12-01-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultilineTextInputTableViewRow.h"

NSString * const MTITVR_CELL_IDENTIFIER = @"TITVR_CELL_IDENTIFIER";
int const MTITVR_TEXT_FIELD_TAG = 1;
CGFloat const MTITVR_LINE_HEIGHT_SIZE = 25.0;

@implementation MultilineTextInputTableViewRow

@synthesize textView, numberOfLines, delegate;

- (id)initWithValue:(NSString *)val andNumberOfLines:(int)numLines andDelegate:(id)del andMethod:(SEL)method {
    self = [super initWithValue:value andMethod:method];
    if (self) {
        numberOfLines = numLines;
        delegate = del;
        textView = [[UITextView alloc] init];
    }
    
    return self;
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView {
    NSString *CellIdentifier = MTITVR_CELL_IDENTIFIER;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
        textView.frame = CGRectMake(5.0, 10.0, 295.0, MTITVR_LINE_HEIGHT_SIZE * numberOfLines);
        textView.tag = MTITVR_TEXT_FIELD_TAG;
        textView.delegate = delegate;
        textView.returnKeyType = UIReturnKeyDone;
        textView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        textView.textColor = cell.detailTextLabel.textColor;
        textView.backgroundColor = [UIColor clearColor];
        textView.textAlignment = NSTextAlignmentLeft;
		[cell.contentView addSubview:textView];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UITextView *cellTextView = (UITextView*)[cell viewWithTag:MTITVR_TEXT_FIELD_TAG];
    cellTextView.text = value;
    
    return cell;
}

-(NSString *)value {
    return textView.text;
}

- (CGFloat)heightForRow {
    CGFloat topAndBottomPadding = 20;
    return MTITVR_LINE_HEIGHT_SIZE * numberOfLines + topAndBottomPadding;
}

- (void)dismissKeyboard {
    [textView resignFirstResponder];
}

- (void)dealloc {
    [textView release];
    [delegate release];
    [super dealloc];
}

@end
