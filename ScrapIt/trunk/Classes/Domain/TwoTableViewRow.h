//
//  TwoTableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-12-12.
//
//

#import "TableViewRow.h"

@interface TwoTableViewRow : TableViewRow {
    UIFont *_mainLabelDefaultFont;
    UITextAlignment _alignment;
    NSString *_value2;
}

@property UITextAlignment textAlignment;
@property (nonatomic, retain) UILabel *mainLabel;
@property (nonatomic, retain) UILabel *secondaryLabel;

- (id)initWithValue:(NSString *)val andValueTwo:(NSString *)val2 andMethod:(SEL)method;

@end
