//
//  TwoTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-12-12.
//
//

#import "TableViewRow.h"

@interface TwoTableViewRow : TableViewRow {
    NSString *_value2;
}

@property NSTextAlignment textAlignment;
@property (nonatomic, retain) UIFont *label1Font;
@property (nonatomic, retain) UIColor *label1Color;
@property (nonatomic, retain) UIFont *label2Font;
@property (nonatomic, retain) UIColor *label2Color;
@property UITableViewCellSelectionStyle cellSelectionStyle;

- (id)initWithValue:(NSString *)val andValueTwo:(NSString *)val2 andMethod:(SEL)method;

@end
