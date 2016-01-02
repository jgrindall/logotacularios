//
//  PTurtleModel.h
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol PTurtleModel <PAbstractModel>

extern NSString* const TURTLE_PEN_DOWN;
extern NSString* const TURTLE_COLOR;
extern NSString* const TURTLE_BG_COLOR;
extern NSString* const TURTLE_PEN_THICK;
extern NSString* const TURTLE_HEADING;
extern NSString* const TURTLE_POS;

- (void) rotateBy:(float) angle;

- (void) moveFdBy:(float) angle;

- (void) home;

- (void) reset;

@end
