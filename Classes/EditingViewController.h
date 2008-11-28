#import <UIKit/UIKit.h>
@class Song, PropertyCell;

@interface EditingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    Song *song;
    NSDictionary *originalSongData;
	NSMutableArray *songs;
    UITableView *tableView;
    PropertyCell *nameCell;
    PropertyCell *bpmCell;
    PropertyCell *signatureCell;
    PropertyCell *lampsCell;
    PropertyCell *commentCell;
    BOOL newItem;
    UIView *headerView;
}

@property (nonatomic, retain) Song *song;
@property (nonatomic, copy) NSDictionary *originalSongData;
@property (nonatomic, retain) NSMutableArray *songs;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIView *headerView;
@property BOOL newItem;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
    
@end
