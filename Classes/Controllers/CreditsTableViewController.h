//
//  CreditsTableViewController.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-11-20.
//
//

#import <UIKit/UIKit.h>

@protocol CreditsTableViewControllerDelegate;

@interface CreditsTableViewController : UITableViewController {
    NSArray *_tableData;
    id<CreditsTableViewControllerDelegate> delegate;
    NSURL *_urlSelected;
}

@property (assign) id<CreditsTableViewControllerDelegate> delegate;

@end

@protocol CreditsTableViewControllerDelegate <NSObject>

- (void)creditsTableViewControllerFinished:(CreditsTableViewController *)controller;

@end