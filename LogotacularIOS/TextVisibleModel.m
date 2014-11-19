//
//  TextVisibleModel.m
//  LogotacularIOS
//
//  Created by John on 19/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TextVisibleModel.h"

@implementation TextVisibleModel

NSString* const TEXT_VISIBLE_VIS = @"textvis_vis";

- (void) setDefaults{
	[self setVal:@YES forKey:TEXT_VISIBLE_VIS];
}

- (NSArray*) getKeys{
	return @[TEXT_VISIBLE_VIS];
}

@end
