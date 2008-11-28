#import "DetailCell.h"

@implementation DetailCell

@synthesize type, name, prompt, promptMode;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        type = [[UILabel alloc] initWithFrame:CGRectZero];
        type.font = [UIFont boldSystemFontOfSize:12];
        type.textColor = [UIColor darkGrayColor];
        type.textAlignment = UITextAlignmentRight;
        type.backgroundColor = [UIColor clearColor];
        name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.font = [UIFont boldSystemFontOfSize:14];
        name.backgroundColor = [UIColor clearColor];
        prompt = [[UILabel alloc] initWithFrame:CGRectZero];
        prompt.font = [UIFont boldSystemFontOfSize:12];
        prompt.textColor = [UIColor darkGrayColor];
        prompt.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:type];
        [self.contentView addSubview:name];
        [self.contentView addSubview:prompt];
//        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void)dealloc {
    [type release];
    [name release];
    [prompt release];
    [super dealloc];
}

// Setting the prompt mode to YES hides the type/name labels and shows the prompt label.
- (void)setPromptMode:(BOOL)flag {
    if (flag) {
        type.hidden = YES;
        name.hidden = YES;
        prompt.hidden = NO;
    } else {
        type.hidden = NO;
        name.hidden = NO;
        prompt.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Start with a rect that is inset from the content view by 10 pixels on all sides.
    CGRect baseRect = CGRectInset(self.contentView.bounds, 10, 10);
    CGRect rect = baseRect;
    rect.origin.x += 15;
    // Position each label with a modified version of the base rect.
    prompt.frame = rect;
    rect.origin.x -= 15;
    rect.size.width = 60;
    type.frame = rect;
    rect.origin.x += 70;
    rect.size.width = baseRect.size.width - 70;
    name.frame = rect;
}

// Update the text color of each label when entering and exiting selected mode.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        name.textColor = [UIColor whiteColor];
        type.textColor = [UIColor whiteColor];
        prompt.textColor = [UIColor whiteColor];
    } else {
        name.textColor = [UIColor blackColor];
        type.textColor = [UIColor darkGrayColor];
        prompt.textColor = [UIColor darkGrayColor];
    }
}

@end
