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
#import "AlertLayout.h"
#import "Assets.h"

@interface ParentGateViewController ()

@property UIButton* okButton;
@property UIButton* cancelButton;
@property UITextField* ansField;
@property UILabel* msgLabel;
@property UIButton* facebookButton;
@property UIButton* twitterButton;
@property UIButton* emailButton;
@property NSInteger ans;
@property BOOL answered;
@end

@implementation ParentGateViewController


- (void) viewDidLoad{
	[super viewDidLoad];
	self.answered = NO;
	[self addButtons];
	[self addText];
	[self addMessage];
	[self addSocialButtons];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutButtons];
	[self layoutText];
	[self layoutMessage];
	[self layoutSocial];
}

- (CGSize) getPanelSize{
	return CGSizeMake(ALERT_LAYOUT_LARGE_WIDTH, ALERT_LAYOUT_LARGE_HEIGHT);
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
	self.ansField.delegate = self;
	self.ansField.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
	[self.panel addSubview:self.ansField];
}

- (void) addMessage{
	int lowerBound = 99;
	int upperBound = 1000;
	int rndValue1 = (int)(lowerBound + arc4random() % (upperBound - lowerBound));
	int rndValue2 = (int)(lowerBound + arc4random() % (upperBound - lowerBound));
	self.msgLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	self.msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.msgLabel.backgroundColor = [UIColor clearColor];
	self.msgLabel.textColor = [UIColor whiteColor];
	self.msgLabel.textAlignment = NSTextAlignmentCenter;
	self.msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.msgLabel.numberOfLines = 0;
	self.msgLabel.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MSG];
	NSString* sum = [NSString stringWithFormat:@"Please confirm you are an adult by typing in the answer to the sum %i + %i below and pressing 'Ok'.", rndValue1, rndValue2];
	self.msgLabel.text = sum;
	self.ans = rndValue1 + rndValue2;
	[self.panel addSubview:self.msgLabel];
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
	text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	int ans = [text intValue];
	return (ans == self.ans);
}

- (void) onClickOk{
	if(self.answered){
		[self.delegate clickButtonAt:0 withPayload:self.ansField.text];
	}
	else{
		if([self validateText]){
			[self onCorrect];
		}
		else{
			[self validateError];
		}
	}
}

- (void) onCorrect{
	self.answered = YES;
	[self.ansField resignFirstResponder];
	self.titleLabel.text = @"Choose where to share your work:";
	[self hideButtons];
	[self showSocialButtons];
}

- (void) hideButtons{
	self.msgLabel.alpha = 0;
	self.ansField.alpha = 0;
	self.okButton.alpha = 0;
}

-(void) addSocialButtons{
	self.facebookButton = [self getButton:FACEBOOK_ICON withAction:@selector(onClickFacebook)			withLabel:@"Facebook"		];
	self.twitterButton = [self getButton:TWITTER_ICON withAction:@selector(onClickTwitter)			withLabel:@"Twitter"		];
	self.emailButton = [self getButton:EMAIL_ICON withAction:@selector(onClickEmail)			withLabel:@"Email"		];
	[self.panel addSubview:self.facebookButton];
	[self.panel addSubview:self.twitterButton];
	[self.panel addSubview:self.emailButton];
	self.facebookButton.backgroundColor = [UIColor clearColor];
	self.twitterButton.backgroundColor = [UIColor clearColor];
	self.emailButton.backgroundColor = [UIColor clearColor];
	self.facebookButton.alpha = 0;
	self.twitterButton.alpha = 0;
	self.emailButton.alpha = 0;
}

- (void) showSocialButtons{
	self.facebookButton.alpha = 1;
	self.twitterButton.alpha = 1;
	self.emailButton.alpha = 1;
}

- (void) onClickFacebook{
	[self.delegate clickButtonAt:2 withPayload:@"facebook"];
}

- (void) onClickTwitter{
	[self.delegate clickButtonAt:2 withPayload:@"twitter"];
}

- (void) onClickEmail{
	[self.delegate clickButtonAt:2 withPayload:@"email"];
}

- (void) validateError{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getParentalGateInvalidMessage] withType:TSMessageNotificationTypeError];
	[ImageUtils shakeView:self.panel];
}

- (void) onClickCancel{
	[self.delegate clickButtonAt:1 withPayload:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)layoutSocial{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeTop multiplier:1.0 constant:55.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeTop multiplier:1.0 constant:105.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeTop multiplier:1.0 constant:155.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emailButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
}

-(void)layoutText{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:160.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.ansField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
}

- (void) layoutMessage{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.msgLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeTop multiplier:1.0 constant:50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.msgLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.msgLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.msgLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:100.0]];
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
	[self.facebookButton removeTarget:self action:@selector(onClickFacebook) forControlEvents:UIControlEventTouchUpInside];
	[self.twitterButton removeTarget:self action:@selector(onClickTwitter) forControlEvents:UIControlEventTouchUpInside];
	[self.emailButton removeTarget:self action:@selector(onClickEmail) forControlEvents:UIControlEventTouchUpInside];
	[self.okButton removeFromSuperview];
	self.okButton = nil;
	[self.cancelButton removeFromSuperview];
	self.cancelButton = nil;
	[self.ansField removeFromSuperview];
	self.ansField = nil;
	[self.facebookButton removeFromSuperview];
	self.facebookButton = nil;
	[self.twitterButton removeFromSuperview];
	self.twitterButton = nil;
	[self.emailButton removeFromSuperview];
	self.emailButton = nil;
}

@end
