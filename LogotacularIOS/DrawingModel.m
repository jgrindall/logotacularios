//
//  DrawingModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingModel.h"

@implementation DrawingModel

NSString* const DRAWING_ISDRAWING = @"drawing_isdrawing";

- (void) setDefaults{
	[self setVal:@NO forKey:DRAWING_ISDRAWING];
}

- (NSArray*) getKeys{
	return @[DRAWING_ISDRAWING];
}

@end
