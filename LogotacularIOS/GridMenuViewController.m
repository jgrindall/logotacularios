//
//  MenuViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GridMenuViewController.h"
#import "PMenuModel.h"
#import "POptionsModel.h"
#import "ImageUtils.h"
#import "MenuLayout.h"
#import "Assets.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "AlertManager.h"
#import "ParentGateViewController.h"

@interface GridMenuViewController ()

@property UISlider* fontSlider;
@property NSMutableArray* buttons;
@property NSArray* gridTypes;
@end

@implementation GridMenuViewController

- (instancetype) init{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp) name:UIKeyboardWillShowNotification object:nil];
		self.gridTypes = [NSArray arrayWithObjects:@" No grid", @" Rectangular grid", @" Polar grid", @" Combined grid", nil];
		self.buttons = [[NSMutableArray alloc] initWithCapacity:self.gridTypes.count];
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
	UILabel* label0 = [[UILabel alloc] initWithFrame:CGRectMake(5, GRID_MENU_LAYOUT_HEIGHT - 72, GRID_MENU_LAYOUT_WIDTH, 30)];
	[label0 setFont:[UIFont systemFontOfSize:18.4f]];
	[label0 setTextColor:[UIColor whiteColor]];
	[label0 setBackgroundColor:[UIColor clearColor]];
	label0.alpha = 0.6;
	[label0 setText:@"Font size:"];
	[self.view addSubview:label0];
	UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, GRID_MENU_LAYOUT_WIDTH, 30)];
	[label1 setFont:[UIFont systemFontOfSize:18.4f]];
	[label1 setTextColor:[UIColor whiteColor]];
	[label1 setBackgroundColor:[UIColor clearColor]];
	label1.alpha = 0.6;
	[label1 setText:@"Grid options:"];
	[self.view addSubview:label1];
}

- (void) addSlider{
	self.fontSlider = [[UISlider alloc] initWithFrame:self.view.frame];
	[self.fontSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	[self.fontSlider setBackgroundColor:[UIColor clearColor]];
	self.fontSlider.minimumValue = 14;
	self.fontSlider.maximumValue = 48;
	[self.fontSlider setMaximumValueImage:[UIImage imageNamed:LARGE_FONT_ICON]];
	[self.fontSlider setMinimumValueImage:[UIImage imageNamed:SMALL_FONT_ICON]];
	self.fontSlider.continuous = YES;
	self.fontSlider.value = SYMM_FONT_SIZE_LOGO;
	self.fontSlider.frame = CGRectMake(5, GRID_MENU_LAYOUT_HEIGHT - 36, GRID_MENU_LAYOUT_WIDTH - 20, 30);
	[self.view addSubview:self.fontSlider];
}

- (void) sliderAction:(id)sender{
	UISlider *slider = (UISlider*)sender;
	float value = slider.value;
}

- (void) addButtons{
	int i;
	for (i = 0; i < [self.gridTypes count]; i++) {
		NSString* label = (NSString*)[self.gridTypes objectAtIndex:i];
		UIButton* b = [self getButton:EMPTY_TICK_ICON withAction:@selector(clickButton:) withLabel:label atNum:i];
		[self.buttons addObject:b];
		[self.view addSubview:b];
	}
}

- (void) closeMenu{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_GRID_MENU withData:nil];
}

- (void) clickButton:(id)sender{
	UIButton* b = (UIButton*)sender;
	for (int i = 0; i < [self.buttons count]; i++) {
		UIButton* bi = (UIButton*)[self.buttons objectAtIndex:i];
		if([bi isEqual:b]){
			[[self getOptionsModel] setVal:[NSNumber numberWithInteger:i] forKey:GRID_TYPE];
			[self update];
		}
	}
}

- (void) clickButtonAt:(NSInteger)i withPayload:(id)payload{
	[[self getOptionsModel] setVal:[NSNumber numberWithInteger:i] forKey:GRID_TYPE];
	[self update];
}

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label atNum:(int)num{
	int const BUTTON_GAP_Y = 43;
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	btn.frame = CGRectMake(24, BUTTON_GAP_Y*num + 40, GRID_MENU_LAYOUT_WIDTH - 25, 30);
	[btn setImage:img forState:UIControlStateNormal];
	[btn setTitle:label forState:UIControlStateNormal];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (void) update{
	int type = (int)[[[self getOptionsModel] getVal:GRID_TYPE] integerValue];
	UIImage* onImg = [UIImage imageNamed:TICK_ICON];
	UIImage* offImg = [UIImage imageNamed:EMPTY_TICK_ICON];
	int i;
	for (i = 0; i < [self.gridTypes count]; i++) {
		UIButton* b = (UIButton*)[self.buttons objectAtIndex:i];
		[b setImage:(type == i ? onImg : offImg) forState:UIControlStateNormal];
	}
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

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
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
	int i;
	for (i = 0; i < [self.buttons count]; i++) {
		UIButton* b = (UIButton*)[self.buttons objectAtIndex:i];
		[b removeFromSuperview];
	}
}

@end

