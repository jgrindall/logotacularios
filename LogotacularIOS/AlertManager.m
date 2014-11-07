//
//  AlertManager.m
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlertManager.h"
#import "FilenameViewController.h"
#import "AbstractAlertController.h"

@interface AlertManager ()

+ (UIView*) container;
+ (AbstractAlertController*) alertController;
+ (AContainerViewController*) parent;

@end

@implementation AlertManager

static UIView* _container = nil;
static AbstractAlertController* _alertController = nil;
static AContainerViewController* _parent = nil;

+ (AContainerViewController*) parent{
	return _parent;
}

+ (AbstractAlertController*) alertController{
	return _alertController;
}

+ (UIView*) container{
	return _container;
}

+ (AbstractAlertController*) addAlert:(Class) class intoController:(AContainerViewController*) controller withDelegate:(id<PLogoAlertDelegate>)delegate withOptions:(id)options{
	_parent = controller;
	_container = [[UIView alloc] initWithFrame:_parent.view.frame];
	_alertController = [[class alloc] init];
	_alertController.delegate = delegate;
	_alertController.options = options;
	[_parent.view addSubview:_container];
	[_parent addChildInto:_container withController:_alertController];
	[_parent.view addConstraint:[NSLayoutConstraint constraintWithItem:_container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_parent.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[_parent.view addConstraint:[NSLayoutConstraint constraintWithItem:_container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_parent.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[_parent.view addConstraint:[NSLayoutConstraint constraintWithItem:_container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_parent.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[_parent.view addConstraint:[NSLayoutConstraint constraintWithItem:_container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_parent.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	return _alertController;
}

+ (void) removeAlert{
	[_parent removeChildFrom:_container withController:_alertController];
	[_container removeFromSuperview];
	_container = nil;
	_alertController = nil;
}

@end
