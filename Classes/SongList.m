//
//  SongList.m
//  Metronomic
//
//  Created by PEZ on 2008-11-24.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SongList.h"
#import "Song.h"

@implementation SongList

@synthesize songs;

- (id) init {
	if (self = [super init]) {
		songs = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) initFromData:(NSMutableArray *) data {
	if (self = [self init]) {
		unsigned c = [data count];
		while (c--) {
			[self addSong:[[Song alloc] initWithDictionary:[data objectAtIndex:c]]];
		}
	}
	return self;
}

- (void) dealloc {
    [songs release];
    [super dealloc];
}

- (void) addSong:(Song *)song {
	[songs addObject:song];
}

- (void) saveToFile:(NSString *) path {
	NSMutableArray *data = [[NSMutableArray alloc] init];
	unsigned c = [songs count];
	while (c--) {
		[data addObject:[[songs objectAtIndex:c] asDictionary]];
	}
	[data writeToFile:path atomically:NO];
}

@end
