//
//  BusinessListTableViewController.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-06-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusinessListTableViewController.h"
#import "MultilineTableViewRow.h"
#import "MultilineTwoRowTableViewRow.h"
#import "SearchService.h"
#import "Business.h"
#import "BusinessSummary.h"
#import "EncodingUtil.h"
#import "YellowPagesFooterView.h"
#import "AnalyticsService.h"
#import "ThemeHelper.h"
#import "MapsHelper.h"

NSString * const SECTION_NAME_KEY = @"sectionName";
NSString * const SECTION_DATA_KEY = @"data";
CGFloat const headerHeight = 40.0;
CGFloat const labelPadding = 20.0;

@interface BusinessListTableViewController (PrivateMethods)

- (NSArray *)setupTableData:(Business *)bus;
- (TableViewRow *)rowForIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView muiltilineCellWithText:(NSString *)text;
- (UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCellWithText:(NSString *)text;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)loadAlertViewWithMessage:(NSString *)message andOkButtonTile:(NSString *)okTitle;
- (NSURL *)phoneUrl;
- (NSURL *)storeUrl;
- (void)phoneCellClicked;
- (void)addressCellClicked;
- (void)urlCellClicked;
- (void)addYellowPagesFooterToView:(UIView *)view;

@end


@implementation BusinessListTableViewController

//ToDo: Add ability to copy the information in each row
//ToDo: Change the color/font of the section titles to make them look nicer
//ToDo: Change the size of the city row to match the size of the text, for example, regina returned a store with no street address, in that case we only need one line of text not two, the size of the cell should match
//ToDo: Make the view scrollable again, by making the table view a subview

@synthesize business;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    headerWidth = self.view.frame.size.width;
    titleLabelWidth = headerWidth - 2 * labelPadding;
    
    [AnalyticsService logScreenViewWithName:@"Business Detail"];
	[ThemeHelper setDefaultBackgroundForTableView:self.tableView];
    self.title = @"Store Details";
    tableData = [[NSArray alloc] initWithArray:[self setupTableData:business]];
    lastSelectedIndex = [[NSIndexPath indexPathForRow:0 inSection:0] retain];
    [self.tableView setScrollEnabled:NO];
}

- (void)addYellowPagesFooterToView:(UIView *)view {
    YellowPagesFooterView *footer = [[YellowPagesFooterView alloc] init];
    [footer displayInUITableViewController:self animated:YES];
    [footer release];
}

- (NSArray *)setupTableData:(Business *)bus {
    BusinessSummary *businessSummary = bus.businessSummary;
    
    NSMutableArray *data = [[NSMutableArray alloc] init];

    NSDictionary *section0 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray array], SECTION_DATA_KEY, businessSummary.name, SECTION_NAME_KEY, nil];
    NSString *phoneSectionTitle = @"Phone";
    
    NSString *callString = nil;
    UITableViewCellSelectionStyle phoneSelectionStyle = UITableViewCellSelectionStyleNone;
    if ([[UIApplication sharedApplication] canOpenURL:[self phoneUrl]]) {
        callString = @"- Call -";
        phoneSelectionStyle = UITableViewCellSelectionStyleBlue;
    }
    MultilineTwoRowTableViewRow *phoneRow = [[MultilineTwoRowTableViewRow alloc] initWithValue:bus.phoneNumber andValueTwo:callString andMethod:@selector(phoneCellClicked)];
    [phoneRow setCellSelectionStyle:phoneSelectionStyle];
    [data addObject:section0];
    
    NSDictionary *section1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:phoneRow, nil], SECTION_DATA_KEY, phoneSectionTitle, SECTION_NAME_KEY, nil];
    [data addObject:section1];
    
    NSString *address = [NSString stringWithFormat:@"%@\n%@, %@, %@", businessSummary.street, businessSummary.city, businessSummary.province, businessSummary.country];
    MultilineTwoRowTableViewRow *cityRow = [[MultilineTwoRowTableViewRow alloc] initWithValue:address andValueTwo:@"- View in Maps -" andMethod:@selector(addressCellClicked)];
    NSDictionary *section2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:cityRow], SECTION_DATA_KEY, @"Address", SECTION_NAME_KEY, nil];
    [data addObject:section2];
    
    if (bus.url) {
        MultilineTwoRowTableViewRow *urlRow = [[MultilineTwoRowTableViewRow alloc] initWithValue:bus.url andValueTwo:@"- View in Safari -" andMethod:@selector(urlCellClicked)];
        NSDictionary *section3 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:urlRow], SECTION_DATA_KEY, @"Website", SECTION_NAME_KEY, nil];
        [data addObject:section3];
    }
    
    phoneIndex = [[NSIndexPath indexPathForRow:0 inSection:1] retain];
    locationIndex = [[NSIndexPath indexPathForRow:0 inSection:2] retain];
    urlIndex = [[NSIndexPath indexPathForRow:0 inSection:3] retain];
    
    return [data autorelease];
}

- (TableViewRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    return [[[tableData objectAtIndex:indexPath.section] objectForKey:SECTION_DATA_KEY] objectAtIndex:indexPath.row];
}

//http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007891-SW1
- (NSURL *)phoneUrl {
    NSString *phoneText = business.phoneNumber;
    phoneText = [phoneText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneText]];
}

- (NSURL *)storeUrl {
    NSString *urlText = business.url;
    urlText = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:urlText];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addYellowPagesFooterToView:self.view];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[tableData objectAtIndex:section] objectForKey:SECTION_DATA_KEY] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[tableData objectAtIndex:section] objectForKey:SECTION_NAME_KEY];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    CGFloat viewHeight = [self tableView:self.tableView heightForHeaderInSection:section];
    CGFloat mainTitlePadding = 0;
    CGFloat labelY = 0;
    
    if (section == 0) {
        mainTitlePadding = 10;
        labelY = mainTitlePadding/2+3;
    }
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, headerWidth, viewHeight + mainTitlePadding)] autorelease];
    view.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, labelY, titleLabelWidth, viewHeight)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor whiteColor];
    label.font = [ThemeHelper tableViewTitleFont];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 999;
    label.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        label.textAlignment = NSTextAlignmentCenter;
    } else {
        label.textAlignment = NSTextAlignmentLeft;
    }
    
    [view addSubview:label];
    [label release];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *titleText = [self tableView:self.tableView titleForHeaderInSection:section];
    CGSize size = [titleText sizeWithFont:[ThemeHelper tableViewTitleFont] constrainedToSize:CGSizeMake(titleLabelWidth, 485.0) lineBreakMode:NSLineBreakByWordWrapping];

    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewRow *row = [self rowForIndexPath:indexPath];
    return [row heightForRow];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewRow *row = [self rowForIndexPath:indexPath];
    return [row cellInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCellWithText:(NSString *)text {
    
    static NSString *CellIdentifier = @"Default Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = text;
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    lastSelectedIndex = [indexPath retain];
    SEL selector = [(TableViewRow *)[self rowForIndexPath:indexPath] selector];
    if (selector) {
        [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)phoneCellClicked {
    if ([[UIApplication sharedApplication] canOpenURL:[self phoneUrl]]) {
        [self loadAlertViewWithMessage:[NSString stringWithFormat:@"Call: %@?", business.phoneNumber] andOkButtonTile:@"Call"];
    }
}

- (void)addressCellClicked {
    [self loadAlertViewWithMessage:@"Leave scrap it and view this location in Maps?" andOkButtonTile:@"Leave"];
}

- (void)urlCellClicked {
    if ([[UIApplication sharedApplication] canOpenURL:[self storeUrl]]) {
        [self loadAlertViewWithMessage:@"Leave scrap it and view this web page in Safari?" andOkButtonTile:@"Leave"];
    }
}

- (void)loadAlertViewWithMessage:(NSString *)message andOkButtonTile:(NSString *)okTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:okTitle, nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([lastSelectedIndex isEqual:urlIndex]) {        
            if ([[UIApplication sharedApplication] canOpenURL:[self storeUrl]]) {
                [AnalyticsService logViewBusinessUrlInSafariWithBusinessSummary:business.businessSummary];
                [[UIApplication sharedApplication] openURL:[self storeUrl]];
            }
        } else if ([lastSelectedIndex isEqual:phoneIndex]){
            if ([[UIApplication sharedApplication] canOpenURL:[self phoneUrl]]) {
                [AnalyticsService logCallBusinessWithBusinessSummary:business.businessSummary];
                [[UIApplication sharedApplication] openURL:[self phoneUrl]];
            }
        } else {
            [MapsHelper loadMapsWithLocation:business];
        }
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[business release];
	[tableData release];
    [phoneIndex release];
    [locationIndex release];
    [urlIndex release];
    [lastSelectedIndex release];
    [super dealloc];
}


@end

