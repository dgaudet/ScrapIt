//
//  SelectionListTableViewController.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-08-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectionListTableViewController.h"
#import "ProvinceService.h"

@interface SelectionListTableViewController (PrivateMethods)
- (void)donePressed;
- (void)cancelPressed;
@end

@implementation SelectionListTableViewController

@synthesize delegate, initialCheckedItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Select a Province";
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    tableData = [[NSArray alloc] initWithArray:[[[[ProvinceService sharedInstance] retrieveAllProvinces] allObjects] sortedArrayUsingSelector:@selector(compare:)]];
    currentSelectedRow = [[NSIndexPath indexPathForRow:0 inSection:0] retain];
    return self;
}

- (void)donePressed {
    if([self.delegate respondsToSelector:@selector(selectionListTableViewController:didSelectItem:)]){
		[self.delegate selectionListTableViewController:self didSelectItem:currentSelectedItem];
	}
}

- (void)cancelPressed {
    if ([delegate respondsToSelector:@selector(selectionListTableViewControllerDidCancelController:)]) {
        [delegate selectionListTableViewControllerDidCancelController:self];
    }
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
    currentSelectedItem = initialCheckedItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellText = [[tableData objectAtIndex:indexPath.row] name];
    if ([currentSelectedItem isEqualToString:cellText]) {
        currentSelectedRow = [indexPath retain];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.textLabel.text = cellText;
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    UITableViewCell *previouslyCheckedCell = [self.tableView cellForRowAtIndexPath:currentSelectedRow];
    [previouslyCheckedCell setAccessoryType:UITableViewCellAccessoryNone];
    currentSelectedRow = [indexPath retain];
    currentSelectedItem = [[tableData objectAtIndex:indexPath.row] name];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
//    [tableView reloadData];
}

- (void)dealloc {
    [tableData release];
    [currentSelectedRow release];
    [super dealloc];
}

@end
