//
//  AbstractOverlayController.m
//  LogotacularIOS
//
//  Created by John on 01/12/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractOverlayController_protected.h"
#import "Colors.h"
#import "Appearance.h"

@implementation AbstractOverlayController

-(void)layoutBg{
	if(self.bg){
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	}
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutBg];
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addBg];
}

- (void) addBg{
	self.bg = [[UIView alloc] initWithFrame:self.view.frame];
	self.bg.translatesAutoresizingMaskIntoConstraints = NO;
	self.bg.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.5];
	[self.view addSubview:self.bg];
}

@end
