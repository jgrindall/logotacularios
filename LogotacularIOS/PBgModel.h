//
//  PBgModel.h
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol PBgModel <PAbstractModel>

extern NSString* const BG_COLOR;
extern NSString* const BG_IMAGE;

- (void) reset;

@end

