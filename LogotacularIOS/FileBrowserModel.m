//
//  FileBrowserModel.m
//  LogotacularIOS
//
//  Created by John on 03/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileBrowserModel.h"

@implementation FileBrowserModel

NSString* const BROWSER_SELECTED_INDEX = @"browser_selected";
NSString* const BROWSER_SELECTED_OPEN = @"browser_open";

-(void) setDefaults{
	[super setDefaults];
	[self reset];
}

- (void) reset{
	[self.propHash setValue:[NSNumber numberWithInteger:-1] forKey:BROWSER_SELECTED_INDEX];
	[self.propHash setValue:[NSNumber numberWithBool:NO] forKey:BROWSER_SELECTED_OPEN];
}

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:BROWSER_SELECTED_INDEX, BROWSER_SELECTED_OPEN, nil];
}

@end
