//
//  PFileBrowserModel.h
//  LogotacularIOS
//
//  Created by John on 03/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol PImgBrowserModel <PAbstractModel>

extern NSString* const IMG_BROWSER_SELECTED_INDEX;

- (void) reset;

@end
