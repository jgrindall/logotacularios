//
//  MenuViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ColorPopupController.h"
#import "Appearance.h"
#import "POptionsModel.h"
#import "Appearance.h"
#import "InjectionModule.h"
#import "SymmNotifications.h"
#import <Objection/Objection.h>

@interface ColorPopupController ()

@property NSMutableArray* buttons;
@property NSMutableArray* labels;

@end

@implementation ColorPopupController

int const WIDTH = 300;
int const HEIGHT = 200;
int const BUTTONS_WIDTH = 250;
int const BUTTONS_HEIGHT = 100;
int const NUM_X = 5;
int const NUM_Y = 2;
int const PADDING = 6;
float const SWATCH_WIDTH = (float)BUTTONS_WIDTH / (float) NUM_X;
float const SWATCH_HEIGHT = (float)BUTTONS_HEIGHT / (float) NUM_Y;


- (instancetype) init{
	self = [super init];
	if(self){
		self.preferredContentSize = CGSizeMake(WIDTH, HEIGHT);
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	self.labels = [[NSMutableArray alloc] initWithCapacity:NUM_X * NUM_Y];
	for(int i = 0; i < NUM_X * NUM_Y; i++){
		float f = (float)i / (float)(NUM_X * NUM_Y - 1);
		[self.labels addObject:[NSNumber numberWithFloat:f]];
	}
	self.buttons = [[NSMutableArray alloc] initWithCapacity:2];
	[self addButtons];
	self.view.backgroundColor = [Appearance grayColor];
}

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
}

- (void) addButtons{
	for(int i = 0; i < [self.labels count]; i++){
		UIButton* b = [self getSwatchWithColor:(NSNumber*)[self.labels objectAtIndex:i] atIndex:i];
		[self.view addSubview:b];
		[self.buttons addObject:b];
	}
}

- (void) update{
	for(int i = 0; i < [self.buttons count]; i++){
		UIButton* b = [self.buttons objectAtIndex:i];
		if(i == 3){
			float rgb = [[self.labels objectAtIndex:3] floatValue];
			UIColor* border = [UIColor colorWithRed:1 - rgb green:1 - rgb blue:1 - rgb alpha:1.0];
			[b.layer setBorderColor:[border CGColor]];
		}
		else{
			[b.layer setBorderColor:[[UIColor clearColor] CGColor]];
		}
	}
}

- (void) clickButton:(id)sender{
	UIButton* b = (UIButton*)sender;
	for (int i = 0; i < [self.buttons count]; i++) {
		UIButton* bi = (UIButton*)[self.buttons objectAtIndex:i];
		if([bi isEqual:b]){
			//[[self getOptionsModel] setVal:[NSNumber numberWithInteger:i] forKey:GRID_TYPE];
			[self update];
		}
	}
}

- (UIButton*) getSwatchWithColor:(NSNumber*) label atIndex:(NSInteger) i{
	NSInteger col = i % NUM_X;
	NSInteger row = (int)floor(i/NUM_X);
	float x = col * SWATCH_WIDTH + (col + 1)*PADDING;
	float y = row * SWATCH_HEIGHT + (row + 1)*PADDING;
	UIButton *b =  [[UIButton alloc] initWithFrame:CGRectMake(x, y, SWATCH_WIDTH, SWATCH_HEIGHT)];
	float rgb = [label floatValue];
	UIColor* c = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
	[b setBackgroundColor:c];
	b.layer.cornerRadius = 10;
	[b.layer setBorderColor:[[UIColor clearColor] CGColor]];
	[b.layer setBorderWidth:5.0f];
	b.clipsToBounds = YES;
	[b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
	return b;
}

- (void) dealloc{
	
}

@end




