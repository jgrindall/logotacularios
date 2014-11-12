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
#import "PMoreLessModel.h"
#import "PLogoErrorModel.h"

@interface ErrorPopUpViewController ()

@property UIButton* moreButton;
@property UIButton* lessButton;
@property UIButton* helpButton;
@property UILabel* label;
@property UILabel* moreLabel;

@end

@implementation ErrorPopUpViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	self.preferredContentSize = CGSizeMake(300, 200);
	[self addListeners];
	[self addButtons];
	[self layoutButtons];
	[self addText];
	[self layoutText];
	[self addMoreText];
	[self layoutMoreLabel];
	[self onMoreChanged];
}

- (void) addListeners{
	[[self getMoreModel] addListener:@selector(onMoreChanged) forKey:MORE_SHOWN withTarget:self];
}

- (void) removeListeners{
	[[self getMoreModel] removeListener:@selector(onMoreChanged) forKey:MORE_SHOWN withTarget:self];
}

- (void) onMoreChanged{
	BOOL show = [[[self getMoreModel] getVal:MORE_SHOWN] boolValue];
	self.lessButton.hidden = !show;
	self.moreButton.hidden = show;
	self.moreLabel.hidden = !show;
}

- (id<PMoreLessModel>)getMoreModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMoreLessModel)];
}

- (id<PLogoErrorModel>)getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (void) addText{
	self.label = [[UILabel alloc] initWithFrame:self.view.frame];
	self.label.text = @"There is an error on this line";
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.label];
	self.label.textColor = [UIColor whiteColor];
}

- (void) addMoreText{
	self.moreLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	self.moreLabel.text = @"No extra information";
	NSDictionary* error = [[self getErrorModel] getVal:LOGO_ERROR_ERROR];
	if(error && error[@"line"]){
		self.moreLabel.text = [NSString stringWithFormat:@"%@", error[@"line"]];
	}
	self.moreLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.moreLabel];
	self.moreLabel.textColor = [UIColor whiteColor];
}

- (void) addButtons{
	self.moreButton = [self getButton:ADD_ICON withAction:@selector(onClickMore)		withLabel:@"More"			];
	self.lessButton = [self getButton:LESS_ICON withAction:@selector(onClickLess)		withLabel:@"Less"			];
	self.helpButton = [self getButton:BULB_ICON withAction:@selector(onClickHelp)		withLabel:@"Go to help"		];
	[self.view addSubview:self.moreButton];
	[self.view addSubview:self.lessButton];
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

- (void) onClickMore{
	[[self getMoreModel] toggleBoolValForKey:MORE_SHOWN];
}

- (void) onClickLess{
	[[self getMoreModel] toggleBoolValForKey:MORE_SHOWN];
}

- (void) onClickHelp{
	
}

-(void)layoutText{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0]];
}

- (void) layoutMoreLabel{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0]];
}

- (void) layoutMore{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:120.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

- (void) layoutLess{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lessButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lessButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lessButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:120.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lessButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

- (void) layoutHelp{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.moreButton		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-15.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:150.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

-(void)layoutButtons{
	[self layoutMore];
	[self layoutLess];
	[self layoutHelp];
}

- (void) dealloc{
	[self removeListeners];
}
@end


