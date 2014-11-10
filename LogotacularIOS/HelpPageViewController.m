//
//  HelpPageViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpPageViewController.h"
#import "HelpViewController.h"

@interface HelpPageViewController ()

@property UIView* helpContainer;
@property HelpViewController* helpViewController;

@end

@implementation HelpPageViewController

- (id)init{
	self = [super init];
	if(self){
		
	}
	return self;
}

- (void) viewDidLoad:(BOOL)animated{
	[self addPages];
	[self layoutPages];
}

- (void) addPages{
	self.helpContainer = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:self.helpContainer];
	self.helpViewController = [[HelpViewController alloc] init];
	[self addChildInto:self.helpContainer withController:self.helpViewController];
	self.helpContainer.backgroundColor = [UIColor greenColor];
}

-(void)layoutPages{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide		attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

@end

