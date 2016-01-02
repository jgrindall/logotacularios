//
//  WelcomeViewController.m
//  LogotacularIOS
//
//  Created by John on 01/12/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WelcomeLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "Appearance.h"
#import "Assets.h"
#import "Colors.h"
#import "ImageUtils.h"

@interface WelcomeViewController ()

@property UIButton* button0;
@property UIButton* button1;
@property UIButton* button2;
@property UIButton* button3;
@property UILabel* label;
@property UILabel* subTitle;
@property UIView* top;
@end

@implementation WelcomeViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor whiteColor]];
	[self addButtons];
	[self addWelcomeLabel];
	[self layoutButtons];
	[self layoutLabel];
	[self layoutSubTitle];
}

- (void) addBg{
	//override
}

- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[self removeListeners];
}

- (void) addWelcomeLabel{
	self.label = [[UILabel alloc] init];
	self.label.font = [Appearance fontOfSize:SYMM_FONT_SIZE_LARGE];
	self.label.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:0.7];
	self.label.text = @"Welcome to Logotacular!";
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.alpha = 0.0;
	self.subTitle = [[UILabel alloc] init];
	self.subTitle.lineBreakMode = NSLineBreakByWordWrapping;
	self.subTitle.numberOfLines = 2;
	self.subTitle.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.subTitle.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.55];
	self.subTitle.text = @"An application for exploring geometry, algorithms,\nand coding, using the programming language 'Logo'";
	self.subTitle.textAlignment = NSTextAlignmentCenter;
	self.subTitle.alpha = 0.0;
	[self.view addSubview:self.label];
	[self.view addSubview:self.subTitle];
}

- (void) layoutSubTitle{
	self.subTitle.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* cy = [NSLayoutConstraint constraintWithItem:self.subTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-128.0];
	NSLayoutConstraint* cx = [NSLayoutConstraint constraintWithItem:self.subTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
	NSLayoutConstraint* w = [NSLayoutConstraint constraintWithItem:self.subTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
	NSLayoutConstraint* h = [NSLayoutConstraint constraintWithItem:self.subTitle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70];
	[self.view addConstraints:@[cx, cy, w, h]];
}

- (void) layoutLabel{
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* cy = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-205.0];
	NSLayoutConstraint* cx = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
	NSLayoutConstraint* w = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
	NSLayoutConstraint* h = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70];
	[self.view addConstraints:@[cx, cy, w, h]];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self addListeners];
	[self show];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void) showObject:(UIView*)v{
	[UIView animateWithDuration:0.4 animations:^{
		v.alpha = 1.0;
	}];
}

- (void) show{
	[self performSelector:@selector(showObject:) withObject:self.label afterDelay:0.0];
	[self performSelector:@selector(showObject:) withObject:self.subTitle afterDelay:1.00];
	[self performSelector:@selector(showObject:) withObject:self.button0 afterDelay:2.0];
	[self performSelector:@selector(showObject:) withObject:self.button1 afterDelay:2.75];
	[self performSelector:@selector(showObject:) withObject:self.button2 afterDelay:3.5];
	[self performSelector:@selector(showObject:) withObject:self.button3 afterDelay:4.25];
}

- (UIButton*) getBoxButton:(NSString*)label withIcon:(NSString*)icon withColor:(UIColor*)clr{
	UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
	b.frame = CGRectMake(100, 100, 300, 100);
	[b setTitle:label forState:UIControlStateNormal];
	[[b layer] setBorderWidth:0.0f];
	b.clipsToBounds = YES;
	b.layer.cornerRadius = WELCOME_LAYOUT_HEIGHT/2.0;
	b.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
	b.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
	[b.titleLabel setFont:[Appearance fontOfSize:SYMM_FONT_SIZE_BUTTON]];
	[b setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
	b.backgroundColor = clr;
	b.alpha = 0;
	return b;
}

- (void) addButtons{
	self.button0 = [self getBoxButton:@"About" withIcon:HELP_ICON withColor:[Colors getColorForString:@"red"]];
	self.button1 = [self getBoxButton:@"Tutorial" withIcon:BULB_ICON withColor:[Colors getColorForString:@"green"]];
	self.button2 = [self getBoxButton:@"Open a file" withIcon:BRIEFCASE_ICON withColor:[Colors getColorForString:@"blue"]];
	self.button3 = [self getBoxButton:@"Dive in!" withIcon:PLAY_ICON withColor:[Colors getColorForString:@"orange"]];
	[self.view addSubview:self.button0];
	[self.view addSubview:self.button1];
	[self.view addSubview:self.button2];
	[self.view addSubview:self.button3];
}

- (void) layoutButton:(UIButton*)b atPos:(int)i{
	int num = 4;
	float gap = (self.view.frame.size.width - num * WELCOME_LAYOUT_WIDTH)/(num + 1.0);
	b.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* cy = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:100.0];
	NSLayoutConstraint* cx = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:(i + 1)*gap + i*WELCOME_LAYOUT_WIDTH];
	NSLayoutConstraint* w = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:WELCOME_LAYOUT_WIDTH];
	NSLayoutConstraint* h = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:WELCOME_LAYOUT_HEIGHT];
	[self.view addConstraints:@[cx, cy, w, h]];
}

- (void) layoutButtons{
	[self layoutButton:self.button0 atPos:0];
	[self layoutButton:self.button1 atPos:1];
	[self layoutButton:self.button2 atPos:2];
	[self layoutButton:self.button3 atPos:3];
}

- (void) clickAbout{
	[self.delegate clickButtonAt:0 withPayload:nil];
}

- (void) clickEg{
	[self.delegate clickButtonAt:1 withPayload:nil];
}

- (void) clickDive{
	[self.delegate clickButtonAt:3 withPayload:nil];
}

- (void) clickFiles{
	[self.delegate clickButtonAt:2 withPayload:nil];
}

- (void) addListeners{
	[self.button0 addTarget:self action:@selector(clickAbout) forControlEvents:UIControlEventTouchUpInside];
	[self.button1 addTarget:self action:@selector(clickEg) forControlEvents:UIControlEventTouchUpInside];
	[self.button2 addTarget:self action:@selector(clickFiles) forControlEvents:UIControlEventTouchUpInside];
	[self.button3 addTarget:self action:@selector(clickDive) forControlEvents:UIControlEventTouchUpInside];
}

- (void) removeListeners{
	[self.button0 removeTarget:self action:@selector(clickAbout) forControlEvents:UIControlEventTouchUpInside];
	[self.button1 removeTarget:self action:@selector(clickEg) forControlEvents:UIControlEventTouchUpInside];
	[self.button2 removeTarget:self action:@selector(clickFiles) forControlEvents:UIControlEventTouchUpInside];
	[self.button3 removeTarget:self action:@selector(clickDive) forControlEvents:UIControlEventTouchUpInside];
}

- (void) dealloc{
	[self removeListeners];
}

@end


