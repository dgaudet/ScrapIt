//
//  TwoTableViewRow.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-12-12.
//
//

#import "TwoTableViewRow.h"

NSString * const TTVR_CELL_IDENTIFIER = @"TTVR_CELL_IDENTIFIER";

@interface TwoTableViewRow (PrivateMethods)

- (CGRect)groupedInnerContentRect;
- (CGRect)subLabelContentRect;
- (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;

@end

@implementation TwoTableViewRow

@synthesize label1Font = _label1Font;
@synthesize label1Color = _label1Color;
@synthesize label2Font = _label2Font;
@synthesize label2Color = _label2Color;
@synthesize textAlignment = _textAlignment;
@synthesize cellSelectionStyle = _cellSelectionStyle;

- (id)initWithValue:(NSString *)val andValueTwo:(NSString *)val2 andMethod:(SEL)method {
    self = [super initWithValue:val andMethod:method];
    if (self) {
        _textAlignment = UITextAlignmentLeft;
        _cellSelectionStyle = UITableViewCellSelectionStyleGray;
        _value2 = val2;
        _label1Font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        _label1Color = [UIColor blackColor];
        
        _label2Font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        [_label2Font retain];
        _label2Color = [UIColor darkGrayColor];
    }
    
    return self;
}

- (UITableViewCell *)cellInTableView:(UITableView *)tableView {
	NSString *CellIdentifier = TTVR_CELL_IDENTIFIER;
    
	NSInteger mainLabelTag = 1;
	NSInteger subLabelTag = 2;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *mainLabel = [[UILabel alloc] init];
        [mainLabel setFrame:[self groupedInnerContentRect]];
        mainLabel.backgroundColor = [UIColor clearColor];
        mainLabel.lineBreakMode = UILineBreakModeWordWrap;
        mainLabel.numberOfLines = 999;
        mainLabel.tag = mainLabelTag;
		[cell.contentView addSubview:mainLabel];
        
        UILabel *secondaryLabel = [[UILabel alloc] init];
        [secondaryLabel setFrame:[self subLabelContentRect]];        
        secondaryLabel.backgroundColor = [UIColor clearColor];
        secondaryLabel.lineBreakMode = UILineBreakModeWordWrap;
        secondaryLabel.numberOfLines = 999;        
        secondaryLabel.tag = subLabelTag;
		[cell.contentView addSubview:secondaryLabel];
    }
    
    UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
    CGRect rect = mainLabel.frame;    
    mainLabel.textAlignment = _textAlignment;
    mainLabel.font = _label1Font;
    mainLabel.textColor = _label1Color;
	mainLabel.text = value;
    
    rect.size.height = [self heightForString:value withWidth:[self groupedInnerContentRect].size.width withFont:mainLabel.font];
    mainLabel.frame = rect;
    
    UILabel *secondaryLabel = (UILabel *) [cell.contentView viewWithTag:subLabelTag];
    CGRect subLabelRect = secondaryLabel.frame;
    subLabelRect.origin.y = mainLabel.frame.size.height;
    secondaryLabel.font = _label2Font;
    secondaryLabel.textAlignment = _textAlignment;
    secondaryLabel.textColor = _label2Color;
    secondaryLabel.text = _value2;
    
    subLabelRect.size.height = [self heightForString:_value2 withWidth:[self subLabelContentRect].size.width withFont:secondaryLabel.font];    
    secondaryLabel.frame = subLabelRect;
    
    
    [cell setSelectionStyle:_cellSelectionStyle];
    
    return cell;
}

- (CGFloat)heightForString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 485.0) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = size.height + 5;
    return height;
}

- (CGFloat)heightForRow {
    CGFloat mainLabelHeight = [self heightForString:value withWidth:[self groupedInnerContentRect].size.width withFont:_label1Font];
    CGFloat secondaryLabelHeight = [self heightForString:_value2 withWidth:[self groupedInnerContentRect].size.width withFont:_label2Font];
    return mainLabelHeight + secondaryLabelHeight;
}

- (CGRect)groupedInnerContentRect {
    return CGRectMake(10.0, 0.0, 280.0, 40.0);
}

- (CGRect)subLabelContentRect {
    return CGRectMake(10.0, 38.0, 280.0, 15.0);
}

- (void)dealloc {
    [_label1Color release];
    [_label1Font release];
    [_label2Color release];
    [_label2Font release];
    [super dealloc];
}

@end
