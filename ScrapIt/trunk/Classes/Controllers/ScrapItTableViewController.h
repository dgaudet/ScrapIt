//
//  ScrapItTableViewController.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SelectionListTableViewController.h"
#import "LocationHelper.h"
#import "CreditsTableViewController.h"
@class UILoadingAlertView;
@class CreditsView;
@class UserService;

@interface ScrapItTableViewController : UITableViewController <UITextFieldDelegate, LocationHelperDelegate, SelectionListTableViewControllerDelegate, CreditsTableViewControllerDelegate> {
    NSArray *tableData;
    NSIndexPath *cityRowIndexPath;
    NSIndexPath *provRowIndexPath;
    NSIndexPath *searchButtonIndexPath;
    NSIndexPath *locationButtonIndexPath;
    UILoadingAlertView *loadingAlert;
    BOOL loadingData;
    LocationHelper *locationHelper;
    BOOL currentLocationClicked;
    UserService *_userService;
}

- (void)selectionListTableViewControllerDidCancelController:(SelectionListTableViewController *)controller;
- (void)selectionListTableViewController:(SelectionListTableViewController *)controller didSelectItem:(NSString *)selectedItem;

- (void)locationHelper:(LocationHelper *)locationHelper didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationHelper:(LocationHelper *)locationHelper didFailWithError:(NSError *)error;

- (void)creditsTableViewControllerFinished:(CreditsTableViewController *)controller;

@end
