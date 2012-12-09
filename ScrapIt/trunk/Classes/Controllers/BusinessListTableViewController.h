//
//  BusinessListTableViewController.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Business;

@interface BusinessListTableViewController : UITableViewController {
	Business *business;
	NSArray *tableData;
    NSIndexPath *phoneIndex;
    NSIndexPath *urlIndex;
    NSIndexPath *locationIndex;
    NSIndexPath *lastSelectedIndex;
}

@property (nonatomic, retain) Business *business;

@end
