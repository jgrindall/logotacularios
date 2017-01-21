//
//  MenuModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//
// need to do this:  [NSUserDefaults.standardUserDefaults registerDefaults:userDefaultsDefaults];


#import "OptionsModel.h"

@implementation OptionsModel

NSString* const GRID_TYPE = @"grid_type";
NSString* const FONT_SIZE = @"font_size";

- (void) setDefaults{
	NSInteger grid = [[NSUserDefaults standardUserDefaults] integerForKey:@"GridType"];
	NSInteger fs = [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
	[self setVal:[NSNumber numberWithInteger:grid] forKey:GRID_TYPE];
	NSLog(@"fs %i", fs);
	if(fs == 0){
		
	}
	[self setVal:[NSNumber numberWithInteger:fs] forKey:FONT_SIZE];
}

- (NSArray*) getKeys{
	return @[GRID_TYPE, FONT_SIZE];
}

- (void) setVal:(id)val forKey:(NSString*)key{
	[super setVal:val forKey:key];
	if([key isEqualToString:GRID_TYPE]){
		[[NSUserDefaults standardUserDefaults] setInteger:[val integerValue] forKey:@"GridType"];
	}
	else if([key isEqualToString:FONT_SIZE]){
		[[NSUserDefaults standardUserDefaults] setInteger:[val integerValue] forKey:@"FontSize"];
	}
}

@end
