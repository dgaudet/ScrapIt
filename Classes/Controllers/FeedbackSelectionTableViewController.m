//
//  FeedbackSelectionTableViewController.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-12-21.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedbackSelectionTableViewController.h"
#import "TextInputTableViewRow.h"
#import "MultilineTextInputTableViewRow.h"
#import "AnalyticsService.h"

@interface FeedbackSelectionTableViewController (PrivateMethods)

- (void)touchedRow;
- (void)rightButtonClicked:(id)sender;
- (BOOL)isFormValid;
+ (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

@implementation FeedbackSelectionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightButtonClicked:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
        
        MultilineTextInputTableViewRow *commentsRow = [[MultilineTextInputTableViewRow alloc] initWithValue:nil andNumberOfLines:6 andDelegate:self andMethod:@selector(touchedRow)];
        TextInputTableViewRow *emailRow = [[TextInputTableViewRow alloc] initWithValue:nil andLabel:@"Email:" andDelegate:self andMethod:@selector(touchedRow)];
        tableData = [[NSArray alloc] initWithObjects:commentsRow, emailRow, nil];
        [emailRow release];
        [commentsRow release];
    }
    return self;
}

- (void)rightButtonClicked:(id)sender {
    if (self.isFormValid) {
        NSLog(@"just right");
    } else {
        [FeedbackSelectionTableViewController displayAlertWithTitle:nil message:@"Please enter a comment"];
    }
    TextInputTableViewRow *emailRow = (TextInputTableViewRow *)[tableData objectAtIndex:1];
    NSLog(@"email: %@", emailRow.value);
}

- (void)touchedRow {
    NSLog(@"Touched row called!!");
}

- (BOOL)isFormValid {
    MultilineTextInputTableViewRow *commentsRow = (MultilineTextInputTableViewRow *)[tableData objectAtIndex:0];
    NSString *trimmedValue = [commentsRow.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedValue length] < 1) {
        return NO;
    }
    return YES;
}

+ (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
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
    [AnalyticsService logScreenViewWithName:@"Feedback"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *heading;
    if (section == 0) {
        heading = @"Please tell us how you feel about our app";
        NSArray *subPoints = [NSArray arrayWithObjects:@"Good, Bad or Other??", @"What ever it is we would love to hear from you", nil];
        for (NSString *string in subPoints) {
            heading = [heading stringByAppendingFormat:@"\n%@", string];
        }
    } else {
        heading = @"Leave an email address if you would like us to contact you";
    }
    
    return heading;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[tableData objectAtIndex:indexPath.section] cellInTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[tableData objectAtIndex:indexPath.section] heightForRow];
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [tableData release];
    [super dealloc];
}

@end
