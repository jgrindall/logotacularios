//
//  MenuViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GridMenuViewController.h"
#import "PMenuModel.h"
#import "PGridModel.h"
#import "ImageUtils.h"
#import "MenuLayout.h"
#import "Assets.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "AlertManager.h"
#import "ParentGateViewController.h"

@interface GridMenuViewController ()

@property UIButton* button0;
@property UIButton* button1;
@property UIButton* button2;
@property UISlider* fontSlider;
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
	[self addSlider];
	[self addLabels];
	[self addListeners];
	[self showMenuChanged:nil];
	self.view.backgroundColor = [Appearance grayColor];
}

- (void) keyboardUp{
	[[self getMenuModel] setVal:@NO forKey:MENU_SHOWN];
}

- (void) addLabels{
	UILabel* label0 = [[UILabel alloc] initWithFrame:CGRectMake(5, 187, GRID_MENU_LAYOUT_WIDTH, 30)];
	[label0 setFont:[UIFont systemFontOfSize:18.4f]];
	[label0 setTextColor:[UIColor whiteColor]];
	[label0 setBackgroundColor:[UIColor clearColor]];
	[label0 setText:@"Font size"];
	[self.view addSubview:label0];
	UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, GRID_MENU_LAYOUT_WIDTH, 30)];
	[label1 setFont:[UIFont systemFontOfSize:18.4f]];
	[label1 setTextColor:[UIColor whiteColor]];
	[label1 setBackgroundColor:[UIColor clearColor]];
	[label1 setText:@"Grid options"];
	[self.view addSubview:label1];
}

- (void) addSlider{
	self.fontSlider = [[UISlider alloc] initWithFrame:self.view.frame];
	[self.fontSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	[self.fontSlider setBackgroundColor:[UIColor clearColor]];
	self.fontSlider.minimumValue = 0.0;
	self.fontSlider.maximumValue = 1.0;
	[self.fontSlider setMaximumValueImage:[UIImage imageNamed:LARGE_FONT_ICON]];
	[self.fontSlider setMinimumValueImage:[UIImage imageNamed:SMALL_FONT_ICON]];
	self.fontSlider.continuous = YES;
	self.fontSlider.value = 0.5;
	self.fontSlider.frame = CGRectMake(5, 227, GRID_MENU_LAYOUT_WIDTH - 25, 30);
	[self.view addSubview:self.fontSlider];
}

- (void) sliderAction:(id)sender{
	UISlider *slider = (UISlider*)sender;
	float value = slider.value;
}

- (void) addButtons{
	self.button0 = [self getButton:EMPTY_TICK_ICON withAction:@selector(onClick0)	withLabel:@" No grid"					atNum:0];
	self.button1 = [self getButton:EMPTY_TICK_ICON withAction:@selector(onClick1)	withLabel:@" Rectangular grid"			atNum:1];
	self.button2 = [self getButton:EMPTY_TICK_ICON withAction:@selector(onClick2)	withLabel:@" Polar grid"				atNum:2];
	[self.view addSubview:self.button0];
	[self.view addSubview:self.button1];
	[self.view addSubview:self.button2];
}

- (void) pauseAndClose{
	dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC);
	dispatch_after(t, dispatch_get_main_queue(), ^(void){
		[self closeMenu];
	});
}

- (void) onClick0{
	[[self getGridModel] setVal:@0 forKey:GRID_TYPE];
	[self update];
}

- (void) onClick1{
	[[self getGridModel] setVal:@1 forKey:GRID_TYPE];
	[self update];
}

- (void) onClick2{
	[[self getGridModel] setVal:@2 forKey:GRID_TYPE];
	[self update];
}

- (void) closeMenu{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_GRID_MENU withData:nil];
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
	btn.frame = CGRectMake(24, 47*num + 40, GRID_MENU_LAYOUT_WIDTH - 25, 30);
	[btn setImage:img forState:UIControlStateNormal];
	[btn setTitle:label forState:UIControlStateNormal];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (void) update{
	int type = (int)[[[self getGridModel] getVal:GRID_TYPE] integerValue];
	UIImage* onImg = [UIImage imageNamed:TICK_ICON];
	UIImage* offImg = [UIImage imageNamed:EMPTY_TICK_ICON];
	[self.button0 setImage:(type == 0 ? onImg : offImg) forState:UIControlStateNormal];
	[self.button1 setImage:(type == 1 ? onImg : offImg) forState:UIControlStateNormal];
	[self.button2 setImage:(type == 2 ? onImg : offImg) forState:UIControlStateNormal];
}

- (void) showMenuChanged:(id)data{
	BOOL shown = [[[self getMenuModel] getVal:GRID_MENU_SHOWN] boolValue];
	if(shown){
		[self show];
	}
	else{
		[self hide];
	}
	[self update];
}

- (void) addListeners{
	[[self getMenuModel] addListener:@selector(showMenuChanged:) forKey:GRID_MENU_SHOWN withTarget:self];
}

- (id<PMenuModel>) getMenuModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
}

- (id<PGridModel>) getGridModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PGridModel)];
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
	[[self getMenuModel] removeListener:@selector(showMenuChanged:) forKey:GRID_MENU_SHOWN withTarget:self];
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

