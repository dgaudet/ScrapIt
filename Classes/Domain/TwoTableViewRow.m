//
//  TwoTableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-12-12.
//
//

#import "TwoTableViewRow.h"

NSString * const TTVR_CELL_IDENTIFIER = @"MTRTVR_CELL_IDENTIFIER";
CGFloat TTVR_ROW_PADDING = 20.0;

@interface TwoTableViewRow (PrivateMethods)

- (CGRect)groupedInnerContentRect;
- (CGRect)subLabelContentRect;
- (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;

@end

@implementation TwoTableViewRow

@synthesize textAlignment, mainLabel, secondaryLabel;

- (id)initWithValue:(NSString *)val andValueTwo:(NSString *)val2 andMethod:(SEL)method {
    self = [super initWithValue:val andMethod:method];
    if (self) {
        _font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        _alignment = UITextAlignmentLeft;
        textAlignment = _alignment;
        _value2 = val2;
    }
    self.mainLabel = [[UILabel alloc] init];
    mainLabel.textColor = [UIColor blackColor];
    self.secondaryLabel = [[UILabel alloc] init];
    secondaryLabel.textColor = [UIColor darkGrayColor];
    return self;
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView {
	NSString *CellIdentifier = TTVR_CELL_IDENTIFIER;
    
	NSInteger mainLabelTag = 1;
	NSInteger subLabelTag = 2;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        [mainLabel setFrame:[self groupedInnerContentRect]];
        mainLabel.backgroundColor = [UIColor clearColor];
        mainLabel.textAlignment = textAlignment;
		mainLabel.font = _font;
        
		mainLabel.lineBreakMode = UILineBreakModeWordWrap;
		mainLabel.numberOfLines = 999;
        mainLabel.tag = mainLabelTag;
		[cell.contentView addSubview:mainLabel];
        
        [secondaryLabel setFrame:[self subLabelContentRect]];
        secondaryLabel.backgroundColor = [UIColor clearColor];
        secondaryLabel.textAlignment = textAlignment;
		secondaryLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        secondaryLabel.tag = subLabelTag;
		[cell.contentView addSubview:secondaryLabel];
    }
    
    // Set up the cell...
    //	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
    CGRect rect = mainLabel.frame;
    rect.size.height = [self heightForString:value withWidth:[self groupedInnerContentRect].size.width withFont:_font];
    mainLabel.frame = rect;
	mainLabel.text = value;
    
    UILabel *subLabel = (UILabel *) [cell.contentView viewWithTag:subLabelTag];
    CGRect subLabelRect = subLabel.frame;
    subLabelRect.origin.y = mainLabel.frame.size.height;
    subLabel.frame = subLabelRect;
	subLabel.text = _value2;
	
    return cell;
}

- (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 485.0) lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 5;
}

- (CGFloat)heightForRow {
    CGFloat mainLabelHeight = [self heightForString:value withWidth:[self groupedInnerContentRect].size.width withFont:_font];
    return mainLabelHeight + TTVR_ROW_PADDING;
}

- (CGRect)groupedInnerContentRect {
    return CGRectMake(10.0, 0.0, 280.0, 40.0);
}

- (CGRect)subLabelContentRect {
    return CGRectMake(20.0, 38.0, 280.0, 15.0);
}

- (void)dealloc {
    [self.mainLabel release];
    [self.secondaryLabel release];
    [super dealloc];
}

@end
