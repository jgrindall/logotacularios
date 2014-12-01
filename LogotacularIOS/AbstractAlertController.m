//
//  AbstractAlertController.m
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractAlertController_protected.h"
#import "Appearance.h"
#import "ImageUtils.h"
#import "AlertLayout.h"
#import "Colors.h"

@implementation AbstractAlertController

- (void) viewDidLoad{
	[super viewDidLoad];
	self.buttonLabels = ((NSDictionary*)self.options)[@"buttons"];
	self.titleText = ((NSDictionary*)self.options)[@"title"];
	[self addListeners];
	[self addBg];
	[self addPanel];
	[self addTitle];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutBg];
	[self layoutPanel:0];
	[self layoutTitle];
	[self show];
}

-(void)layoutTitle{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.panel						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.panel					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil							attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.panel				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

-(void)layoutBg{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

-(void)layoutPanel:(float)dy{
	if(self.panelConstraints && [self.panelConstraints count] >= 1){
		[self.view removeConstraints:self.panelConstraints];
	}
	NSLayoutConstraint* cy = [NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:dy];
	NSLayoutConstraint* cx = [NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
	NSLayoutConstraint* w = [NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ALERT_LAYOUT_WIDTH];
	NSLayoutConstraint* h = [NSLayoutConstraint constraintWithItem:self.panel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ALERT_LAYOUT_HEIGHT];
	[self.view addConstraint:cx];
	[self.view addConstraint:cy];
	[self.view addConstraint:w];
	[self.view addConstraint:h];
	self.panelConstraints = @[cx, cy, w, h];
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

- (void) addBg{
	self.bg = [[UIView alloc] initWithFrame:self.view.frame];
	self.bg.translatesAutoresizingMaskIntoConstraints = NO;
	self.bg.backgroundColor = [Colors darken:[Appearance grayColor]];
	[self.view addSubview:self.bg];
}

- (void) addTitle{
	self.titleLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.titleLabel.text = self.titleText;
	[self.panel addSubview:self.titleLabel];
}

- (void) addPanel{
	self.panel = [[UIView alloc] initWithFrame:self.view.frame];
	self.panel.translatesAutoresizingMaskIntoConstraints = NO;
	self.panel.backgroundColor = [Colors darken:[Appearance bgColor]];
	[self.view addSubview:self.panel];
}

- (void) keyboardWillHide:(NSNotification*)notification{
	[self layoutPanel:0];
}

- (void) show{
	float y0 = -self.panel.frame.size.height/2;;
	float y1 = self.panel.frame.size.height/2;
	[self movePanelFrom:y0 to:y1];
}

- (void) movePanelFrom:(float)y0 to:(float)y1{
	[ImageUtils bounceAnimateView:self.panel from:y0 to:y1 withKeyPath:@"position.y" withKey:@"panelBounce" withDelegate:nil withDuration:0.3 withImmediate:NO withHide:NO];
}

- (void) addListeners{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) removeListeners{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification*)notification{
	NSDictionary* info  = notification.userInfo;
	NSValue* value = info[UIKeyboardFrameEndUserInfoKey];
	CGRect rawFrame      = [value CGRectValue];
	CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
	float H = self.view.frame.size.height;
	float h = keyboardFrame.size.height;
	float dy = H/2 - 0.5*(H - h);
	[self layoutPanel:-dy];
}

- (void) dealloc{
	[self removeListeners];
	[self.bg removeFromSuperview];
	[self.titleLabel removeFromSuperview];
	[self.panel removeFromSuperview];
	[self.view removeConstraints:self.panelConstraints];
	self.buttonLabels = @[];
}

@end
