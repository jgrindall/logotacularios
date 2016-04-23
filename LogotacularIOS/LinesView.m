//
//  PaintView.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LinesView.h"
#import "TriView.h"
#import <CoreText/CoreText.h>

@interface LinesView ()

@property TriView* triView;
@property BOOL hideTri;

@end

@implementation LinesView

CGContextRef cacheContext;

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_flushedTransform = CGAffineTransformIdentity;
		self.hideTri = [[NSUserDefaults standardUserDefaults] boolForKey:@"HideTri"];
		self.triView = [[TriView alloc] initWithFrame:CGRectMake(0, 0, 2*TRI_RADIUS, 2*TRI_RADIUS)];
		if(!self.hideTri){
			[self addSubview:self.triView];
		}
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void) reset{
	[self initContext];
	[self resetTri];
	[self setNeedsDisplay];
}

- (void) onViewDidLoad{
	[self initContext];
	[self resetTri];
}

- (BOOL) initContext {
	if(cacheContext){
		CGContextRelease(cacheContext);
	}
	CGSize size = self.frame.size;
	int	bitmapBytesPerRow;
	int bytesPerPixel = 4;
	int w = (int)(size.width);
	int h = (int)(size.height);
	bitmapBytesPerRow = (w * bytesPerPixel);
	if(w > 0 && h > 0){
		cacheContext = CGBitmapContextCreate (NULL, w, h, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
		CGContextClearRect(cacheContext, self.bounds);
		CGContextSetRGBFillColor(cacheContext, 0.0, 0.0, 0.0, 0.0);
		CGContextFillRect(cacheContext, self.bounds);
		CGContextSetLineCap(cacheContext, kCGLineCapRound);
	}
	else{
		CGContextRelease(cacheContext);
	}
	return YES;
}

- (CGFloat)getScale:(CGAffineTransform)t {
	return sqrt(t.a * t.a  +  t.c * t.c);
}

- (void) drawTextAt:(CGPoint)p withColor:(UIColor*) clr andString:(NSString*)s {
	p = CGPointMake(p.x, p.y - 2);
	CGPoint p1 = [self getFlushedPoint:p];
	CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", 13.0f, NULL);
	CGColorRef color = clr.CGColor;
	NSDictionary* attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef, (id)kCTFontAttributeName, color, (id)kCTForegroundColorAttributeName, nil];
	NSAttributedString* stringToDraw = [[NSAttributedString alloc] initWithString:s attributes:attrDictionary];
	CGRect bounds = [stringToDraw boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
	CGContextSetTextMatrix(cacheContext, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
	CGContextSetTextPosition(cacheContext, p1.x, p1.y);
	CTLineDraw(line, cacheContext);
	CFRelease(line);
	CFRelease(fontRef);
	[self setNeedsDisplayInRect:bounds];
	CGRect translatedBounds = CGRectMake(bounds.origin.x + p1.x, bounds.origin.y + p1.y - bounds.size.height, bounds.size.width, bounds.size.height);
	[self setNeedsDisplayInRect:translatedBounds];
}

- (void)hideTriangle{
	self.triView.alpha = 0;
}

- (void)clickTriangle:(BOOL)hideTri{
	if(hideTri && !self.hideTri){
		[self.triView removeFromSuperview];
		self.hideTri = hideTri;
	}
	else if(!hideTri && self.hideTri){
		[self addSubview:self.triView];
		self.hideTri = hideTri;
	}
}

- (void) resetTri{
	CGSize size = self.frame.size;
	UIColor* clr = [UIColor blackColor];
	[self drawTriangleAt:CGPointMake(size.width/2, size.height/2) withHeading:-90 withColor:clr];
}

- (void) drawTriangleAt:(CGPoint)p withHeading:(float)h withColor:(UIColor*)clr{
	if(self.triView){
		float scale = [self getScale:self.flushedTransform];
		[self.triView drawWithSize:scale withHeading:h withColor:clr];
		CGPoint flushedPoint = [self getFlushedPoint:p];
		CGRect frame = CGRectMake(flushedPoint.x - TRI_RADIUS, flushedPoint.y - TRI_RADIUS, 2*TRI_RADIUS, 2*TRI_RADIUS);
		self.triView.frame = frame;
		self.triView.alpha = 1;
		[self setNeedsDisplay];
	}
}

- (void) drawLineFrom:(CGPoint)fromPos to:(CGPoint) toPos withColor:(UIColor*) clr andThickness:(NSInteger)thickness {
	CGContextSetStrokeColorWithColor(cacheContext, [clr CGColor]);
	float thickness1 = thickness * [self getScale:self.flushedTransform];
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
