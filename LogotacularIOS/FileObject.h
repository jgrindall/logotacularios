//
//  DrawingObject.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADrawer.h"

@interface DrawingObject : NSObject <NSCoding>

@property NSMutableArray* lines;
@property UIColor* color;
@property NSNumber* alpha;
@property NSInteger width;
@property UIColor* bgColor;
@property NSInteger drawerNum;
@property ADrawer* drawer;
@property UIImage* baseImage;

- (void) clear;
- (void) setSize:(CGSize)size;
- (void) loadDefaultColors;

@end
