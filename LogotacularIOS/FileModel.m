//
//  FileModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

NSString* const FILE_FILENAME = @"file_filename";
NSString* const FILE_DIRTY = @"file_dirty";
NSString* const FILE_REAL = @"file_real";

- (void) setDefaults{
	[self reset];
}

- (void) reset{
	NSLog(@"a");
	[self setVal:nil forKey:FILE_FILENAME];
	NSLog(@"b");
	[self setVal:[NSNumber numberWithBool:YES] forKey:FILE_DIRTY];
	NSLog(@"c");
	[self setVal:[NSNumber numberWithBool:NO] forKey:FILE_REAL];
	NSLog(@"d");
}

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:FILE_DIRTY, FILE_FILENAME, FILE_REAL, nil];
}

@end
