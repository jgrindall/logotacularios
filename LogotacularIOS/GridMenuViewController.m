//
//  MenuViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GridMenuViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "Assets.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "AlertManager.h"
#import "ParentGateViewController.h"

@interface GridMenuViewController ()

@property UIButton* button0;
@property UIButton* button1;
@property UIButton* button2;

@end

@implementation GridMenuViewController

- (instancetype) init{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp) name:UIKeyboardWillShowNotification object:nil];
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addButtons];
	[self addListeners];
	[self showMenuChanged:nil];
	self.view.backgroundColor = [Appearance grayColor];
}

- (void) keyboardUp{
	[[self getMenuModel] setVal:@NO forKey:MENU_SHOWN];
}

- (void) addButtons{
	self.button0 = [self getButton:ADD_ICON withAction:@selector(onClick0)			withLabel:@" No grid"					atNum:0];
	self.button1 = [self getButton:FLOPPY_ICON_AS withAction:@selector(onClick1)	withLabel:@" Rectangular grid"			atNum:1];
	self.button2 = [self getButton:HELP_ICON withAction:@selector(onClick2)			withLabel:@" Polar grid"				atNum:2];
	[self.view addSubview:self.button0];
	[self.view addSubview:self.button1];
	[self.view addSubview:self.button2];
}

- (void) onClick0{
	[self closeMenu];
}

- (void) onClick1{
	[self closeMenu];
}

- (void) onClick2{
	[self closeMenu];
}

- (void) closeMenu{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	//[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_GRID_MENU withData:nil];
}

- (void) clickButtonAt:(NSInteger)i withPayload:(id)payload{
	NSLog(@"click %i", i);
}


- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label atNum:(int)num{
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.frame = CGRectMake(0, 47*num + 10, 190, 30);
	[btn setImage:img forState:UIControlStateNormal];
	[btn setTitle:label forState:UIControlStateNormal];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (void) showMenuChanged:(id)data{
	BOOL shown = [[[self getMenuModel] getVal:GRID_MENU_SHOWN] boolValue];
	if(shown){
		[self show];
	}
	else{
		[self hide];
	}
}

- (void) addListeners{
	[[self getMenuModel] addListener:@selector(showMenuChanged:) forKey:GRID_MENU_SHOWN withTarget:self];
}

- (id<PMenuModel>) getMenuModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
}

- (void) show{
	float y0 = -self.view.frame.size.height/2;
	float y1 = self.view.frame.size.height/2;
	self.view.hidden = NO;
	self.view.superview.hidden = NO;
	[ImageUtils bounceAnimateView:self.view from:y0 to:y1 withKeyPath:@"position.y" withKey:@"menuBounce" withDelegate:nil withDuration:0.3 withImmediate:NO withHide:NO];
}

- (void) hide{
	float y0 = -self.view.frame.size.height/2 - 50;
	float y1 = self.view.frame.size.height/2;
	[ImageUtils bounceAnimateView:self.view from:y1 to:y0 withKeyPath:@"position.y" withKey:@"menuBounce" withDelegate:nil withDuration:0.3 withImmediate:NO withHide:NO];
	double delayInSeconds = 0.5;
	dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(t, dispatch_get_main_queue(), ^(void){
		self.view.hidden = YES;
		self.view.superview.hidden = YES;
	});
}

- (void) removeListeners{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[self getMenuModel] removeListener:@selector(showMenuChanged:) forKey:MENU_SHOWN withTarget:self];
}

- (void) dealloc{
	[self removeListeners];
	[self.button0 removeFromSuperview];
	[self.button1 removeFromSuperview];
	[self.button2 removeFromSuperview];
	self.button0 = nil;
	self.button1 = nil;
	self.button2 = nil;
}

@end

