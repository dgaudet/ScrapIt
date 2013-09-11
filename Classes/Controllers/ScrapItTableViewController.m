//
//  ScrapItTableViewController.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrapItTableViewController.h"
#import "SelectionListTableViewController.h"
#import "MapViewController.h"
#import "SearchService.h"
#import "ProvinceService.h"
#import "TableViewRow.h"
#import "TextInputTableViewRow.h"
#import "MultilineTableViewRow.h"
#import "SelectionTableViewRow.h"
#import "FeedbackSelectionTableViewController.h"
#import "DeviceUtil.h"
#import "UILoadingAlertView.h"
#import "LocationHelper.h"
#import "CreditsTableViewController.h"
#import "UserService.h"
#import "User.h"
#import "ProvinceService.h"
#import "Province.h"
#import "AnalyticsService.h"
#import "DeviceUtil.h"
#import "ThemeHelper.h"

NSString * const SCRAP_IT_TABLE_VIEW_SECTION_TITLE_KEY = @"SectionTitle";
NSString * const SCRAP_IT_TABLE_VIEW_SECTION_DATA_KEY = @"SectionData";
const int SCRAP_IT_TABLE_VIEW_SECTION_BUTTON = 0;
const int SCRAP_IT_TABLE_VIEW_SECTION_TEXT_BOX = 1;
const int SCRAP_IT_TABLE_VIEW_SECTION_SELECTION = 2;
const int SCRAP_IT_TABLE_VIEW_SECTION_TWO_LABEL_SELECTION = 3;
const int SCRAP_IT_TEXT_FIELD_TAG = 1;
CGFloat const STVC_HEADER_HEIGHT = 40.0;

@interface ScrapItTableViewController (PrivateMethods)

- (NSArray *)loadTableData;
- (void)updateProvince:(NSString *)province;
- (void)findStoresforCity:(NSString *)city inProvince:(Province *)province;
- (void)findStoresforCoords:(CLLocationCoordinate2D)location;
- (void)hideKeyboard;
- (UITextField *)retrieveCellTextFieldFromIndexPath:(NSIndexPath *)indexPath;
- (NSString *)textForIndexPath:(NSIndexPath *)indexPath;
- (void)displayErrorToUser:(NSError *)error;
- (void)displayNoResultsErrorToUser;
- (void)displayLocationHelperErrorToUser;
+ (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)loadMapViewOrDisplayErrorForLocation:(CLLocationCoordinate2D)location andTitle:(NSString *)title;
- (void)loadMapViewControllerwithTitle:(NSString *)title mapCenter:(CLLocationCoordinate2D)mapCenter placemarks:(NSArray *)placemarks;
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
- (void)setButtonSelectedFalseIfNeeded;
- (void)addInfoButtonToView;

- (void)setupLocationManager;

- (void)selectedProvinceCell;
- (void)selectedLocationCell;
- (void)selectedSearchCell;
- (void)selectedCityCell;

- (void)infoButtonTapped:(id)sender;

@end

@implementation ScrapItTableViewController

//ToDo: add country selection
//ToDo: remember possibly city, when app is totally turned off
//ToDo: pass country to search service
//ToDo: when use current location search, lookup the city name by location coords, to display in the title of the map view
//ToDo: handle location updates, I think if you do a search from one location, using current location, then move to a signifcantly different location, and try to search again, it may use the original location
//ToDo: attempt to use significantLocationChangeMonitoringAvailable to decide how to setup the location manager
//ToDo: figure out why when you go to enter a city in iOS 4, the cursor is half way through the default text
//ToDo: make UIActivityIndicator more prominent, possibly by putting in into a UIAlertView
//ToDo: add the ability to get directions to store from current location
//ToDo: clean up the turning off of location search button and locationButtonClicked bool

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Find Scraps";
        _provinceService = [ProvinceService sharedInstance];
        _userService = [UserService sharedInstance];        
    }

//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonClicked:)];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
    
    _user = [[_userService retrieveUser] retain];
    tableData = [[NSArray alloc] initWithArray:[self loadTableData]];
    loadingData = FALSE;
    return self;
}

- (NSArray *)loadTableData {
    NSMutableArray *dataArray = [[[NSMutableArray alloc] init] autorelease];
    
    Province *province = _user.province;
    
    SelectionTableViewRow *provinceRow = [[SelectionTableViewRow alloc] initWithValue:province.name andLabel:@"Province" methodWhenSelected:@selector(selectedProvinceCell)];
    provRowIndexPath = [[NSIndexPath indexPathForRow:0 inSection:0] retain];
    TextInputTableViewRow *cityRow = [[TextInputTableViewRow alloc] initWithValue:@"enter city" andLabel:@"City:" andDelegate:self andMethod:@selector(selectedCityCell)];
    cityRowIndexPath = [[NSIndexPath indexPathForRow:1 inSection:0] retain];
    NSArray *section1rows = [NSArray arrayWithObjects:provinceRow, cityRow, nil];
    [provinceRow release];
    NSMutableDictionary *section1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:section1rows, SCRAP_IT_TABLE_VIEW_SECTION_DATA_KEY, @"Please Enter a location to Search:", SCRAP_IT_TABLE_VIEW_SECTION_TITLE_KEY, nil];    
    
    MultilineTableViewRow *searchRow = [[MultilineTableViewRow alloc] initWithValue:@"Search" andMethod:@selector(selectedSearchCell)];
    searchRow.textAlignment = UITextAlignmentCenter;
    NSArray *section2rows = [NSArray arrayWithObject:searchRow];
    [searchRow release];
    searchButtonIndexPath = [[NSIndexPath indexPathForRow:0 inSection:1] retain];
    NSMutableDictionary *section3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:section2rows, SCRAP_IT_TABLE_VIEW_SECTION_DATA_KEY, @"", SCRAP_IT_TABLE_VIEW_SECTION_TITLE_KEY, nil];
    
    MultilineTableViewRow *locationRow = [[MultilineTableViewRow alloc] initWithValue:@"Find Stores Near You" andMethod:@selector(selectedLocationCell)];
    locationRow.textAlignment = UITextAlignmentCenter;
    NSArray *section3row = [NSArray arrayWithObject:locationRow];
    [locationRow release];
    locationButtonIndexPath = [[NSIndexPath indexPathForRow:0 inSection:2] retain];    
    NSMutableDictionary *section4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:section3row, SCRAP_IT_TABLE_VIEW_SECTION_DATA_KEY, @"Or use your current location:", SCRAP_IT_TABLE_VIEW_SECTION_TITLE_KEY, nil];
    
    [dataArray addObject:section1];
    [dataArray addObject:section3];
    [dataArray addObject:section4];
    return dataArray;
}

- (void)rightButtonClicked:(id)sender {
    FeedbackSelectionTableViewController *feedbackController = [[FeedbackSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:feedbackController animated:YES];
    [feedbackController release];
}


- (TableViewRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    return [[[tableData objectAtIndex:indexPath.section] objectForKey:SCRAP_IT_TABLE_VIEW_SECTION_DATA_KEY] objectAtIndex:indexPath.row];
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath {
    return [(TableViewRow *)[self rowForIndexPath:indexPath] value];
}

- (void)updateProvince:(NSString *)province {
    [(TableViewRow *)[self rowForIndexPath:provRowIndexPath] setValue:province];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AnalyticsService logScreenViewWithName:@"Search For Businesses"];

    [ThemeHelper setDefaultBackgroundForTableView:self.tableView];

    [self addInfoButtonToView];
    
    //Add gesture to hide keyboard when the background is tapped
    UITapGestureRecognizer *tapBackgroundViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapBackgroundViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapBackgroundViewGesture];
    [tapBackgroundViewGesture release];
}

- (void)addInfoButtonToView {
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat x = [DeviceUtil screenSize].width - 30;
    CGFloat y = [DeviceUtil screenSize].height - 95;
    [infoButton setFrame:CGRectMake(x, y, infoButton.frame.size.width, infoButton.frame.size.height)];
    [self.view addSubview:infoButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[tableData objectAtIndex:section] objectForKey:SCRAP_IT_TABLE_VIEW_SECTION_DATA_KEY] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[tableData objectAtIndex:section] objectForKey:SCRAP_IT_TABLE_VIEW_SECTION_TITLE_KEY];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    CGFloat parentWidth = self.view.frame.size.width;
    CGFloat viewHeight = STVC_HEADER_HEIGHT;
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, parentWidth, viewHeight)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    CGFloat labelPadding = 20.0;
    CGFloat labelWidth = parentWidth - 2 * labelPadding;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, 0.0, labelWidth, viewHeight)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    label.textAlignment = UITextAlignmentLeft;
    
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    [label release];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return STVC_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewRow *row = [self rowForIndexPath:indexPath];
    return [row cellInTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewRow *row = [self rowForIndexPath:indexPath];
    return [row heightForRow];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard {
    TextInputTableViewRow *row = (TextInputTableViewRow*)[self rowForIndexPath:cityRowIndexPath];
    [row dismissKeyboard];
}

- (UITextField *)retrieveCellTextFieldFromIndexPath:(NSIndexPath *)indexPath {
    TextInputTableViewRow *row = (TextInputTableViewRow*)[self rowForIndexPath:indexPath];
    return (UITextField*)[row textField];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!loadingData) {        
        SEL selector = [(TableViewRow *)[self rowForIndexPath:indexPath] selector];
        [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
    }
}

- (void)selectedProvinceCell {
    [self hideKeyboard];
    
    SelectionListTableViewController *selectionController = [[SelectionListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    selectionController.delegate = self;
    selectionController.initialCheckedItem = [self textForIndexPath:provRowIndexPath];
    
    UINavigationController *modalNavController = [[UINavigationController alloc] initWithRootViewController:selectionController];
    [ThemeHelper setColorForNavBar:modalNavController.navigationBar];
    [selectionController release];
    [self presentModalViewController:modalNavController animated:YES];
    [modalNavController release];
}

- (void)selectedLocationCell {
    currentLocationClicked = TRUE;
    [AnalyticsService logClickedFindStoresWithLocationEvent];
    [self setupLocationManager];
}

- (void)selectedSearchCell {
    [AnalyticsService logClickedSearchEvent];
    UITextField *textField = [self retrieveCellTextFieldFromIndexPath:cityRowIndexPath];
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        Province *province = [[ProvinceService sharedInstance] retrieveProvinceWithName:[self textForIndexPath:provRowIndexPath]];
        [self findStoresforCity:textField.text inProvince:province];
    } else {
        [ScrapItTableViewController displayAlertWithTitle:nil message:@"Please enter a city"];
        [self setButtonSelectedFalseIfNeeded];
    }
}

- (void)selectedCityCell {
    [[self retrieveCellTextFieldFromIndexPath:cityRowIndexPath] becomeFirstResponder];
}

- (void)findStoresforCity:(NSString *)city inProvince:(Province *)province {
//    http://developer.apple.com/library/ios/#documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html
//    Adding tasks to a queue    
    [self showLoadingIndicators];
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create([[[NSBundle mainBundle] bundleIdentifier] UTF8String], NULL);
    
    dispatch_async(myCustomQueue, ^{        
        NSError *error = nil;
        CLLocationCoordinate2D cityCoords = [[SearchService sharedInstance] retrieveCenterCoordinatesForCity:city inProvince:province error:&error];
        if (error) {
            [self performSelectorOnMainThread:@selector(displayErrorToUser:) withObject:error waitUntilDone:NO];
        } else {
            [self loadMapViewOrDisplayErrorForLocation:cityCoords andTitle:city];
        }
    });
}

- (void)findStoresforCoords:(CLLocationCoordinate2D)location {
    //    Adding tasks to a queue    
    [self showLoadingIndicators];
    dispatch_queue_t myCustomQueue;    
    myCustomQueue = dispatch_queue_create([[[NSBundle mainBundle] bundleIdentifier] UTF8String], NULL);    
    dispatch_async(myCustomQueue, ^{        
        [self loadMapViewOrDisplayErrorForLocation:location andTitle:@"Mapped Stores"];
    });
}

- (void)loadMapViewOrDisplayErrorForLocation:(CLLocationCoordinate2D)location andTitle:(NSString *)title {
    NSError *error = nil;
    NSArray *placemarks = [[SearchService sharedInstance] retrievePlacemarksForCoordinates:location error:&error];
    if (error) {
        [self performSelectorOnMainThread:@selector(displayErrorToUser:) withObject:error waitUntilDone:NO];
    } else {
        if ([placemarks count] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadMapViewControllerwithTitle:title mapCenter:location placemarks:placemarks];
            });
        } else {
            [self performSelectorOnMainThread:@selector(displayNoResultsErrorToUser) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)loadMapViewControllerwithTitle:(NSString *)title mapCenter:(CLLocationCoordinate2D)mapCenter placemarks:(NSArray *)placemarks {
    [self hideLoadingIndicators];
    MapViewController *mapController = [[MapViewController alloc] init];
    mapController.title = [title capitalizedString];
    mapController.mapCenter = mapCenter;
    mapController.placemarksForCity = placemarks;
    [self.navigationController pushViewController:mapController animated:YES];
    [mapController release];
}

- (void)displayErrorToUser:(NSError *)error {
    [self hideLoadingIndicators];
    [self setButtonSelectedFalseIfNeeded];
    NSDictionary *errorInfo = [error userInfo];
    NSString *message = @"There was a problem completing your search.\nPlease try again.";
    if (errorInfo) {
        if ([errorInfo objectForKey:NSLocalizedDescriptionKey]) {
            message = [errorInfo objectForKey:NSLocalizedDescriptionKey];
        }
    }
    [ScrapItTableViewController displayAlertWithTitle:nil message:[errorInfo objectForKey:NSLocalizedDescriptionKey]];
}

- (void)displayNoResultsErrorToUser {
    [self hideLoadingIndicators];
    [self setButtonSelectedFalseIfNeeded];
    [ScrapItTableViewController displayAlertWithTitle:nil message:@"There were no results found\nPlease search again."];
}

- (void)displayLocationHelperErrorToUser {
    [self hideLoadingIndicators];
    [self setButtonSelectedFalseIfNeeded];
    [ScrapItTableViewController displayAlertWithTitle:nil message:@"There was an error while determining your location\nPlease search again."];
}

+ (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)setButtonSelectedFalseIfNeeded {
    UITableViewCell *searchButton = [self.tableView cellForRowAtIndexPath:searchButtonIndexPath];
    if(searchButton.selected){
        [searchButton setSelected:NO animated:YES];
    }
    UITableViewCell *locationButton = [self.tableView cellForRowAtIndexPath:locationButtonIndexPath];
    if(locationButton.selected){
        [locationButton setSelected:NO animated:YES];
    }
}

- (void)selectionListTableViewControllerDidCancelController:(SelectionListTableViewController *)controller {
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)selectionListTableViewController:(SelectionListTableViewController *)controller didSelectItem:(NSString *)selectedItem {
    Province *province  = [_provinceService retrieveProvinceWithName:selectedItem];
    [_user setProvince:province];
    [_userService saveUser:_user];
    
    [self updateProvince:selectedItem];
    [self.tableView reloadData];
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - Loading Progress UI

- (void)showLoadingIndicators {
    if (!loadingAlert) {
        loadingData = TRUE;
        loadingAlert = [[UILoadingAlertView alloc] initWithTitle:@"Loading Stores ..."];
        [loadingAlert show];
    }
}

- (void)hideLoadingIndicators {
    loadingData = FALSE;
    if (loadingAlert) {
        [loadingAlert dismiss];
        loadingAlert = nil;
    }
}

#pragma mark - User Location Methods
#pragma mark - Location Manager Region
- (void)setupLocationManager {    
    if (!locationHelper) {
        locationHelper = [[LocationHelper alloc] init];
        locationHelper.delegate = self;
    }
    CLLocation *currentLocation = [locationHelper findCurrentLocation];
    NSLog(@"SETUP - Current location? %@", currentLocation);
    if (currentLocation) {                
        [self findStoresforCoords:currentLocation.coordinate];
        currentLocationClicked = false;
    }

}

- (void)locationHelper:(LocationHelper *)locationHelper didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"DID_UPDATE_TO_LOCATION - new location: %@, old location: %@", newLocation, oldLocation);
    CLLocationCoordinate2D coords = newLocation.coordinate;
    if(oldLocation == nil || [newLocation distanceFromLocation:oldLocation] > 10){
        if(currentLocationClicked){
            [self findStoresforCoords:coords];
        }
    }
    currentLocationClicked = false;
}

- (void)locationHelper:(LocationHelper *)locationHelper didFailWithError:(NSError *)error {
    NSLog(@"Failed called in ScrapItTableViewController");
    if ([error code] == kCLErrorDenied) {
        [self hideLoadingIndicators];
        [self setButtonSelectedFalseIfNeeded];
        currentLocationClicked = false;
    } else {
        [self displayLocationHelperErrorToUser];
    }
    NSLog(@"Manager failed %@", [error localizedDescription]);   
}

- (void)infoButtonTapped:(id)sender {
    CreditsTableViewController *creditsController = [[CreditsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [creditsController setDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:creditsController];
    [creditsController release];
    
    [ThemeHelper setColorForNavBar:navigationController.navigationBar];
    [self.navigationController presentModalViewController:navigationController animated:YES];
}

- (void)creditsTableViewControllerFinished:(CreditsTableViewController *)controller {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    if (loadingAlert) {
        [loadingAlert release];
    }
    [tableData release];
    [cityRowIndexPath release];
    [provRowIndexPath release];
    [searchButtonIndexPath release];
    [locationButtonIndexPath release];
    if(locationHelper) {
        [locationHelper release];
    }
    [_user release];
    [super dealloc];
}

@end
