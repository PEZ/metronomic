/*
     File: DetailViewController.m
 Abstract: 
 Main view controller for the app. Displays a grouped table view and manages edits to the table, including
 add, delete, reorder, and navigation to edit the contents of individual items.
 
  Version: 1.1
 
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

#import "DetailViewController.h"
#import "DetailCell.h"
#import "EditingViewController.h"

@implementation DetailViewController

@synthesize data, tableView, editingViewController;

- (void)dealloc {
    tableView.delegate = nil;
    tableView.dataSource = nil;
    [tableView release];
    [data release];
    [editingViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    // Add the built-in edit button item to the navigation bar. This item automatically toggles between
    // "Edit" and "Done" and updates the view controller's state accordingly.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (EditingViewController *)editingViewController {
    // Instantiate the editing view controller if necessary.
    if (editingViewController == nil) {
        EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
        self.editingViewController = controller;
        [controller release];
    }
    return editingViewController;
}

#pragma mark Table Content and Appearance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // The number of sections is based on the number of items in the data property list.
    return [data count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // The number of rows in each section depends on the number of sub-items in each item in the data property list. 
    NSInteger count = [[[data objectAtIndex:section] valueForKeyPath:@"content.@count"] intValue];
    // If we're in editing mode, we add a placeholder row for creating new items.
    if (self.editing) count++;
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    if (cell == nil) {
        cell = [[[DetailCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DetailCell"] autorelease];
        cell.hidesAccessoryWhenEditing = NO;
    }
    // The DetailCell has two modes of display - either a type/name pair or a prompt for creating a new item of a type
    // The type derives from the section, the name from the item.
    NSDictionary *section = [data objectAtIndex:indexPath.section];
    if (section) {
        NSArray *content = [section valueForKey:@"content"];
        if (content && indexPath.row < [content count]) {
            NSDictionary *item = (NSDictionary *)[content objectAtIndex:indexPath.row];
            cell.type.text = [item valueForKey:@"Type"];
            cell.name.text = [item valueForKey:@"Name"];
            cell.promptMode = NO;
        } else {
            cell.prompt.text = [NSString stringWithFormat:@"Add new %@", [section valueForKey:@"name"]];
            cell.promptMode = YES;
        }
    } else {
        cell.type.text = @"";
        cell.name.text = @"";
    }
    return cell;
}

// The accessory view is on the right side of each cell. We'll use a "disclosure" indicator in editing mode,
// to indicate to the user that selecting the row will navigate to a new view where details can be edited.
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.
    NSDictionary *section = [data objectAtIndex:indexPath.section];
    if (section) {
        NSArray *content = [section valueForKey:@"content"];
        if (content) {
            if (indexPath.row >= [content count]) {
                return UITableViewCellEditingStyleInsert;
            } else {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark Table Selection 

// Called after selection. In editing mode, this will navigate to a new view controller.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        // Don't maintain the selection. We will navigate to a new view so there's no reason to keep the selection here.
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // Go to edit view
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the editing view controller.
            EditingViewController *controller = self.editingViewController;
            // Pass the item being edited to the editing controller.
            NSMutableArray *content = [section valueForKey:@"content"];
            if (content && indexPath.row < [content count]) {
                // The row selected is one with existing content, so that content will be edited.
                NSMutableDictionary *item = (NSMutableDictionary *)[content objectAtIndex:indexPath.row];
                controller.editingItem = item;
            } else {
                // The row selected is a placeholder for adding content. The editor should create a new item.
                controller.editingItem = nil;
                controller.editingContent = content;
            }
            // Additional information for the editing controller.
            controller.sectionName = [section valueForKey:@"name"];
            controller.editingTypes = [section valueForKey:@"types"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        // This will give the user visual feedback that the cell was selected but fade out to indicate that no
        // action is taken.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark Editing

// Set the editing state of the view controller. We pass this down to the table view and also modify the content
// of the table to insert a placeholder row for adding content when in editing mode.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Calculate the index paths for all of the placeholder rows based on the number of items in each section.
    NSArray *indexPaths = [NSArray arrayWithObjects:
            [NSIndexPath indexPathForRow:[[[data objectAtIndex:0] valueForKeyPath:@"content.@count"] intValue] inSection:0],
            [NSIndexPath indexPathForRow:[[[data objectAtIndex:1] valueForKeyPath:@"content.@count"] intValue] inSection:1],
            [NSIndexPath indexPathForRow:[[[data objectAtIndex:2] valueForKeyPath:@"content.@count"] intValue] inSection:2], nil];
    [tableView beginUpdates];
    [tableView setEditing:editing animated:YES];
    if (editing) {
        // Show the placeholder rows
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        // Hide the placeholder rows.
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    [tableView endUpdates];
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            NSMutableArray *content = [section valueForKey:@"content"];
            if (content && indexPath.row < [content count]) {
                [content removeObjectAtIndex:indexPath.row];
            }
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the editing view controller.
            EditingViewController *controller = self.editingViewController;
            NSMutableArray *content = [section valueForKey:@"content"];
            // A "nil" editingItem indicates the editor should create a new item.
            controller.editingItem = nil;
            // The group to which the new item should be added.
            controller.editingContent = content;
            controller.sectionName = [section valueForKey:@"name"];
            controller.editingTypes = [section valueForKey:@"types"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark Row reordering

// Determine whether a given row is eligible for reordering or not. In this app, all rows except the placeholders for
// new content are eligible, so the test is just the index path row against the number of items in the content.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // get the size of the content array
    NSUInteger numberOfRowsInSection = [[[data objectAtIndex:indexPath.section] valueForKeyPath:@"content.@count"] intValue];
    // Don't allow the placeholder to be moved.
    return (indexPath.row < numberOfRowsInSection);
}

// This allows the delegate to retarget the move destination to an index path of its choice. In this app, we don't want
// the user to be able to move items from one group to another, or to the last row of its group (the last row is
// reserved for the add-item placeholder).
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
        toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSDictionary *section = [data objectAtIndex:sourceIndexPath.section];
    NSUInteger sectionCount = [[section valueForKey:@"content"] count];
    // Check to see if the source and destination sections match. If not, retarget to either the top of the source
    // section (if the destination is above the source) or the bottom of the source section if not.
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSUInteger rowInSourceSection = (sourceIndexPath.section > proposedDestinationIndexPath.section) ? 0 : 
                sectionCount - 1;
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
    // Check for moving to the placeholder row. If so, retarget to just above that row.
    } else if (proposedDestinationIndexPath.row >= sectionCount) {
        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
    }
    // Allow the proposed destination.
    return proposedDestinationIndexPath;
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
            toIndexPath:(NSIndexPath *)toIndexPath {
    NSDictionary *section = [data objectAtIndex:fromIndexPath.section];
    if (section && fromIndexPath.section == toIndexPath.section) {
        NSMutableArray *content = [section valueForKey:@"content"];
        if (content && toIndexPath.row < [content count]) {
            id item = [[content objectAtIndex:fromIndexPath.row] retain];
            [content removeObject:item];
            [content insertObject:item atIndex:toIndexPath.row];
            [item release];
        }
    }
}

@end
