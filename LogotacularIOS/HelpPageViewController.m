//
//  HelpPageViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpPageViewController.h"
#import "HelpViewController.h"
#import "Appearance.h"

@interface HelpPageViewController ()

@property UIView* helpContainer;
@property HelpViewController* helpViewController;

@end

@implementation HelpPageViewController

- (instancetype)init{
	self = [super init];
	if(self){
		
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addPages];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self layoutPages];
}

- (void) addPages{
	self.helpContainer = [[UIView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.helpContainer];
	self.helpViewController = [[HelpViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	[self addChildInto:self.helpContainer withController:self.helpViewController];
	self.helpContainer.backgroundColor = [Appearance bgColor];
}

-(void)layoutPages{
	self.helpContainer.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide		attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

@end

