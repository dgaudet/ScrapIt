//
//  MultilineTableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 12-03-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultilineTableViewRow.h"

NSString * const MTVR_CELL_IDENTIFIER = @"MTVR_CELL_IDENTIFIER";
CGFloat MTVR_ROW_PADDING = 20.0;

@interface MultilineTableViewRow (PrivateMethods)

- (CGRect)groupedInnerContentRect;
- (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;

@end

@implementation MultilineTableViewRow

@synthesize textAlignment;

- (id)initWithValue:(NSString *)val andMethod:(SEL)method {
    self = [super initWithValue:val andMethod:method];
    if (self) {
        _font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        _alignment = NSTextAlignmentLeft;
        textAlignment = _alignment;
    }
    return self;
}
    
- (UITableViewCell *)cellInTableView:(UITableView *)tableView {
	NSString *CellIdentifier = MTVR_CELL_IDENTIFIER;
    
	NSInteger mainLabelTag = 1;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:[self groupedInnerContentRect]];
        mainLabel.backgroundColor = [UIColor clearColor];
        mainLabel.textAlignment = textAlignment;
		mainLabel.font = _font;
        mainLabel.textColor = [UIColor blackColor];
		mainLabel.lineBreakMode = UILineBreakModeWordWrap;
		mainLabel.numberOfLines = 999;
        mainLabel.tag = mainLabelTag;		
		[cell.contentView addSubview:mainLabel];
		[mainLabel release];
    }
    
    // Set up the cell...
	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
    CGRect rect = mainLabel.frame;
    rect.size.height = [self heightForString:value withWidth:[self groupedInnerContentRect].size.width withFont:_font];
    mainLabel.frame = rect;
	mainLabel.text = value;	
    
    return cell;	
}

- (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 485.0) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + MTVR_ROW_PADDING;
}

- (CGFloat)heightForRow {    
    return [self heightForString:value withWidth:[self groupedInnerContentRect].size.width withFont:_font];
}

- (CGRect)groupedInnerContentRect {
    return CGRectMake(10.0, 0.0, 280.0, 40.0);
}

@end
