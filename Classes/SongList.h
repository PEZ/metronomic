//
//  SongList.h
//  Metronomic
//
//  Created by PEZ on 2008-11-24.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Song;

@interface SongList : NSObject {
	NSMutableArray *songs;
}

@property (retain, readonly) NSMutableArray *songs;

- (id) initFromData:(NSMutableArray *) data;
- (void) addSong:(Song *) song;
- (void) saveToFile:(NSString *) path;

@end
