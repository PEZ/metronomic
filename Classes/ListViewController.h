#import <UIKit/UIKit.h>

@class PropertiesViewController, SongList;

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
    SongList *song_list;
    PropertiesViewController *propertiesViewController;
}

@property (nonatomic, retain) SongList *song_list;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PropertiesViewController *propertiesViewController;

@end
