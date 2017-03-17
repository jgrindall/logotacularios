//
//  ExamplesPageViewController.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TutPageViewController.h"
#import "TutSectionViewController.h"
#import "Appearance.h"
#import "Colors.h"

@interface TutPageViewController ()

@property (copy) void (^callbackBlock)(void);

@end


@implementation TutPageViewController

- (instancetype)initWithStart:(NSInteger)startPage{
	self = [super initWithChildClass:[TutSectionViewController class] andNumPages:22 andStartPage:startPage andDelegate:self];
	if(self){
		self.title = @"Tutorial";
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [Colors getColorForString:[Colors getDark:@"examples"]];
}

- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	self.callbackBlock = nil;
}

- (void) setListener:(void (^)(void))callbackBlock{
	self.callbackBlock = callbackBlock;
}

@end
