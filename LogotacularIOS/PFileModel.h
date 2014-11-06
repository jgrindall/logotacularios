//
//  PFileModel.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol PFileModel <PAbstractModel>

extern NSString* const FILE_FILENAME;
extern NSString* const FILE_DIRTY;
extern NSString* const FILE_REAL;

@end
