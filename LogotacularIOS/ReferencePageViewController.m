//
//  ReferencePageViewController.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ReferencePageViewController.h"
#import "Appearance.h"
#import "Colors.h"
#import "HelpSectionViewController.h"

@implementation ReferencePageViewController

- (instancetype)init{
	self = [super initWithChildClass:[HelpSectionViewController class] andNumPages:5];
	if(self){
		self.title = @"Quick reference";
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [Colors getColorForString:[Colors getDark:2]];
}

@end
