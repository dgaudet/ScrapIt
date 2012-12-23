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

@property UITextAlignment textAlignment;
@property (nonatomic, retain) UILabel *mainLabel;
@property (nonatomic, retain) UILabel *secondaryLabel;
@property UITableViewCellSelectionStyle cellSelectionStyle;

- (id)initWithValue:(NSString *)val andValueTwo:(NSString *)val2 andMethod:(SEL)method;

@end
