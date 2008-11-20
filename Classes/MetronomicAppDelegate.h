//
//  MetronomicAppDelegate.h
//  Metronomic
//
//  Created by PEZ on 2008-11-17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

// Inform the compiler that the following classes are defined in the project:
@class Book, MasterViewController, DetailViewController, AddViewController, EditingViewController;

@interface MetronomicAppDelegate : NSObject {
    IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;
    NSMutableArray *books;
    // Opaque reference to the SQLite database.
    sqlite3 *database;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

// Makes the main array of book objects available to other objects in the application.
@property (nonatomic, retain) NSMutableArray *books;

// Removes a book from the array of books, and also deletes it from the database. There is no undo.
- (IBAction)removeBook:(Book *)book;
// Creates a new book object with default data. 
- (void)addBook:(Book *)book;

@end

