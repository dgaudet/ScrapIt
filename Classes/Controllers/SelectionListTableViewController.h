//
//  SelectionListTableViewController.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionListTableViewControllerDelegate;

@interface SelectionListTableViewController : UITableViewController  {
    NSArray *tableData;
    NSIndexPath *currentSelectedRow;
    NSString *initialCheckedItem;
    NSString *currentSelectedItem;
    id<SelectionListTableViewControllerDelegate> delegate;
}

@property (assign)id<SelectionListTableViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *initialCheckedItem;

@end

@protocol SelectionListTableViewControllerDelegate <NSObject>

- (void)selectionListTableViewControllerDidCancelController:(SelectionListTableViewController *)controller;
- (void)selectionListTableViewController:(SelectionListTableViewController *)controller didSelectItem:(NSString *)selectedItem;

@end
