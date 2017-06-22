//
//  PaintView.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinesView : UIView

- (void) drawLineFrom:(CGPoint)fromPos to:(CGPoint) toPos withColor:(UIColor*) clr andThickness:(NSInteger)thickness;

- (void) drawArcUsingAngle:(float)a andRadius:(float) r andCentre:(CGPoint) c andStartAngle:(float) a0 withColor:(UIColor*) clr andThickness:(NSInteger)thickness andCW:(int) cw;

- (void) drawTextAt:(CGPoint)p withColor:(UIColor*) clr andString:(NSString*)s;

- (void) drawTriangleAt:(CGPoint)p withHeading:(float)h withColor:(UIColor*)clr;

- (void)hideTriangle;

- (void) reset;

- (void) onViewDidLoad;

- (void)clickTriangle:(BOOL)hideTri;

@property CGAffineTransform flushedTransform;

@end
