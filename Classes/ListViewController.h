#import <UIKit/UIKit.h>
#import "SongList.h"

// Forward declaration of the editing view controller's class for the compiler.
@class PropertiesViewController;

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
    SongList *song_list;
    PropertiesViewController *editingViewController;
}

@property (nonatomic, retain) SongList *song_list;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PropertiesViewController *editingViewController;

@end
