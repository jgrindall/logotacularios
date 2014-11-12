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

@property UIButton* yesButton;
@property UIButton* noButton;

@end

@implementation SaveCurrentViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addButtons];
	[self layoutButtons];
}

- (void) addButtons{
	self.yesButton = [self getButton:self.buttonLabels[1] withAction:@selector(onClickYes)	withLabel:self.buttonLabels[0]		];
	self.noButton = [self getButton:self.buttonLabels[3] withAction:@selector(onClickNo)	withLabel:self.buttonLabels[2]		];
	[self.panel addSubview:self.yesButton];
	[self.panel addSubview:self.noButton];
}

- (void) onClickYes{
	[self.delegate clickButtonAt:0 withPayload:nil];
}

- (void) error{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeError];
	[ImageUtils shakeView:self.panel];
}

- (void) onClickNo{
	[self.delegate clickButtonAt:1 withPayload:nil];
}

-(void) layoutYes{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.panel			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.panel		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:120.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

- (void) layoutNo{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.panel			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.yesButton		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-15.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:120.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

-(void)layoutButtons{
	[self layoutYes];
	[self layoutNo];
}


@end
