//
//  TableViewRow.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewRow : NSObject {
    NSString *value;
    SEL selector;
}

@property (nonatomic, retain) NSString *value;
@property(nonatomic, readonly)SEL selector;

- (id)initWithValue:(NSString *)val andMethod:(SEL)method;
- (UITableViewCell *)cellInTableView:(UITableView *)tableView;
- (CGFloat)heightForRow;

@end
