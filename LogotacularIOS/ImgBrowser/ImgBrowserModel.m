//
//  FileBrowserModel.m
//  LogotacularIOS
//
//  Created by John on 03/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ImgBrowserModel.h"

@implementation ImgBrowserModel

NSString* const IMG_BROWSER_SELECTED_INDEX = @"img_browser_selected";

-(void) setDefaults{
	[super setDefaults];
	[self reset];
}

- (void) reset{
	[self.propHash setValue:@-1 forKey:IMG_BROWSER_SELECTED_INDEX];
}

- (NSArray*) getKeys{
	return @[IMG_BROWSER_SELECTED_INDEX];
}

@end
