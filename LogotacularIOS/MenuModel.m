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

- (void) setDefaults{
	[self setVal:[NSNumber numberWithBool:NO] forKey:MENU_SHOWN];
}

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:MENU_SHOWN, nil];
}

@end
