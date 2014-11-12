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
	[self setVal:nil forKey:FILE_FILENAME];
	[self setVal:@YES forKey:FILE_DIRTY];
	[self setVal:@NO forKey:FILE_REAL];
}

- (NSArray*) getKeys{
	return @[FILE_DIRTY, FILE_FILENAME, FILE_REAL];
}

@end
