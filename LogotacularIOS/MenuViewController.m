//
//  MenuViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MenuViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "Assets.h"
#import "SymmNotifications.h"
#import "Appearance.h"

@interface MenuViewController ()

@property UIButton* fileButton;
@property UIButton* helpButton;
@property UIButton* saveButton;
@property UIButton* openButton;

@end

@implementation MenuViewController

- (instancetype) init{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp) name:UIKeyboardWillShowNotification object:nil];
	}
	return self;
}

- (void) viewDidLoad{
	[self addButtons];
	[self addListeners];
	[self showMenuChanged:nil];
	self.view.backgroundColor = [Appearance grayColor];
}

- (void) keyboardUp{
	[[self getMenuModel] setVal:@NO forKey:MENU_SHOWN];
}

- (void) addButtons{
	self.fileButton = [self getButton:ADD_ICON withAction:@selector(onClickNew)			withLabel:@" New file" atNum:0];
	self.helpButton = [self getButton:BULB_ICON withAction:@selector(onClickHelp)		withLabel:@" Help" atNum:1];
	self.saveButton = [self getButton:FLOPPY_ICON withAction:@selector(onClickSave)		withLabel:@" Save" atNum:2];
	self.openButton = [self getButton:FOLDER_ICON withAction:@selector(onClickOpen)		withLabel:@" Your files" atNum:3];
	[self.view addSubview:self.fileButton];
	[self.view addSubview:self.helpButton];
	[self.view addSubview:self.saveButton];
	[self.view addSubview:self.openButton];
}

- (void) onClickNew{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_MENU withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_NEW withData:nil];
}

- (void) onClickHelp{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_MENU withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_HELP withData:nil];
}

- (void) onClickSave{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_MENU withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_SAVE withData:nil];
}

- (void) onClickOpen{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_MENU withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_OPEN withData:nil];
}

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label atNum:(int)num{
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.frame = CGRectMake(0, 45*num + 10, 160, 30);
	[btn setImage:img forState:UIControlStateNormal];
	[btn setTitle:label forState:UIControlStateNormal];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (void) showMenuChanged:(id)data{
	BOOL shown = [[[self getMenuModel] getVal:MENU_SHOWN] boolValue];
	if(shown){
		[self show];
	}
	else{
		[self hide];
	}
}

- (void) addListeners{
	[[self getMenuModel] addListener:@selector(showMenuChanged:) forKey:MENU_SHOWN withTarget:self];
}

- (id<PMenuModel>) getMenuModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
}

- (void) show{
	float y0 = -self.view.frame.size.height/2;;
	float y1 = self.view.frame.size.height/2;
	[ImageUtils bounceAnimateView:self.view from:y0 to:y1 withKeyPath:@"position.y" withKey:@"menuBounce" withDelegate:nil withDuration:0.3 withImmediate:NO];
	self.view.hidden = NO;
}

- (void) hide{
	self.view.hidden = YES;
}

- (void) removeListeners{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[self getMenuModel] removeListener:@selector(showMenuChanged:) forKey:MENU_SHOWN withTarget:self];
}

- (void) dealloc{
	[self removeListeners];
}

@end
