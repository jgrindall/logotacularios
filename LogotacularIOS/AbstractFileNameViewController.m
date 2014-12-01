//
//  AbstractFileNameViewController.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractFileNameViewController.h"
#import "FilenameViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "SymmNotifications.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"
#import "Appearance.h"

@interface AbstractFileNameViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* nameField;

@end

@implementation AbstractFileNameViewController


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
	self.nameField.textColor = [UIColor whiteColor];
	self.nameField.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.nameField.translatesAutoresizingMaskIntoConstraints = NO;
	self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.nameField.textAlignment = NSTextAlignmentCenter;
	self.nameField.delegate = self;
	self.nameField.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
	[self.panel addSubview:self.nameField];
}

- (void) addButtons{
	NSArray* buttonLabels = ((NSDictionary*)self.options)[@"buttons"];
	self.okButton = [self getButton:buttonLabels[1] withAction:@selector(onClickOk)			withLabel:buttonLabels[0]		];
	self.cancelButton = [self getButton:buttonLabels[3] withAction:@selector(onClickCancel)	withLabel:buttonLabels[2]		];
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

- (void) dealloc{
	[self.okButton removeTarget:self action:@selector(onClickOk) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton removeTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
	[self.okButton removeFromSuperview];
	self.okButton = nil;
	[self.cancelButton removeFromSuperview];
	self.cancelButton = nil;
	[self.nameField removeFromSuperview];
	self.nameField = nil;
}

@end
