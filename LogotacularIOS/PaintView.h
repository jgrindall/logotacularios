//
//  PaintView.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView

- (void) drawLineFrom:(CGPoint)p0 to:(CGPoint)p1 withColor:(UIColor *)clr andThickness:(NSInteger)thickness;

- (void) drawArcUsingAngle:(float)a andRadius:(float)r andCentre:(CGPoint) c andStartAngle:(float) a0 withColor:(UIColor *)clr andThickness:(NSInteger)thickness andCW:(int) cw;

- (void) drawTextAt:(CGPoint)p withColor:(UIColor*) clr andString:(NSString*)s;

- (void) reset;

- (void) bg:(UIColor*)clr;

- (void) transformWith:(CGAffineTransform)t;

- (void) flushTransformsWith:(CGAffineTransform)t;

- (void) setFlushedTransform:(CGAffineTransform)t;

- (void) drawTriangleAt:(CGPoint)p withHeading:(float) h withColor:(UIColor*)clr;

- (void) drawGrid;

- (void) setGridType:(int) type;

- (void) setGridClr:(UIColor*) clr;

- (void) onViewDidLoad;

- (void)hideTriangle;

- (void)clickTriangle:(BOOL)hideTri;

@end

