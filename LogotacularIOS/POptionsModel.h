//
//  PMenuModel.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol POptionsModel <PAbstractModel>

extern NSString* const GRID_TYPE;
extern NSString* const FONT_SIZE;
extern NSInteger const MIN_FONT_SIZE;
extern NSInteger const MAX_FONT_SIZE;

@end
