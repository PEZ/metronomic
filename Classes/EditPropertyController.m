//
//  EditPropertyController.m
//  Metronomic
//
//  Created by PEZ on 2008-11-28.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EditPropertyController.h"


@implementation EditPropertyController

@synthesize oldValue, editingItem, editField;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[oldValue release];
    [super dealloc];
}


- (IBAction)cancel:(id)sender {
	editingItem = oldValue;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end