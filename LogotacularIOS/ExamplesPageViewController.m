//
//  ExamplesPageViewController.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ExamplesPageViewController.h"
#import "HelpPageViewController.h"
#import "HelpSectionViewController.h"
#import "Appearance.h"
#import "Colors.h"

@implementation ExamplesPageViewController

- (instancetype)init{
	self = [super initWithChildClass:[HelpSectionViewController class] andNumPages:5];
	if(self){
		self.title = @"Examples";
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [Colors getColorForString:[Colors getDark:2]];
}

@end
