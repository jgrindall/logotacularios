//
//  MenuModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GridModel.h"

@implementation GridModel

NSString* const GRID_TYPE = @"grid_type";

- (void) setDefaults{
	[self setVal:@0 forKey:GRID_TYPE];
}

- (NSArray*) getKeys{
	return @[GRID_TYPE];
}

@end
