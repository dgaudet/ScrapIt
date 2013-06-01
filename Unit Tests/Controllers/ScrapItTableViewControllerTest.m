//
//  ScrapItTableViewControllerTest.m
//  ScrapIt
//
//  Created by Dean on 2013-05-31.
//
//
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import "ScrapItTableViewControllerTest.h"
//#import "ScrapItTableViewController.h"
#import "MapViewController.h"

//@interface ScrapItTableViewController (PrivateMethods)
//
//- (void)setupLocationManager;
//
//@end

@implementation ScrapItTableViewControllerTest

- (void)setUp {
//    _controller = [[ScrapItTableViewController  alloc] initWithStyle:UITableViewStyleGrouped];
    _controller = [[MapViewController alloc] init];
    [_controller view];
}

- (void)tearDown {
//    [_controller release];
}

- (void)testSetupLocationManager_ShouldInitializeLocationHelper {
    
}

@end
