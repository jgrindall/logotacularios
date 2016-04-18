//
//  PaintView.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LinesView.h"
#import <CoreText/CoreText.h>

@interface LinesView ()

@property UIView* triView;

@end

@implementation LinesView

CGContextRef cacheContext;
bool created = 0;
bool layedout = 0;
const float TRI_W = 32;
const float TRI_H = 32;
const float DEG_TO_RAD = 3.14159/180.0;

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_flushedTransform = CGAffineTransformIdentity;
		self.triView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tri.png"]];
		[self addSubview:self.triView];
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void) layoutSubviews{
	[super layoutSubviews];
	if(layedout == 0){
		[self reset];
		layedout = 1;
	}
}

- (void) reset{
	NSLog(@"reset");
	[self initContext];
	[self setNeedsDisplay];
}

- (BOOL) initContext {
	NSLog(@"init context?");
	if(cacheContext){
		CGContextRelease(cacheContext);
	}
	CGSize size = self.superview.frame.size;
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
		created = 1;
		NSLog(@"initctx %i , %i", w, h);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ContextReady" object:self];
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

- (void) drawTriangleAt:(CGPoint)p withHeading:(float)h{
	NSLog(@"tri? %f %f %f", p.x, p.y, h);
	if(created == 1){
		NSLog(@"tri %f %f %f", p.x, p.y, h);
		float scale = [self getScale:self.flushedTransform];
		CGPoint flushedPoint = [self getFlushedPoint:p];
		CGRect frame = CGRectMake(flushedPoint.x - TRI_W/2, flushedPoint.y - TRI_H/2, TRI_W * scale, TRI_H * scale);
		self.triView.frame = frame;
		self.triView.alpha = 1;
		self.triView.center = CGPointMake(flushedPoint.x, flushedPoint.y);
		NSLog(@"before %@", affineTransformDescription(self.triView.transform));
		CGAffineTransform transform = CGAffineTransformRotate(self.triView.transform, h * DEG_TO_RAD);
		NSLog(@"after %@", affineTransformDescription(transform));
		self.triView.transform = transform;
		//[self setNeedsDisplay];
	}
}

NSString* affineTransformDescription(CGAffineTransform transform)
{
	// check if it's simply the identity matrix
	if (CGAffineTransformIsIdentity(transform)) {
		return @"Is the identity transform";
	}
	// the above does't catch things like a 720° rotation so also check it manually
	if (fabs(transform.a  - 1.0) < FLT_EPSILON &&
		fabs(transform.b  - 0.0) < FLT_EPSILON &&
		fabs(transform.c  - 0.0) < FLT_EPSILON &&
		fabs(transform.d  - 1.0) < FLT_EPSILON &&
		fabs(transform.tx - 0.0) < FLT_EPSILON &&
		fabs(transform.ty - 0.0) < FLT_EPSILON) {
		return @"Is the identity transform";
	}
	
	// The affine transforms is built up like this:
	
	// a b tx
	// c d ty
	// 0 0 1
	
	// An array to hold all the different descirptions, charasteristics of the transform.
	NSMutableArray *descriptions = [NSMutableArray array];
	
	// Checking for a translation
	if (fabs(transform.tx) > FLT_EPSILON) { // translation along X
		[descriptions addObject:[NSString stringWithFormat:@"Will move %.2f along the X axis",
								 transform.tx]];
	}
	if (fabs(transform.ty) > FLT_EPSILON) { // translation along Y
		[descriptions addObject:[NSString stringWithFormat:@"Will move %.2f along the Y axis",
								 transform.ty]];
	}
	
	
	// Checking for a rotation
	CGFloat angle = atan2(transform.b, transform.a); // get the angle of the rotation. Note this assumes no shearing!
	if (fabs(angle) < FLT_EPSILON || fabs(angle - M_PI) < FLT_EPSILON) {
		// there is a change that there is a 180° rotation, in that case, A and D will and be negative.
		BOOL bothAreNegative  = transform.a < 0.0 && transform.d < 0.0;
		
		if (bothAreNegative) {
			angle = M_PI;
		} else {
			angle = 0.0; // this is not considered a rotation, but a negative scale along one axis.
		}
	}
	
	// add the rotation description if there was an angle
	if (fabs(angle) > FLT_EPSILON) {
		[descriptions addObject:[NSString stringWithFormat:@"Will rotate %.1f° degrees",
								 angle*180.0/M_PI]];
	}
	
	
	// Checking for a scale (and account for the possible rotation as well)
	CGFloat scaleX = transform.a/cos(angle);
	CGFloat scaleY = transform.d/cos(angle);
	
	
	if (fabs(scaleX - scaleY) < FLT_EPSILON && fabs(scaleX - 1.0) > FLT_EPSILON) {
		// if both are the same then we can format things a little bit nicer
		[descriptions addObject:[NSString stringWithFormat:@"Will scale by %.2f along both X and Y",
								 scaleX]];
	} else {
		// otherwise we look at X and Y scale separately
		if (fabs(scaleX - 1.0) > FLT_EPSILON) { // scale along X
			[descriptions addObject:[NSString stringWithFormat:@"Will scale by %.2f along the X axis",
									 scaleX]];
		}
		
		if (fabs(scaleY - 1.0) > FLT_EPSILON) { // scale along Y
			[descriptions addObject:[NSString stringWithFormat:@"Will scale by %.2f along the Y axis",
									 scaleY]];
		}
	}
	
	// Return something else when there is nothing to say about the transform matrix
	if (descriptions.count == 0) {
		return @"Can't easilly be described.";
	}
	
	// join all the descriptions on their own line
	return [descriptions componentsJoinedByString:@",\n"];
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
