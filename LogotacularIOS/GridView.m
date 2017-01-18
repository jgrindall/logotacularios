//
//  PaintView.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GridView.h"
#import <CoreText/CoreText.h>
#import "TextLayout.h"

@interface GridView ()

@property CGContextRef cacheContext;

@end

@implementation GridView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_flushedTransform = CGAffineTransformIdentity;
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void) reset{
	[self initContext];
	[self redraw];
	[self setNeedsDisplay];
}

- (void) onViewDidLoad{
	[self initContext];
	[self redraw];
}

- (void) redraw{
	CGSize size = self.frame.size;
	float visibleWidth = (1 - TEXT_WIDTH)*size.width;
	float fullWidth = size.width;
	float weighted = (2.0*visibleWidth + 1.0*fullWidth)/3.0;
	CGPoint centre = CGPointMake(weighted/2.0, size.height/2.0);
	[self drawGridAt:centre];
}

- (void) drawGridAt:(CGPoint)centre{
	CGPoint p0 = CGPointMake(centre.x, centre.y - 100);
	[self drawLineFrom:centre to:p0 withColor:[UIColor redColor] andThickness:3];
}

- (void) drawLineFrom:(CGPoint)fromPos to:(CGPoint) toPos withColor:(UIColor*) clr andThickness:(NSInteger)thickness {
	CGContextSetStrokeColorWithColor(self.cacheContext, [clr CGColor]);
	float thickness1 = thickness * [self getScale:self.flushedTransform];
	CGContextSetLineWidth(self.cacheContext, thickness1);
	CGPoint toPos1 = [self getFlushedPoint:toPos];
	CGPoint fromPos1 = [self getFlushedPoint:fromPos];
	CGContextMoveToPoint(self.cacheContext, fromPos1.x, fromPos1.y);
	CGContextAddLineToPoint(self.cacheContext, toPos1.x, toPos1.y);
	CGContextStrokePath(self.cacheContext);
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect {
	if(self.cacheContext){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGImageRef cacheImage = CGBitmapContextCreateImage(self.cacheContext);
		CGContextClipToRect(context, rect);
		CGContextDrawImage(context, self.bounds, cacheImage);
		CGImageRelease(cacheImage);
	}
}

- (BOOL) initContext {
	if(self.cacheContext){
		CGContextRelease(self.cacheContext);
	}
	CGSize size = self.frame.size;
	int	bitmapBytesPerRow;
	int bytesPerPixel = 4;
	int w = (int)(size.width);
	int h = (int)(size.height);
	bitmapBytesPerRow = (w * bytesPerPixel);
	if(w > 0 && h > 0){
		self.cacheContext = CGBitmapContextCreate (NULL, w, h, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
		CGContextClearRect(self.cacheContext, self.bounds);
		CGContextSetRGBFillColor(self.cacheContext, 0.0, 0.0, 0.0, 0.0);
		CGContextFillRect(self.cacheContext, self.bounds);
		CGContextSetLineCap(self.cacheContext, kCGLineCapRound);
	}
	else{
		CGContextRelease(self.cacheContext);
	}
	return YES;
}

- (CGFloat)getScale:(CGAffineTransform)t {
	return sqrt(t.a * t.a  +  t.c * t.c);
}

- (CGPoint) getFlushedPoint:(CGPoint)p{
	float w = self.frame.size.width/2.0;
	float h = self.frame.size.height/2.0;
	p.x -= w;
	p.y -= h;
	CGPoint p1 = CGPointApplyAffineTransform(p, self.flushedTransform);
	return CGPointMake(p1.x + w, p1.y + h);
}

- (void) dealloc{
	if(self.cacheContext){
		CGContextRelease(self.cacheContext);
	}
}

@end
