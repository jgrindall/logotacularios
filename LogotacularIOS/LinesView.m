//
//  PaintView.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LinesView.h"

@interface LinesView ()

@end

@implementation LinesView

CGContextRef cacheContext;

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self reset];
	}
	return self;
}

- (void) layoutSubviews{
	[self reset];
}

- (void) reset{
	[self initContext];
	[self setBackgroundColor:[UIColor clearColor]];
	[self setNeedsDisplay];
}

- (BOOL) initContext {
	if(cacheContext){
		CGContextRelease(cacheContext);
	}
	CGSize size = self.frame.size;
	int	bitmapBytesPerRow;
	int bytesPerPixel = 4;
	bitmapBytesPerRow = (size.width * bytesPerPixel);
	cacheContext = CGBitmapContextCreate (NULL, size.width, size.height, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGContextClearRect(cacheContext, self.bounds);
	CGContextSetRGBFillColor(cacheContext, 0.0, 0.0, 0.0, 0.0);
	CGContextFillRect(cacheContext, self.bounds);
	return YES;
}

- (void) drawLineFrom:(CGPoint)fromPos to:(CGPoint) toPos withColor:(UIColor*) clr andThickness:(int)thickness {
	float p = 2.0;
	CGContextSetStrokeColorWithColor(cacheContext, [clr CGColor]);
	CGContextSetLineCap(cacheContext, kCGLineCapRound);
	CGContextSetLineWidth(cacheContext, thickness);
	CGContextMoveToPoint(cacheContext, fromPos.x, fromPos.y);
	CGContextAddLineToPoint(cacheContext, toPos.x, toPos.y);
	CGContextStrokePath(cacheContext);
	[self setNeedsDisplayInRect:CGRectUnion(CGRectMake(fromPos.x - p, fromPos.y - p, 2*p, 2*p), CGRectMake(toPos.x - p, toPos.y - p, 2*p, 2*p))];
}

- (void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
	CGContextDrawImage(context, self.bounds, cacheImage);
	CGImageRelease(cacheImage);
}

@end
