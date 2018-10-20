//
//  DrawingModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ProcessingModel.h"

@implementation ProcessingModel

NSString* const PROCESSING_ISPROCESSING = @"processing_isprocessing";

- (void) setDefaults{
	[self setVal:@NO forKey:PROCESSING_ISPROCESSING];
}

- (NSArray*) getKeys{
	return @[PROCESSING_ISPROCESSING];
}

@end
