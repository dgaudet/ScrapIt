//
//  CreditsTableViewController.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-11-20.
//
//

#import "CreditsTableViewController.h"
#import "TableViewRow.h"
#import "MultilineTableViewRow.h"
#import "TwoTableViewRow.h"
#import "DeviceService.h"

NSString *const Section_Key = @"section";
NSString *const Row_Key = @"Row";

@interface CreditsTableViewController (PrivateMethods)

- (NSArray *)setupTableData;
- (void)doneButtonTapped:(id)sender;
- (void)paperArtworkRowTapped:(id)sender;

@end

@implementation CreditsTableViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Credits and Info";
        _tableData = [[NSArray alloc] initWithArray:[self setupTableData]];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        [doneButton release];
        _urlSelected = nil;
    }
    return self;
}

- (NSArray *)setupTableData {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *versionText = [DeviceService getApplicationVersion];
    MultilineTableViewRow *multilineRow1 = [[MultilineTableViewRow alloc] initWithValue:versionText andMethod:nil];
    [multilineRow1 setTextAlignment:UITextAlignmentCenter];
    NSDictionary *section1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:multilineRow1], Row_Key, @"App Version", Section_Key, nil];
    [multilineRow1 release];
    [array addObject:section1];

    NSString *dedicationText = @"I would like to thank my family for giving me the time, and idea for this project. Without their support none of this would be possible.";
    MultilineTableViewRow *multilineRow21 = [[MultilineTableViewRow alloc] initWithValue:dedicationText andMethod:nil];
    MultilineTableViewRow *multilineRow22 = [[MultilineTableViewRow alloc] initWithValue:@"test2" andMethod:nil];
    NSArray *rows2 = [NSArray arrayWithObjects:multilineRow21, multilineRow22, nil];
    [multilineRow21 release];
    [multilineRow22 release];
    NSDictionary *section2 = [NSDictionary dictionaryWithObjectsAndKeys:rows2, Row_Key, @"For my family", Section_Key, nil];
    [array addObject:section2];
        
    NSString *legalText = kYellowPagesLegalText;
    TwoTableViewRow *row31 = [[TwoTableViewRow alloc] initWithValue:@"Thanks to Yellow Pages for their great api" andValueTwo:legalText andMethod:nil];
    [row31 setTextAlignment:UITextAlignmentCenter];
    [row31.mainLabel setTextColor:[UIColor whiteColor]];
    [row31.secondaryLabel setTextColor:[UIColor blackColor]];
    NSDictionary *section3 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:row31], Row_Key, @"Yellow Pages legal", Section_Key, nil];
    [row31 release];
    [array addObject:section3];
    
    TwoTableViewRow *row41 = [[TwoTableViewRow alloc] initWithValue:@"Thanks to nevermoregraphix for the paper background for our app" andValueTwo:@"- View nevermoregraphix artwork -" andMethod:@selector(paperArtworkRowTapped:)];
    [row41 setTextAlignment:UITextAlignmentCenter];
    [row41.mainLabel setTextColor:[UIColor whiteColor]];
    [row41.secondaryLabel setTextColor:[UIColor blackColor]];
    [row41.secondaryLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    NSArray *rows4 = [NSArray arrayWithObject:row41];
    [row41 release];
    NSDictionary *section4 = [NSDictionary dictionaryWithObjectsAndKeys:rows4, Row_Key, @"Artwork", Section_Key, nil];
    [array addObject:section4];
    
    return array;
}

- (void)doneButtonTapped:(id)sender {
    if ([delegate respondsToSelector:@selector(creditsTableViewControllerFinished:)]) {
        [delegate creditsTableViewControllerFinished:self];
    }
}

- (void)paperArtworkRowTapped:(id)sender {
    NSURL *artworkUrl = [NSURL URLWithString:@"http://nevermoregraphix.deviantart.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:artworkUrl]) {
        _urlSelected = [artworkUrl copy];
        [self loadAlertViewWithMessage:@"Leave scrap it and view artwork from nevermoregraphix?" andOkButtonTile:@"Leave"];
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
        if ([[UIApplication sharedApplication] canOpenURL:_urlSelected]) {
            [[UIApplication sharedApplication] openURL:_urlSelected];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_tableData objectAtIndex:section] objectForKey:Row_Key] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int linePadding = 30;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(linePadding, 33, self.view.bounds.size.width - linePadding * 2, 2)];
    lineView.backgroundColor = [UIColor lightGrayColor];
        
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    [header setBackgroundColor:[UIColor clearColor]];
    [header addSubview:lineView];
    [lineView release];
    return [header autorelease];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[_tableData objectAtIndex:section] objectForKey:Section_Key];
}

- (TableViewRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = [_tableData objectAtIndex:indexPath.section];
    NSArray *row = [section objectForKey:Row_Key];
    TableViewRow *tableViewRow = [row objectAtIndex:indexPath.row];
    return tableViewRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewRow *row = [self rowForIndexPath:indexPath];
    return [row heightForRow];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewRow *row = [self rowForIndexPath:indexPath];
    UITableViewCell *cell = [row cellInTableView:tableView];
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [testView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:testView];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL selector = [(TableViewRow *)[self rowForIndexPath:indexPath] selector];
    if (selector) {
        [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)dealloc {
    [_tableData release];
    [super dealloc];
}

@end
