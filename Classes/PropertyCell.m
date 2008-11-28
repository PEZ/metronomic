#import "PropertyCell.h"

@implementation PropertyCell

@synthesize textField, promptField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        textField = [[UILabel alloc] initWithFrame:CGRectZero];
        //textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:textField];
        promptField = [[UILabel alloc] initWithFrame:CGRectZero];
        promptField.font = [UIFont boldSystemFontOfSize:12];
        promptField.textColor = [UIColor darkGrayColor];
        promptField.textAlignment = UITextAlignmentRight;
        promptField.backgroundColor = [UIColor clearColor];
        [self addSubview:promptField];
    }
    return self;
}

- (void)dealloc {
    [textField release];
    [promptField release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect rect = CGRectInset(self.contentView.bounds, 10, 10);
	rect.origin.x += 80;
	rect.size.width -= 80;
    textField.frame = rect;
	rect.origin.x -= 80;
	rect.size.width = 70;
    promptField.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        textField.textColor = [UIColor whiteColor];
    } else {
        textField.textColor = [UIColor blackColor];
    }
}

@end
