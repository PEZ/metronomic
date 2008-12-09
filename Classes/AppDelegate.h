#import <UIKit/UIKit.h>

@class ListViewController, SongList;

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
