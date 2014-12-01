//
//  WelcomeViewController.m
//  LogotacularIOS
//
//  Created by John on 01/12/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WelcomeViewController.h"

@implementation WelcomeViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	//self.buttonLabels = ((NSDictionary*)self.options)[@"buttons"];
	[self addButtons];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutButtons];
}

- (void) addButtons{
	
}

- (void) layoutButtons{
	
}

@end


