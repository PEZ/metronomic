/*
     File: MasterViewController.m
 Abstract: 
Controls the table and navigation between master and detail views.  

  Version: 1.9
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008 Apple Inc. All Rights Reserved.
 
 */

#import "MasterViewController.h"
// Need to import the AppDelegate because it owns the books array and we want access to that property.
#import "MetronomicAppDelegate.h"
#import "DetailViewController.h"
#import "EditingViewController.h"
#import "AddViewController.h"
#import "Book.h"

// Manage the editing view controller from this class so it can be easily accessed from both the detail and add controllers.
static EditingViewController *__editingViewController = nil;

// Private interface for MasterViewController - internal only methods.
@interface MasterViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UINavigationController *addNavigationController;
@property (nonatomic, retain) DetailViewController *detailViewController;
@property (nonatomic, retain) AddViewController *addViewController;

@end

@implementation MasterViewController

@synthesize tableView, addNavigationController, detailViewController, addViewController;

+ (EditingViewController *)editingViewController {
    // Instantiate the editing view controller if necessary.
    if (__editingViewController == nil) {
        __editingViewController = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
    }
    return __editingViewController;
}

- (void)dealloc {
    // Release allocated resources.
    [tableView release];
    [addNavigationController release];
    [super dealloc];
}

// Set up the user interface.
- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

// Update the table before the view displays.
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

// Invoked when the user touches Edit.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    // Disable the add button while editing.
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (IBAction)addBook:(id)sender {
    AddViewController *controller = self.addViewController;
    controller.book = [[[Book alloc] init] autorelease];
    if (addNavigationController == nil) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.addNavigationController = navController;
        [navController release];
    }
    [self.navigationController presentModalViewController:addNavigationController animated:YES];
    [controller setEditing:YES animated:NO];
}

- (DetailViewController *)detailViewController {
    // Instantiate the detail view controller if necessary.
    if (detailViewController == nil) {
        detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    }
    return detailViewController;
}

- (AddViewController *)addViewController {
    // Instantiate the add view controller if necessary.
    if (addViewController == nil) {
        addViewController = [[AddViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    }
    return addViewController;
}

#pragma mark Table Delegate and Data Source Methods
// These methods are all part of either the UITableViewDelegate or UITableViewDataSource protocols.

// This table will always only have one section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}

// One row per book, the number of books is the number of rows.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    MetronomicAppDelegate *appDelegate = (MetronomicAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.books.count;
}

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        // Create a new cell. CGRectZero allows the cell to determine the appropriate size.
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MyIdentifier"] autorelease];
    }
    // Retrieve the book object matching the row from the application delegate's array.
    MetronomicAppDelegate *appDelegate = (MetronomicAppDelegate *)[[UIApplication sharedApplication] delegate];
    Book *book = (Book *)[appDelegate.books objectAtIndex:indexPath.row];
    cell.text = book.title;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Inspect the book (method defined above).
    MetronomicAppDelegate *appDelegate = (MetronomicAppDelegate *)[[UIApplication sharedApplication] delegate];
    Book *book = [appDelegate.books objectAtIndex:indexPath.row];
    DetailViewController *controller = self.detailViewController;
    // Retrieve the other attributes of the book from the database (if needed).
    [book hydrate];
    // Set the detail controller's inspected item to the currently-selected book.
    controller.book = book;
    // "Push" the detail view on to the navigation controller's stack.
    [self.navigationController pushViewController:controller animated:YES];
    [controller setEditing:NO animated:NO];
    return nil;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
                forRowAtIndexPath:(NSIndexPath *)indexPath {
    MetronomicAppDelegate *appDelegate = (MetronomicAppDelegate *)[[UIApplication sharedApplication] delegate];
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Find the book at the deleted row, and remove from application delegate's array.
        Book *book = [appDelegate.books objectAtIndex:indexPath.row];
        [appDelegate removeBook:book];
        // Animate the deletion from the table.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

