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
#import "Appearance.h"
#import "Utils.h"

@interface GridView ()

@property CGContextRef cacheContext;
@property int _gridType;

@end

@implementation GridView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_flushedTransform = CGAffineTransformIdentity;
		self._gridType = 0;
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void) setGridType:(int) type{
	self._gridType = type;
	[self redraw];
}

- (void) reset{
	[self initContext];
	[self redraw];
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

- (void) drawNoneAt:(CGPoint)centre{
	
}

- (void) drawGridAt:(CGPoint)centre{
	CGContextClearRect(self.cacheContext, self.bounds);
	if(self._gridType == 0){
		[self drawNoneAt:centre];
	}
	else if(self._gridType == 1){
		[self drawRectAt:centre];
	}
	else if(self._gridType == 2){
		[self drawPolarAt:centre full:YES];
	}
	else if(self._gridType == 3){
		[self drawPolarAt:centre full:NO];
		[self drawRectAt:centre];
	}
	[self setNeedsDisplay];
}

- (void) drawPolarAt:(CGPoint)centre full:(BOOL)full{
	const int SIZE = 100;
	CGSize size = self.frame.size;
	CGFloat scale = [self getScale:self.flushedTransform];
	CGPoint c0 = [self getFlushedPoint:centre];
	NSDictionary* d = [Appearance getGrayRGBA];
	float rgb = [[d objectForKey:@"r"] floatValue];
	UIColor* major = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.3];
	UIColor* minor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.175];
	UIColor* veryMinor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.06];
	float dx0 = c0.x;
	float dx1 = size.width - c0.x;
	float dy0 = c0.y;
	float dy1 = size.height - c0.y;
	float dTopLeft = sqrt(dx0*dx0 + dy0*dy0);
	float dTopRight = sqrt(dx1*dx1 + dy0*dy0);
	float dBottomLeft = sqrt(dx0*dx0 + dy1*dy1);
	float dBottomRight = sqrt(dx1*dx1 + dy1*dy1);
	float maxD = fmax(fmax(fmax(dTopLeft, dTopRight), dBottomLeft), dBottomRight);
	float minD = fmin(fmin(fmin(dTopLeft, dTopRight), dBottomLeft), dBottomRight);
	int circleNumMax = (int)ceil((maxD / SIZE) / scale);
	int circleNumMin = 1;
	if(c0.x < 0 || c0.x > size.width || c0.y < 0 || c0.y > size.height){
		// outside
		circleNumMin = (int)floor((minD / SIZE) / scale);
		circleNumMin = circleNumMin <= 0 ? 1 : circleNumMin;
	}
	for(int i = circleNumMin; i <= circleNumMax; i++){
		[self drawCircleAt:c0 withRadius:SIZE*i*scale withColor:minor];
	}
	[self drawLineFrom:CGPointMake(c0.x, 0) to:CGPointMake(c0.x, size.height) withColor:major];
	[self drawLineFrom:CGPointMake(0, c0.y) to:CGPointMake(size.width, c0.y) withColor:major];
	if(full){
		int angles[10] = {15,30,45,60,75,105,120,135,150,165};
		for(int i = 0; i < 10; i++){
			CGPoint rad = CGPointMake(10.0*cos(angles[i] * M_PI/180.0), 10.0*sin(angles[i] * M_PI/180.0));
			NSArray* pts = [Utils intersectionsWithRectForPoint0:c0 andPoint1:CGPointMake(c0.x + rad.x, c0.y + rad.y) andRect:self.frame];
			if([pts count] == 2){
				NSValue* val0 = [pts objectAtIndex:0];
				CGPoint p0 = val0.CGPointValue;
				NSValue* val1 = [pts objectAtIndex:1];
				CGPoint p1 = val1.CGPointValue;
				[self drawLineFrom:p0 to:p1 withColor:(angles[i] % 45 == 0 ? minor : veryMinor)];
			}
		}
	}
}

- (void) drawRectAt:(CGPoint)centre{
	const int SIZE = 100;
	float x;
	float y;
	CGSize size = self.frame.size;
	CGPoint c0 = [self getFlushedPoint:centre];
	CGFloat scale = [self getScale:self.flushedTransform];
	NSDictionary* d = [Appearance getGrayRGBA];
	float rgb = [[d objectForKey:@"r"] floatValue];
	UIColor* major = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.3];
	UIColor* minor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.1];
	CGContextSetLineWidth(self.cacheContext, 1);
	int numLeftInt = floor((double)((c0.x / SIZE) / scale));
	int numRightInt = floor((double)(((size.width - c0.x) / SIZE) / scale));
	int numTopInt = floor((double)((c0.y / SIZE) / scale));
	int numBottomInt = floor((double)(((size.height - c0.y) / SIZE) / scale));
	for(int i = -numLeftInt; i <= numRightInt; i++){
		x = c0.x + i*SIZE*scale;
		[self drawLineFrom:CGPointMake(x, 0) to:CGPointMake(x, size.height) withColor:(i == 0 ? major : minor)];
	}
	for(int i = -numTopInt; i <= numBottomInt; i++){
		y = c0.y + i*SIZE*scale;
		[self drawLineFrom:CGPointMake(0, y) to:CGPointMake(size.width, y) withColor:(i == 0 ? major : minor)];
	}
}

- (void) drawLineFrom:(CGPoint)fromPos to:(CGPoint) toPos withColor:(UIColor*) clr{
	CGContextSetStrokeColorWithColor(self.cacheContext, [clr CGColor]);
	CGContextMoveToPoint(self.cacheContext, fromPos.x, fromPos.y);
	CGContextAddLineToPoint(self.cacheContext, toPos.x, toPos.y);
	CGContextStrokePath(self.cacheContext);
}

- (void) drawCircleAt:(CGPoint)c withRadius:(int) r withColor:(UIColor*) clr{
	CGContextSetStrokeColorWithColor(self.cacheContext, [clr CGColor]);
	CGContextAddEllipseInRect(self.cacheContext, CGRectMake(c.x - r, c.y - r, 2*r, 2*r));
	CGContextStrokePath(self.cacheContext);
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
		CGContextSetShouldAntialias(self.cacheContext, NO);
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
