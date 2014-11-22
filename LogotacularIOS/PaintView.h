//
//  PaintView.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView

- (void) drawLineFrom:(CGPoint)p0 to:(CGPoint)p1 withColor:(UIColor *)clr andThickness:(int)thickness;

- (void) reset;

- (void) bg:(UIColor*)clr;

- (void) transformWith:(CGAffineTransform)t;

@end

