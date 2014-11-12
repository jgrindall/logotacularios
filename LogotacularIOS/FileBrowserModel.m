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

-(void) setDefaults{
	[super setDefaults];
	[self reset];
}

- (void) reset{
	[self.propHash setValue:@-1 forKey:BROWSER_SELECTED_INDEX];
}

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:BROWSER_SELECTED_INDEX, nil];
}

@end
