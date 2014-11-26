//
//  HelpPageViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpPageViewController.h"
#import "HelpSectionViewController.h"
#import "Appearance.h"
#import "Colors.h"

@implementation HelpPageViewController

- (instancetype)init{
	self = [super initWithChildClass:[HelpSectionViewController class] andNumPages:15];
	if(self){
		self.title = @"Help / about";
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [Colors getColorForString:[Colors getDark:2]];
}

@end

