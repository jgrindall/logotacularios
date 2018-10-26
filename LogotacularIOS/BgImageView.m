//
//  PaintView.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BgImageView.h"
#import "Colors.h"

@interface BgImageView ()

@property UIImageView* imgView;
@end

@implementation BgImageView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_flushedTransform = CGAffineTransformIdentity;
		self.imgView = [[UIImageView alloc] initWithFrame:self.frame];
		self.imgView.image = [UIImage imageNamed:@"assets/bg.jpg"];
		[self addSubview:self.imgView];
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void) reset{
	[self setNeedsDisplay];
}

- (void) setTransformWith:(CGAffineTransform)t{
	self.transform = CGAffineTransformConcat(self.flushedTransform, t);
}

- (void) onViewDidLoad{
	
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
	
}

- (void) dealloc{
	
}

@end
