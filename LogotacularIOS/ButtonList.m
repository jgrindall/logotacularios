//
//  ButtonList.m
//  LogotacularIOS
//
//  Created by John on 26/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ButtonList.h"

@interface ButtonList ()

@property UIButton* b0;
@property UIButton* b1;
@property UIButton* b2;

@end

@implementation ButtonList

- (id) initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		[self setup];
	}
	return self;
}

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action{
	int num = [self.subviews count];
	NSLog(@"%i", num);
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(0, 30*num, 60, 30);
	[btn setImage:img forState:UIControlStateNormal];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

- (void) onClick0{
	
}

- (void) onClick1{
	
}

- (void) onClick2{
	
}

- (void) addButtons{
	self.b0 = [self getButton:@"assets/icons/add63.png" withAction:@selector(onClick0)];
	[self addSubview:self.b0];
	self.b1 = [self getButton:@"assets/icons/arrow408.png" withAction:@selector(onClick1)];
	[self addSubview:self.b1];
	self.b2 = [self getButton:@"assets/icons/folder59.png" withAction:@selector(onClick2)];
	[self addSubview:self.b2];
}

- (void) styleText{
	
}

- (void) setup{
	[self addButtons];
	float c = 0.6;
	self.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:0.25];
}

@end
