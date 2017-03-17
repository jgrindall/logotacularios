//
//  AbstractHelpPageViewController.m
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractHelpPageViewController_protected.h"
#import "AbstractHelpViewController.h"
#import "Appearance.h"
#import "HelpSectionViewController.h"

@interface AbstractHelpPageViewController ()

@property NSInteger numPages;
@property NSInteger startPage;
@property Class childClass;
@property UIImageView* imgView;

@end

@implementation AbstractHelpPageViewController

- (instancetype)initWithChildClass:(Class) childClass andNumPages:(NSInteger)numPages andStartPage:(NSInteger)startPage{
	self = [super init];
	if(self){
		_numPages = numPages;
		_childClass = childClass;
		_startPage = startPage;
		if(_startPage < 0){
			_startPage = 0;
		}
		if(_startPage >= numPages){
			_startPage = numPages - 1;
		}
	}
	return self;
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutPages];
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addContainer];
	[self makeController];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self layoutPages];
}

- (void) makeController{
	self.helpViewController = [[AbstractHelpViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil withChildClass:self.childClass andNumPages:self.numPages andStartPage:self.startPage];
	[self addChildInto:self.helpContainer withController:self.helpViewController];
}

- (void) addContainer{
	self.helpContainer = [[UIView alloc] initWithFrame:self.view.frame];
	self.helpContainer.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.helpContainer];
}

-(void)layoutPages{
	self.helpContainer.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide		attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) dealloc{
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	self.childClass = nil;
}

@end
