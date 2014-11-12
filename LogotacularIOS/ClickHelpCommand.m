//
//  ClickHelpCommand.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickHelpCommand.h"
#import "HelpPageViewController.h"
#import "AppDelegate.h"

@interface ClickHelpCommand ()

@end

@implementation ClickHelpCommand

-  (void) execute:(id)payload{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController* presenter = [delegate navigationController];
	HelpPageViewController* helpController = [[HelpPageViewController alloc] init];
	[presenter pushViewController:helpController animated:YES];
}

@end
