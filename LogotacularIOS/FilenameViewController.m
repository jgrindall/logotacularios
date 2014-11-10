//
//  FilenameViewController.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FilenameViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "SymmNotifications.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"
#import "Appearance.h"
#import "PLogoAlertDelegate.h"

@interface FilenameViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* nameField;

@end

@implementation FilenameViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addButtons];
	[self addText];
	[self layoutButtons];
	[self layoutText];
}

- (void) addText{
	self.nameField = [[UITextField alloc] initWithFrame:self.view.frame];
	self.nameField.keyboardType = UIKeyboardTypeAlphabet;
	self.nameField.translatesAutoresizingMaskIntoConstraints = NO;
	self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.nameField.textAlignment = NSTextAlignmentCenter;
	self.nameField.delegate = self;
	self.nameField.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
	[self.panel addSubview:self.nameField];
}

- (void) addButtons{
	self.okButton = [self getButton:self.buttonLabels[1] withAction:@selector(onClickOk)			withLabel:self.buttonLabels[0]		atNum:0];
	self.cancelButton = [self getButton:self.buttonLabels[3] withAction:@selector(onClickCancel)	withLabel:self.buttonLabels[2]		atNum:1];
	[self.panel addSubview:self.okButton];
	[self.panel addSubview:self.cancelButton];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
	
}

- (BOOL) validateText{
	NSString* text = self.nameField.text;
	NSError* error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n]+" options:NSRegularExpressionCaseInsensitive error:&error];
	NSString* modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
	return ([text length] <= 16 && [modifiedString length] >= 2);
}

- (void) onClickOk{
	if([self validateText]){
		[self.delegate clickButtonAt:0 withPayload:self.nameField.text];
	}
	else{
		[self validateError];
	}
}

- (void)fileNameUsedError{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getFileNameTakenMessage] withType:TSMessageNotificationTypeError];
	[ImageUtils shakeView:self.panel];
}

- (void) validateError{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getFileNameInvalidMessage] withType:TSMessageNotificationTypeError];
	[ImageUtils shakeView:self.panel];
}

- (void) onClickCancel{
	[self.delegate clickButtonAt:1 withPayload:nil];
}

-(void)layoutText{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:160.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
}

- (void) layoutOk{
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
