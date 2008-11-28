#import "ListViewController.h"
#import "DetailCell.h"
#import "EditingViewController.h"
#import "Song.h"

@implementation ListViewController

@synthesize song_list, tableView, editingViewController;

- (void)dealloc {
    tableView.delegate = nil;
    tableView.dataSource = nil;
    [tableView release]; 
    [song_list release];
    [editingViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (EditingViewController *)editingViewController {
    if (editingViewController == nil) {
        EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
        self.editingViewController = controller;
        [controller release];
    }
    return editingViewController;
}

#pragma mark Table Content and Appearance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [song_list.songs count];
    if (self.editing) {
		return count + 1;
	}
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    if (cell == nil) {
        cell = [[[DetailCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DetailCell"] autorelease];
        cell.hidesAccessoryWhenEditing = NO;
    }

	if (indexPath.row < [song_list.songs count]) {
		Song *song = [song_list.songs objectAtIndex:indexPath.row];
		cell.name.text = song.name;
		cell.promptMode = NO;
	} else {
		cell.prompt.text = @"Add new";
		cell.promptMode = YES;
	}
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;

	if (indexPath.row < [song_list.songs count]) {
		return UITableViewCellEditingStyleDelete;
	} else {
		return UITableViewCellEditingStyleInsert;
	}
    return UITableViewCellEditingStyleNone;
}

#pragma mark Table Selection 

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
		EditingViewController *controller = self.editingViewController;
		if (indexPath.row < [song_list.songs count]) {
			controller.song = [song_list.songs objectAtIndex:indexPath.row];
		} else {
			controller.song = nil;
		}
		controller.songs = song_list.songs;
		[self.navigationController pushViewController:controller animated:YES];
	} else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[song_list.songs count] inSection:0], nil];
    [tableView beginUpdates];
    [tableView setEditing:editing animated:YES];
    if (editing) {
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    [tableView endUpdates];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [song_list.songs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		EditingViewController *controller = self.editingViewController;
		controller.song = nil;
		controller.songs = song_list.songs;
		[self.navigationController pushViewController:controller animated:YES];
	}
}

#pragma mark Row reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < [song_list.songs count]);
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
        toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSUInteger songCount = [song_list.songs count];
    if (proposedDestinationIndexPath.row >= songCount) {
        return [NSIndexPath indexPathForRow:songCount - 1 inSection:sourceIndexPath.section];
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
            toIndexPath:(NSIndexPath *)toIndexPath {
	if (toIndexPath.row < [song_list.songs count]) {
		id item = [[song_list.songs objectAtIndex:fromIndexPath.row] retain];
		[song_list.songs removeObject:item];
		[song_list.songs insertObject:item atIndex:toIndexPath.row];
		[item release];
	}
}

@end
