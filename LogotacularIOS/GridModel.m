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
	NSInteger grid = [[NSUserDefaults standardUserDefaults] integerForKey:@"GridType"];
	[self setVal:[NSNumber numberWithInteger:grid] forKey:GRID_TYPE];
}

- (NSArray*) getKeys{
	return @[GRID_TYPE];
}

- (void) setVal:(id)val forKey:(NSString*)key{
	[super setVal:val forKey:key];
	if([key isEqualToString:GRID_TYPE]){
		[[NSUserDefaults standardUserDefaults] setInteger:[val integerValue] forKey:@"GridType"];
	}
}

@end
