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

@property CGPoint pos;
@property float heading;
@property UIView* bgView;
@property UIImageView* blurView;
@property UIImageView* catView;
@property LinesView* linesView;

@end

@implementation PaintView

CGContextRef cacheContext;

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self initTurtle];
		[self addViews];
	}
	return self;
}

- (void) reset{
	[self initTurtle];
	[self.linesView reset];
}

- (void) initTurtle{
	self.pos = CGPointMake(300, 250);
	self.heading = 90;
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

- (void) execute:(NSDictionary*) data{
	NSString* name = data[@"name"];
	NSNumber* amount = data[@"amount"];
	if([name isEqualToString:@"fd"]){
		[self drawLine:amount];
	}
	else if([name isEqualToString:@"rt"]){
		[self turn:amount];
	}
}

- (void) turn:(NSNumber*) amount{
	self.heading += [amount floatValue];
}

- (void) drawLine:(NSNumber*) amount{
	float dx = cosf(self.heading*3.14159/180) * [amount floatValue];
	float dy = sinf(self.heading*3.14159/180) * [amount floatValue];
	CGPoint newPoint = CGPointMake(self.pos.x + dx, self.pos.y + dy);
	UIColor* lineColor = [UIColor colorWithRed:(11.0/255.0) green:(76.0/255.0) blue:(60.0/255.0) alpha:1];
	[self.linesView drawLineFrom:self.pos to:newPoint withColor:lineColor andThickness:3];
	self.pos = CGPointMake(newPoint.x, newPoint.y);
}

@end
