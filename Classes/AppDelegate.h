#import <UIKit/UIKit.h>
#import "SongList.h"

// Forward declaration of the main view controller's class for the compiler.
@class ListViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    ListViewController *detailViewController;
    SongList *song_list;
    NSString *pathToAppData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ListViewController *detailViewController;
@property (nonatomic, retain) SongList *song_list;
@property (nonatomic, copy) NSString *pathToAppData;

@end
