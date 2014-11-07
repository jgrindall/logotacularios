//
//  SaveCurrentViewController.m
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SaveCurrentViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "Assets.h"
#import "SymmNotifications.h"
#import "ImageUtils.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"
#import "Appearance.h"
#import "PLogoAlertDelegate.h"

@interface SaveCurrentViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* nameField;

@end

@implementation SaveCurrentViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addButtons];
	[self layoutButtons];
}

- (void) addButtons{
	self.okButton = [self getButton:TICK_ICON withAction:@selector(onClickOk)			withLabel:@" Ok"		atNum:0];
	self.cancelButton = [self getButton:CLEAR_ICON withAction:@selector(onClickCancel)	withLabel:@" Cancel"	atNum:1];
	[self.panel addSubview:self.okButton];
	[self.panel addSubview:self.cancelButton];
}

- (void) onClickOk{
	[self.delegate clickButtonAt:0 withPayload:nil];
}

- (void) error{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeError];
	[ImageUtils shakeView:self.panel];
}

- (void) onClickCancel{
	[self.delegate clickButtonAt:1 withPayload:nil];
}

-(void) layoutOk{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.panel			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.panel			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:120.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

- (void) layoutCancel{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.panel			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.okButton		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-15.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:120.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

-(void)layoutButtons{
	[self layoutOk];
	[self layoutCancel];
}


@end
