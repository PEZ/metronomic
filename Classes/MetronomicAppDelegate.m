//
//  MetronomicAppDelegate.m
//  Metronomic
//
//  Created by PEZ on 2008-11-17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MetronomicAppDelegate.h"
#import "RootViewController.h"


@implementation MetronomicAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
