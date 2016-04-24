//
//  AbstractFileNameViewController.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ParentGateViewController.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"
#import "Appearance.h"
#import "ImageUtils.h"

@interface ParentGateViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* ansField;

@end

@implementation ParentGateViewController


- (void) viewDidLoad{
	[super viewDidLoad];
	[self addButtons];
	[self addText];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutButtons];
	[self layoutText];
}

- (void) addText{
	self.ansField = [[UITextField alloc] initWithFrame:self.view.frame];
	self.ansField.keyboardType = UIKeyboardTypeAlphabet;
	self.ansField.textColor = [UIColor whiteColor];
	self.ansField.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.ansField.translatesAutoresizingMaskIntoConstraints = NO;
	self.ansField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.ansField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.ansField.textAlignment = NSTextAlignmentCenter;
	self.ansField.delegate = self;
	self.ansField.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
	[self.panel addSubview:self.ansField];
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
	NSString* text = self.ansField.text;
	NSError* error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ \t\r\n]+" options:NSRegularExpressionCaseInsensitive error:&error];
	NSString* modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
	return ([text length] <= 16 && [modifiedString length] >= 2);
}

- (void) onClickOk{
	if([self validateText]){
		[self.delegate clickButtonAt:0 withPayload:self.ansField.text];
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
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:160.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
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
	[self.ansField removeFromSuperview];
	self.ansField = nil;
}

@end
