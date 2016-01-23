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

- (void) drawTextAt:(CGPoint)p withColor:(UIColor*) clr andString:(NSString*)s;

- (void) reset;

@property CGAffineTransform flushedTransform;

@end
