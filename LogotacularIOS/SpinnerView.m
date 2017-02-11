//
//  SpinnerView.m
//  Simitri
//
//  Created by John on 11/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SpinnerView.h"

@interface SpinnerView()

@property UIActivityIndicatorView* spinner;
@property UILabel* label;

@end

@implementation SpinnerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self addSubview:_spinner];
		[self layoutSpinner];
		self.alpha = 0.95;
		self.backgroundColor = [UIColor grayColor];
		[self.spinner startAnimating];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	int size = 125;
	CGContextRef ref = UIGraphicsGetCurrentContext();
	UIColor * __autoreleasing _color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.75];
	CGContextSetFillColorWithColor(ref, _color.CGColor);
	CGRect cellArea = CGRectMake((self.frame.size.width - size)/2, (self.frame.size.height - size)/2, size, size);
	UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect: cellArea cornerRadius: 10];
	CGContextAddPath(ref, roundedRect.CGPath);
	CGContextFillPath(ref);
}

- (void) layoutSpinner{
	self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-5];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:100];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:100];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.spinner stopAnimating];
	[self.spinner removeFromSuperview];
	self.spinner = nil;
}

@end
