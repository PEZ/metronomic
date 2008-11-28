//
//  Song.h
//  Metronomic
//
//  Created by PEZ on 2008-11-24.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject {
	NSString *name;
	NSNumber *bpm;
	NSString *signature;
	NSNumber *lamps;
	NSString *comment;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *bpm;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSNumber *lamps;
@property (nonatomic, copy) NSString *comment;

- (id) initWithDictionary:(NSDictionary *) d;
- (NSDictionary *) asDictionary;

@end
