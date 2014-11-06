//
//  PFileBrowserModel.h
//  LogotacularIOS
//
//  Created by John on 03/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol PFileBrowserModel <PAbstractModel>

extern NSString* const BROWSER_SELECTED_INDEX;
extern NSString* const BROWSER_SELECTED_OPEN;

- (void) reset;

@end
