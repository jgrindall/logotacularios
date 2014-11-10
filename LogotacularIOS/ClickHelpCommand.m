//
//  ClickHelpCommand.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickHelpCommand.h"
#import "HelpPageViewController.h"

@interface ClickHelpCommand ()

@property UINavigationController* navigationController;

@end

@implementation ClickHelpCommand

-  (void) execute:(id)payload{
	self.navigationController = (UINavigationController*) payload;
	HelpPageViewController* helpController = [[HelpPageViewController alloc] init];
	[self.navigationController pushViewController:helpController animated:YES];
}

@end
