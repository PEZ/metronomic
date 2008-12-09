//
//  EditPropertyController.h
//  Metronomic
//
//  Created by PEZ on 2008-11-28.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditPropertyController : UIViewController {
	NSString *oldValue;
	NSString *editingItem;
	UITextField *editField;
}

@property (nonatomic, retain) NSString *oldValue;
@property (nonatomic, retain) IBOutlet NSString *editingItem;
@property (nonatomic, retain) IBOutlet UITextField *editField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end