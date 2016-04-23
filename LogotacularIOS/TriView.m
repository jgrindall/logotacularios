//
//  TriView
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TriView.h"
#import "Appearance.h"

@interface TriView ()

@property float heading;
@property float scale;
@property UIColor* color;

@end

@implementation TriView

const float DEG_TO_RAD =	M_PI/180.0f;
const float	THETA =			130.0f;
float const TRI_RADIUS =	18.0f;
float const DARKEN =		0.1f;
float const ALPHA =			1.0f;
int const	THICK =			3;

CGPoint p0, p1, p2;

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.color = [UIColor blackColor];
		int r = TRI_RADIUS - 1;
		p0 = CGPointMake(r, 0);
		p1 = CGPointMake(r*cosf(DEG_TO_RAD*THETA), r*sinf(DEG_TO_RAD*THETA));
		p2 = CGPointMake(p1.x, -p1.y);
	}
	return self;
}

- (void) drawWithSize: (float)s withHeading:(float) h withColor:(UIColor*)clr{
	self.heading = h;
	self.color = clr;
	self.scale = MAX(0.5, MIN(s, 1));
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0;
	[self.color getRed:&r green:&g blue:&b alpha:&a];
	UIColor* alphaColor = [UIColor colorWithRed:MAX(r - DARKEN, 0.0) green:MAX(g - DARKEN, 0.0) blue:MAX(b - DARKEN, 0.0) alpha:ALPHA];
	CGContextSetStrokeColorWithColor(context, [alphaColor CGColor]);
	int thick = (int)(self.scale * THICK);
	thick = MAX(1, thick);
	CGContextSetLineWidth(context, thick);
	CGContextSetLineCap(context, kCGLineCapRound);
	float cosHeading = cosf(self.heading * DEG_TO_RAD);
	float sinHeading = sinf(-self.heading * DEG_TO_RAD);
	CGPoint p0Dash = CGPointMake(cosHeading * p0.x + sinHeading * p0.y, -sinHeading * p0.x + cosHeading * p0.y);
	CGPoint p1Dash = CGPointMake(cosHeading * p1.x + sinHeading * p1.y, -sinHeading * p1.x + cosHeading * p1.y);
	CGPoint p2Dash = CGPointMake(cosHeading * p2.x + sinHeading * p2.y, -sinHeading * p2.x + cosHeading * p2.y);
	p0Dash = CGPointMake(p0Dash.x * self.scale, p0Dash.y * self.scale);
	p1Dash = CGPointMake(p1Dash.x * self.scale, p1Dash.y * self.scale);
	p2Dash = CGPointMake(p2Dash.x * self.scale, p2Dash.y * self.scale);
	
	p0Dash = CGPointMake(p0Dash.x + TRI_RADIUS, p0Dash.y + TRI_RADIUS);
	p1Dash = CGPointMake(p1Dash.x + TRI_RADIUS, p1Dash.y + TRI_RADIUS);
	p2Dash = CGPointMake(p2Dash.x + TRI_RADIUS, p2Dash.y + TRI_RADIUS);
	CGContextMoveToPoint(context, p0Dash.x, p0Dash.y);
	CGContextAddLineToPoint(context, p1Dash.x, p1Dash.y);
	CGContextAddLineToPoint(context, p2Dash.x, p2Dash.y);
	CGContextAddLineToPoint(context, p0Dash.x, p0Dash.y);
	CGContextDrawPath(context, kCGPathStroke);
}

- (void) dealloc{
	
}

@end
