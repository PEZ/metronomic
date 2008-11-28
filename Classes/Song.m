#import "Song.h"


@implementation Song
@synthesize name, bpm, signature, lamps, comment;

static NSString * const NAME_KEY = @"Name";
static NSString * const BPM_KEY = @"BPM";
static NSString * const SIGNATURE_KEY = @"Signature";
static NSString * const LAMPS_KEY = @"Lamps";
static NSString * const COMMENT_KEY = @"Comment";

- (id) init {
	if (self = [super init]) {
		self.name = @"";
		self.bpm = [NSNumber numberWithInt:80];
		self.signature = @"2/4";
		self.lamps = [NSNumber numberWithInt:2];
		self.comment = @"";
	}
	return self;
}

- (void) dealloc {
	[name release];
	[bpm release];
	[signature release];
	[lamps release];
	[comment release];
	[super dealloc];
}

- (id) initWithDictionary:(NSDictionary *) d {
	if (self = [super init]) {
		self.name = [d objectForKey: NAME_KEY];
		self.bpm = [d objectForKey: BPM_KEY];
		self.signature = [d objectForKey: SIGNATURE_KEY];
		self.lamps = [d objectForKey: LAMPS_KEY];
		self.comment = [d objectForKey: COMMENT_KEY];
	}
	return self;
}

- (NSDictionary *) asDictionary {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			self.name, NAME_KEY,
			self.bpm, BPM_KEY,
			self.signature, SIGNATURE_KEY,
			self.lamps, LAMPS_KEY,
			self.comment, COMMENT_KEY,
			nil];
}

@end
