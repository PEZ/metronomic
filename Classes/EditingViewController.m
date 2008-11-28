#import "EditingViewController.h"
#import "PropertyCell.h"
#import "Song.h"

@implementation EditingViewController

@synthesize song, originalSongData, songs, newItem, tableView, headerView;

- (void)setSong:(Song *)anItem {
    [song release];
    song = [anItem retain];
    self.originalSongData = [song asDictionary];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [song release];
    [originalSongData release];
	[songs release];
    [tableView release];
    [headerView release];
    [super dealloc];
}

- (IBAction)cancel:(id)sender {
    newItem = NO;
    song = [originalSongData copy];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    song.name = nameCell.textField.text;
	song.bpm = [NSNumber numberWithInteger:[bpmCell.textField.text integerValue]];
    song.signature = signatureCell.textField.text;
	song.lamps = [NSNumber numberWithInteger:[lampsCell.textField.text integerValue]];
    song.comment = commentCell.textField.text;
	if (newItem == YES) {
		[songs addObject:song];
		newItem = NO;
	}
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 100)] autorelease];
}

- (PropertyCell *) setUpCell:(PropertyCell *)cell withData:(id)data identifyUsing:(NSString *)identifier {
  if (!cell) {
        cell = [[PropertyCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
    }
    cell.textField.text = [NSString stringWithFormat:@"%@", data];
	cell.promptField.text = identifier;
	return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    if (song == nil) {
        self.song = [[Song alloc] init];
		newItem = YES;
		self.title = @"New song";
    }
	else {
		self.title = [NSString stringWithFormat:@"Editing %@", song.name];
	}
	
    [tableView reloadData];
	
	nameCell = [self setUpCell:nameCell withData:song.name identifyUsing:@"Name"];
	bpmCell = [self setUpCell:bpmCell withData:song.bpm identifyUsing:@"BPM"];
	signatureCell = [self setUpCell:signatureCell withData:song.signature identifyUsing:@"Signature"];
	lampsCell = [self setUpCell:lampsCell withData:song.lamps identifyUsing:@"Lamps"];
	commentCell = [self setUpCell:commentCell withData:song.comment identifyUsing:@"Comment"];
	
    [nameCell.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [nameCell.textField resignFirstResponder];
}

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell *cell;
    switch (indexPath.row) {
		case 0:
			cell = nameCell;
			break;
		case 1:
			cell = bpmCell;
			break;
		case 2:
			cell = signatureCell;
			break;
		case 3:
			cell = lampsCell;
			break;
		case 4:
			cell = commentCell;
			break;
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
