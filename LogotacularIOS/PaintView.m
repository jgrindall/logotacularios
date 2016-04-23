//
//  PaintView.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PaintView.h"
#import "LinesView.h"
#import "Appearance.h"

@interface PaintView ()

@property UIView* bgView;
@property LinesView* linesView;
@property UIView* rect;

@end

@implementation PaintView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self addViews];
	}
	return self;
}

- (void) reset{
	[self.linesView reset];
}

- (void) drawTriangleAt:(CGPoint)p withHeading:(float) h withColor:(UIColor*)clr{
	[self.linesView drawTriangleAt:p withHeading:h withColor:clr];
}

- (void)hideTriangle{
	[self.linesView hideTriangle];
}

- (void) addViews{
	self.bgView = [[UIView alloc] initWithFrame:self.frame];
	self.bgView.backgroundColor = [Appearance bgColor];
	self.linesView = [[LinesView alloc] initWithFrame:self.frame];
	[self addSubview:self.bgView];
	[self addSubview:self.linesView];
}

- (void) onViewDidLoad{
	[self.linesView onViewDidLoad];
}

- (void) setFlushedTransform:(CGAffineTransform)t{
	self.linesView.flushedTransform = t;
}

- (void) flushTransformsWith:(CGAffineTransform)t{
	CGAffineTransform t0 = self.linesView.flushedTransform;
	[self setFlushedTransform:CGAffineTransformConcat(t0, t)];
}

- (void) drawLineFrom:(CGPoint)p0 to:(CGPoint)p1 withColor:(UIColor *)clr andThickness:(NSInteger)thickness{
	[self.linesView drawLineFrom:p0 to:p1 withColor:clr andThickness:thickness];
}

- (void)clickTriangle:(BOOL)hideTri{
	[self.linesView clickTriangle:hideTri];
}

- (void) drawTextAt:(CGPoint)p withColor:(UIColor*) clr andString:(NSString*)s {
	[self.linesView drawTextAt:p withColor:clr andString:s];
}

- (void) bg:(UIColor*)clr{
	[UIView animateWithDuration:0.25 animations:^{
		self.bgView.layer.backgroundColor = [clr CGColor];
	}];
}

- (void) transformWith:(CGAffineTransform)t{
	self.linesView.transform = t;
}

- (void) dealloc{
	[self.bgView removeFromSuperview];
	self.bgView = nil;
	[self.linesView removeFromSuperview];
	self.linesView = nil;
	[self.rect removeFromSuperview];
	self.rect = nil;
}

@end

