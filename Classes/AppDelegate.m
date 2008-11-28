#import "AppDelegate.h"
#import "ListViewController.h"


@implementation AppDelegate

@synthesize window, navigationController, detailViewController, song_list, pathToAppData;

- (void)copyBundledDataIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.pathToAppData = [documentsDirectory stringByAppendingPathComponent:@"appData.plist"];
    if ([fileManager fileExistsAtPath:pathToAppData] == NO) {
        NSString *pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:@"appData" ofType:@"plist"];
        if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:pathToAppData error:&error] == NO) {
            NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
        }
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self copyBundledDataIfNeeded];
    NSMutableArray *data = [[[NSMutableArray alloc] initWithContentsOfFile:pathToAppData] autorelease];
	song_list = [[SongList alloc] initFromData:data];
    detailViewController.song_list = song_list;
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [pathToAppData release];
    [detailViewController release];
    [song_list release];
    [navigationController release];
    [window release];
    [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [song_list saveToFile:pathToAppData];
}

@end