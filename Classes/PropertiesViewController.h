#import <UIKit/UIKit.h>
@class Song, PropertyCell, EditPropertyController;

@interface PropertiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
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
	EditPropertyController *editController;
}

@property (nonatomic, retain) Song *song;
@property (nonatomic, copy) NSDictionary *originalSongData;
@property (nonatomic, retain) NSMutableArray *songs;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property BOOL newItem;
@property (nonatomic, retain) EditPropertyController *editController;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
    
@end
