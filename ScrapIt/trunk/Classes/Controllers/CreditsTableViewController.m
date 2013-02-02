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
#import "EmailService.h"

NSString *const Section_Key = @"section";
NSString *const Row_Key = @"Row";

@interface CreditsTableViewController (PrivateMethods)

- (NSArray *)setupTableData;
- (void)doneButtonTapped:(id)sender;
- (void)paperArtworkRowTapped:(id)sender;
- (void)supportRowTapped:(id)sender;

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
    
    UIFont *smallTextFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    UIFont *mediumTextFont = [UIFont fontWithName:@"Helvetica" size:16.0];

    TwoTableViewRow *row0 = [[TwoTableViewRow alloc] initWithValue:@"Need help, or want to suggest an improvement?" andValueTwo:@"- Tap To Email Support - " andMethod:@selector(supportRowTapped:)];
    [row0 setTextAlignment:UITextAlignmentCenter];
    [row0 setLabel1Color:[UIColor whiteColor]];
    [row0 setLabel2Color:[UIColor blackColor]];
    [row0 setLabel2Font:smallTextFont];
    NSDictionary *section0 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:row0], Row_Key, @"Support", Section_Key, nil];
    [row0 release];
    [array addObject:section0];
    
    NSString *dedicationTitle = @"I would like to dedicate this app to my Family.";
    NSString *dedicationText = @"I would like to thank my family for giving me the time, and idea for this project. Without their support none of this would be possible.";
    TwoTableViewRow *row1 = [[TwoTableViewRow alloc] initWithValue:dedicationTitle andValueTwo:dedicationText andMethod:nil];
    [row1 setCellSelectionStyle:UITableViewCellEditingStyleNone];
    [row1 setTextAlignment:UITextAlignmentCenter];
    [row1 setLabel1Color:[UIColor whiteColor]];
    [row1 setLabel2Color:[UIColor blackColor]];
    [row1 setLabel2Font:mediumTextFont];
    NSDictionary *section1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:row1], Row_Key, @"For my family", Section_Key, nil];
    [row1 release];
    [array addObject:section1];
    
    NSString *legalText = kYellowPagesLegalText;
    TwoTableViewRow *row2 = [[TwoTableViewRow alloc] initWithValue:@"Thanks to Yellow Pages for their great api." andValueTwo:legalText andMethod:nil];
    [row2 setCellSelectionStyle:UITableViewCellEditingStyleNone];
    [row2 setTextAlignment:UITextAlignmentCenter];
    [row2 setLabel1Color:[UIColor whiteColor]];
    [row2 setLabel2Color:[UIColor blackColor]];
    [row2 setLabel2Font:mediumTextFont];
    NSDictionary *section2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:row2], Row_Key, @"Yellow Pages legal", Section_Key, nil];
    [row2 release];
    [array addObject:section2];
    
    TwoTableViewRow *row3 = [[TwoTableViewRow alloc] initWithValue:@"Thanks to nevermoregraphix for the paper background for our app." andValueTwo:@"- Tap to view nevermoregraphix artwork -" andMethod:@selector(paperArtworkRowTapped:)];
    [row3 setTextAlignment:UITextAlignmentCenter];
    [row3 setLabel1Color:[UIColor whiteColor]];
    [row3 setLabel2Color:[UIColor blackColor]];
    [row3 setLabel2Font:smallTextFont];
    NSArray *rows4 = [NSArray arrayWithObject:row3];
    [row3 release];
    NSDictionary *section3 = [NSDictionary dictionaryWithObjectsAndKeys:rows4, Row_Key, @"Artwork", Section_Key, nil];
    [array addObject:section3];
    
    NSString *versionText = [DeviceService getApplicationVersion];
    TwoTableViewRow *row4 = [[TwoTableViewRow alloc] initWithValue:@"App Version:" andValueTwo:versionText andMethod:nil];
    [row4 setCellSelectionStyle:UITableViewCellEditingStyleNone];
    [row4 setTextAlignment:UITextAlignmentCenter];
    [row4 setLabel1Color:[UIColor whiteColor]];
    [row4 setLabel2Color:[UIColor blackColor]];
    [row4 setLabel2Font:[UIFont fontWithName:@"Helvetica" size:16.0]];
    NSDictionary *section4 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:row4], Row_Key, @"App Version", Section_Key, nil];
    [row4 release];
    [array addObject:section4];
    
    return array;
}

- (void)doneButtonTapped:(id)sender {
    if ([delegate respondsToSelector:@selector(creditsTableViewControllerFinished:)]) {
        [delegate creditsTableViewControllerFinished:self];
    }
}

- (void)supportRowTapped:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setMailComposeDelegate:self];
    [EmailService setupSupportEmailForMailController:mailController];
    [mailController setToRecipients:[NSArray arrayWithObject:kSystemAppSupportEmail]];
    [self.navigationController presentModalViewController:mailController animated:YES];
    
    [mailController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultFailed:
            [self loadAlertViewWithMessage:@"There was a problem sending your email, please try again." andOkButtonTitle:nil];
            break;
        default:
            [self.navigationController dismissModalViewControllerAnimated:YES];
            break;
    }
}

- (void)paperArtworkRowTapped:(id)sender {
    NSURL *artworkUrl = [NSURL URLWithString:@"http://nevermoregraphix.deviantart.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:artworkUrl]) {
        _urlSelected = [artworkUrl copy];
        [self loadAlertViewWithMessage:@"Leave scrap it and view artwork from nevermoregraphix?" andOkButtonTitle:@"Leave"];
    }
}

- (void)loadAlertViewWithMessage:(NSString *)message andOkButtonTitle:(NSString *)okTitle {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int linePadding = 30;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(linePadding, 10, self.view.bounds.size.width - linePadding * 2, 2)];
    lineView.backgroundColor = [UIColor lightGrayColor];
        
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10.0)];
    [header setBackgroundColor:[UIColor clearColor]];
    [header addSubview:lineView];
    [lineView release];
    return [header autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
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
