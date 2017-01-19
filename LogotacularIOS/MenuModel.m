//
//  MenuModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

NSString* const MENU_SHOWN = @"menu_shown";
NSString* const GRID_MENU_SHOWN = @"grid_menu_shown";

- (void) setDefaults{
	[self setVal:@NO forKey:MENU_SHOWN];
	[self setVal:@NO forKey:GRID_MENU_SHOWN];
}

- (NSArray*) getKeys{
	return @[MENU_SHOWN, GRID_MENU_SHOWN];
}

@end
