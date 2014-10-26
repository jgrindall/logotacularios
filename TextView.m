//
//  TextView.m
//  LogotacularIOS
//
//  Created by John on 26/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TextView.h"
#import "Appearance.h"

@interface TextView ()

@property UITextView* logoText;

@end

@implementation TextView

- (id) initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		[self setup];
	}
	return self;
}

- (void) layoutSubviews{
	
}

- (void) layoutText{
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self		attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self	attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) addText{
	self.backgroundColor = [UIColor purpleColor];
	self.logoText = [[UITextView alloc] initWithFrame:self.frame];
	[self addSubview:self.logoText];
	self.logoText.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) styleText{
	[self.logoText setFont:[Appearance monospaceFontOfSize:SYMM_FONT_SIZE_MED]];
	[self.logoText setEditable:YES];
	self.logoText.backgroundColor = [UIColor whiteColor];
	self.logoText.textColor = [UIColor blackColor];
	self.logoText.alpha = 1.0;
}

- (void) setup{
	[self addText];
	[self styleText];
	[self layoutText];
}

- (NSString*) getText{
	return [self.logoText text];
}

- (void) setText:(NSString*) text{
	
}

@end
