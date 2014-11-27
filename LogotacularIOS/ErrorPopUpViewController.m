//
//  ErrorPopUpViewController.m
//  LogotacularIOS
//
//  Created by John on 12/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ErrorPopUpViewController.h"
#import "FilenameViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "SymmNotifications.h"
#import <TSMessages/TSMessageView.h>
#import "ToastUtils.h"
#import "Appearance.h"
#import "PLogoAlertDelegate.h"
#import "Assets.h"
#import "PLogoErrorModel.h"
#import "ErrorObject.h"
#import "AlertLayout.h"

@interface ErrorPopUpViewController ()

@property UIButton* helpButton;
@property UILabel* label;
@property UILabel* moreLabel;

@end

@implementation ErrorPopUpViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	self.preferredContentSize = CGSizeMake(ALERT_LAYOUT_WIDTH, ALERT_LAYOUT_HEIGHT);
	[self addButtons];
	[self layoutButtons];
	[self addText];
	[self layoutText];
	[self addMoreText];
	[self layoutMoreLabel];
}

- (id<PLogoErrorModel>)getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (void) addText{
	self.label = [[UILabel alloc] initWithFrame:self.view.frame];
	self.label.text = @"There is an error in your program";
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.label];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.textColor = [UIColor whiteColor];
}

- (void) addMoreText{
	self.moreLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	self.moreLabel.text = @"No extra information";
	self.moreLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.moreLabel.numberOfLines = 0;
	ErrorObject* errorObj = (ErrorObject*)[[self getErrorModel] getVal:LOGO_ERROR_ERROR];
	if(errorObj){
		self.moreLabel.text = [errorObj getHumanMessage];
	}
	self.moreLabel.backgroundColor = [UIColor clearColor];
	self.moreLabel.textAlignment = NSTextAlignmentCenter;
	self.moreLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.moreLabel];
	self.moreLabel.textColor = [UIColor whiteColor];
}

- (void) addButtons{
	self.helpButton = [self getButton:BOOK_ICON withAction:@selector(onClickHelp)		withLabel:@"Go to help"		];
	[self.view addSubview:self.helpButton];
}

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label {
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

- (void) onClickHelp{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_HELP withData:nil];
}

-(void)layoutText{
	float p = 5;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeft multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-2*p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

- (void) layoutMoreLabel{
	float p = 5;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeft multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-2*p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.helpButton		attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

- (void) layoutHelp{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

-(void)layoutButtons{
	[self layoutHelp];
}

- (void) dealloc{
	
}

@end


