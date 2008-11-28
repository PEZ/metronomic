#import <UIKit/UIKit.h>

@interface PropertyCell : UITableViewCell {
    UITextField *textField;
    UITextField *promptField;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextField *promptField;

@end
