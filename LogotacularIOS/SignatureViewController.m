//
//  AbstractFileNameViewController.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SignatureViewController.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"
#import "Appearance.h"
#import "ImageUtils.h"
#import "AlertLayout.h"
#import "Assets.h"

@interface SignatureViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* ansField;
@property UILabel* msgLabel;
@property UISwitch* switchButton;
@property BOOL addSignature;
@end

@implementation SignatureViewController


- (void) viewDidLoad{
	[super viewDidLoad];
	self.addSignature = NO;
	[self addButtons];
	[self addText];
	[self updateState];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutButtons];
	[self layoutText];
	[self loadState];
}
	 
- (void) loadState{
	BOOL showName = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowSignature"];
	NSString* name = (NSString*)[[NSUserDefaults standardUserDefaults] valueForKey:@"Signature"];
	if(showName == YES){
		[self.switchButton setOn:showName];
	}
	if(name && name.length >= 1){
		[self.ansField setText:name];
	}
	else{
		[self.ansField setText:@""];
	}
	[self updateState];
}

- (void) saveState{
	NSString* state = @"NO";
	if(self.switchButton.on){
		state = @"YES";
	}
	[[NSUserDefaults standardUserDefaults] setObject:state forKey:@"ShowSignature"];
	[[NSUserDefaults standardUserDefaults] setObject:self.ansField.text forKey:@"Signature"];
}

- (CGSize) getPanelSize{
	return CGSizeMake(ALERT_LAYOUT_WIDTH, ALERT_LAYOUT_HEIGHT);
}

- (void) addText{
	self.ansField = [[UITextField alloc] initWithFrame:self.view.frame];
	self.ansField.keyboardType = UIKeyboardTypeNumberPad;
	self.ansField.textColor = [UIColor whiteColor];
	self.ansField.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.ansField.translatesAutoresizingMaskIntoConstraints = NO;
	self.ansField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.ansField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.ansField.textAlignment = NSTextAlignmentCenter;
	self.ansField.placeholder = @"My name";
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
	self.switchButton = [[UISwitch alloc] init];
	[self.panel addSubview:self.switchButton];
	[self.switchButton setOnTintColor:[UIColor colorWithRed:200 green:200 blue:200 alpha:0.5]];
	[self.switchButton addTarget:self action:@selector(updateState) forControlEvents:UIControlEventValueChanged];
	self.switchButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
	
}

- (void) onClickOk{
	[self saveState];
	[self.delegate clickButtonAt:2 withPayload:@{@"show":[NSNumber numberWithBool:self.switchButton.on], @"name":self.ansField.text}];
}

- (void) onClickCancel{
	[self.delegate clickButtonAt:1 withPayload:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void) updateState{
	BOOL state = self.switchButton.on;
	self.ansField.enabled = state;
	self.ansField.alpha = state ? 1 : 0.25;
}

-(void)layoutText{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:25.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:200.0]];
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

- (void) layoutSwitch{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:35.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

-(void)layoutButtons{
	[self layoutOk];
	[self layoutCancel];
	[self layoutSwitch];
}

- (void) dealloc{
	[self.okButton removeTarget:self action:@selector(onClickOk) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton removeTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
	[self.switchButton removeTarget:self action:@selector(update) forControlEvents:UIControlEventValueChanged];
	[self.okButton removeFromSuperview];
	self.okButton = nil;
	[self.cancelButton removeFromSuperview];
	self.cancelButton = nil;
	[self.ansField removeFromSuperview];
	self.ansField = nil;
}

@end
