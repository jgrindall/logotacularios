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
#import "Assets.h"
#import "SymmNotifications.h"
#import "ImageUtils.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"

@interface FilenameViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* nameField;
@property UIView* bg;
@property UIView* panel;

@end

@implementation FilenameViewController

- (void) viewDidLoad{
	[self addBg];
	[self addPanel];
	[self addButtons];
	[self addText];
	[self layoutBg];
	[self layoutButtons];
	[self layoutPanel];
	[self layoutText];
	[self addListeners];
	[self showPanel];
}

- (void) addBg{
	self.bg = [[UIView alloc] initWithFrame:self.view.frame];
	self.bg.translatesAutoresizingMaskIntoConstraints = NO;
	self.bg.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
	[self.view addSubview:self.bg];
}

- (void) showPanel{
	[self show];
}

- (void) addPanel{
	self.panel = [[UIView alloc] initWithFrame:self.view.frame];
	self.panel.translatesAutoresizingMaskIntoConstraints = NO;
	self.panel.backgroundColor = [UIColor colorWithRed:(52.0/255.0) green:(73.0/255.0) blue:(94.0/255.0) alpha:1];
	[self.view addSubview:self.panel];
}

- (void) addText{
	self.nameField = [[UITextField alloc] initWithFrame:CGRectZero];
	self.nameField.translatesAutoresizingMaskIntoConstraints = NO;
	self.nameField.textAlignment = NSTextAlignmentCenter;
	self.nameField.delegate = self;
	self.nameField.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
	[self.panel addSubview:self.nameField];
}

- (void) addButtons{
	self.okButton = [self getButton:TICK_ICON withAction:@selector(onClickOk)			withLabel:@" Ok"		atNum:0];
	self.cancelButton = [self getButton:CLEAR_ICON withAction:@selector(onClickCancel)	withLabel:@" Cancel"	atNum:1];
	[self.panel addSubview:self.okButton];
	[self.panel addSubview:self.cancelButton];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
	
}

- (BOOL) validateText{
	NSString* text = self.nameField.text;
	return ([text length] >= 2);
}

- (void) onClickOk{
	if([self validateText]){
		[self bubbleSelector:@"fileOk:" withObject:self.nameField.text];
	}
	else{
		[self error];
	}
}

- (void) error{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeSuccess];
	[ImageUtils shakeView:self.panel];
}

- (void) onClickCancel{
	[self bubbleSelector:@"fileCancel" withObject:nil];
}

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label atNum:(int)num{
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	[btn setImage:img forState:UIControlStateNormal];
	[btn setTitle:label forState:UIControlStateNormal];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	btn.translatesAutoresizingMaskIntoConstraints = NO;
	return btn;
}

- (void) addListeners{

}

- (void) show{
	float y0 = -self.panel.frame.size.height/2;;
	float y1 = self.panel.frame.size.height/2;
	[ImageUtils bounceAnimateView:self.panel from:y0 to:y1 withKeyPath:@"position.y" withKey:@"panelBounce" withDelegate:nil withDuration:0.3 withImmediate:NO];
}

- (void) removeListeners{
	
}

-(void)layoutBg{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

-(void)layoutPanel{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:300.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:200.0]];
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
	[self removeListeners];
}

@end
