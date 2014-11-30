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
		_flushedTransform = CGAffineTransformIdentity;
		[self setBackgroundColor:[UIColor clearColor]];
		[self reset];
	}
	return self;
}

- (void) layoutSubviews{
	[self reset];
}

- (void) reset{
	[self initContext];
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

- (CGFloat)getScale:(CGAffineTransform)t {
	return sqrt(t.a * t.a  +  t.c * t.c);
}

- (void) drawLineFrom:(CGPoint)fromPos to:(CGPoint) toPos withColor:(UIColor*) clr andThickness:(NSInteger)thickness {
	//NSLog(@"draw line with %@", NSStringFromCGAffineTransform(self.flushedTransform));
	CGContextSetStrokeColorWithColor(cacheContext, [clr CGColor]);
	CGContextSetLineCap(cacheContext, kCGLineCapRound);
	float thickness1 = thickness * [self getScale:self.flushedTransform];
	//NSLog(@"thick %i %f", thickness, thickness1);
	CGContextSetLineWidth(cacheContext, thickness1);
	CGPoint toPos1 = [self getFlushedPoint:toPos];
	CGPoint fromPos1 = [self getFlushedPoint:fromPos];
	CGContextMoveToPoint(cacheContext, fromPos1.x, fromPos1.y);
	CGContextAddLineToPoint(cacheContext, toPos1.x, toPos1.y);
	CGContextStrokePath(cacheContext);
	float p = thickness1/2.0;
	[self setNeedsDisplayInRect:CGRectUnion(CGRectMake(fromPos1.x - p, fromPos1.y - p, 2*p, 2*p), CGRectMake(toPos1.x - p, toPos1.y - p, 2*p, 2*p))];
}

- (CGPoint) getFlushedPoint:(CGPoint)p{
	float w = self.frame.size.width/2.0;
	float h = self.frame.size.height/2.0;
	p.x -= w;
	p.y -= h;
	CGPoint p1 = CGPointApplyAffineTransform(p, self.flushedTransform);
	return CGPointMake(p1.x + w, p1.y + h);
}

- (void) drawRect:(CGRect)rect {
	if(cacheContext){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
		CGContextDrawImage(context, self.bounds, cacheImage);
		CGImageRelease(cacheImage);
	}
}

- (void) dealloc{
	if(cacheContext){
		CGContextRelease(cacheContext);
	}
}

@end
