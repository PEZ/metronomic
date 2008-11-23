/*
     File: EditingViewController.m
 Abstract: 
 View controller for editing the content of a specific item.
 
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

#import "EditingViewController.h"
#import "EditableCell.h"
#import "TypeListController.h"

@implementation EditingViewController

@synthesize editingItem, editingItemCopy, editingContent, editingTypes, sectionName, tableView, typeListController, headerView;

// When we set the editing item, we also make a copy in case edits are made and then canceled - then we can
// restore from the copy.
- (void)setEditingItem:(NSMutableDictionary *)anItem {
    [editingItem release];
    editingItem = [anItem retain];
    self.editingItemCopy = editingItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [editingItem release];
    [editingItemCopy release];
    [editingContent release];
    [editingTypes release];
    [sectionName release];
    [tableView release];
    [typeListController release];
    [headerView release];
    [super dealloc];
}

- (IBAction)cancel:(id)sender {
    // cancel edits, restore all values from the copy
    newItem = NO;
    [editingItem setValuesForKeysWithDictionary:editingItemCopy];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // save edits to the editing item and add new item to the content.
    [editingItem setValue:nameCell.textField.text forKey:@"Name"];
    [editingItem setValue:typeCell.text forKey:@"Type"];
    if (newItem) {
        [editingContent addObject:editingItem];
        newItem = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    // use an empty view to position the cells in the vertical center of the portion of the view not covered by 
    // the keyboard
    self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 100)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = [NSString stringWithFormat:@"Editing %@", sectionName];
    // If the editing item is nil, that indicates a new item should be created
    if (editingItem == nil) {
        self.editingItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"Name", [editingTypes objectAtIndex:0], @"Type", nil];
        // rather than immediately add the new item to the content array, set a flag. When the user saves, add the 
        // item then; if the user cancels, no action is needed.
        newItem = YES;
    }
    if (!typeCell) {
        typeCell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TypeCell"];
    }
    typeCell.text = [editingItem valueForKey:@"Type"];
    [tableView reloadData];
    if (!nameCell) {
        nameCell = [[EditableCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"NameCell"];
    }
    nameCell.textField.placeholder = sectionName;
    nameCell.textField.text = [editingItem valueForKey:@"Name"];
    // Starts editing in the name field and shows the keyboard
    [nameCell.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    // hides the keyboard
    [nameCell.textField resignFirstResponder];
}

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (!typeListController) {
            TypeListController *controller = [[TypeListController alloc] initWithNibName:@"TypeList" bundle:nil];
            self.typeListController = controller;
            [controller release];
        }
        typeListController.types = editingTypes;
        typeListController.editingItem = editingItem;
        [editingItem setValue:nameCell.textField.text forKey:@"Name"];
        [editingItem setValue:typeCell.text forKey:@"Type"];
        [self.navigationController pushViewController:typeListController animated:YES];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Have an accessory view for the second section only
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
}

// Make the header height in the first section 45 pixels
- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 45.0 : 10.0;
}

// Show a header for only the first section
- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
    return (section == 0) ? headerView : nil;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? nameCell : typeCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
