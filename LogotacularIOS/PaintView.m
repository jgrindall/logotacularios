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
@property UIImageView* blurView;
@property UIImageView* catView;
@property LinesView* linesView;
@property UIView* rect;

@end

@implementation PaintView

CGContextRef cacheContext;

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

- (void) addViews{
	self.bgView = [[UIView alloc] initWithFrame:self.frame];
	self.bgView.backgroundColor = [Appearance bgColor];
	self.blurView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"assets/blur.png"]];
	self.linesView = [[LinesView alloc] initWithFrame:self.frame];
	[self addSubview:self.bgView];
	[self addSubview:self.blurView];
	[self addSubview:self.linesView];
	self.blurView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void) drawLineFrom:(CGPoint)p0 to:(CGPoint)p1 withColor:(UIColor *)clr andThickness:(NSInteger)thickness{
	[self.linesView drawLineFrom:p0 to:p1 withColor:clr andThickness:thickness];
}

- (void) bg:(UIColor*)clr{
	[UIView animateWithDuration:0.25 animations:^{
		self.bgView.layer.backgroundColor = [clr CGColor];
	}];
}

- (void) transformWith:(CGAffineTransform)t{
	self.linesView.transform = t;
}

@end

