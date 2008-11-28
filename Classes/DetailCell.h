#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell {
    UITextField *type;
    UITextField *name;
    UITextField *prompt;
    BOOL promptMode;
}

@property (readonly, retain) UITextField *type;
@property (readonly, retain) UITextField *name;
@property (readonly, retain) UITextField *prompt;
@property BOOL promptMode;

@end
