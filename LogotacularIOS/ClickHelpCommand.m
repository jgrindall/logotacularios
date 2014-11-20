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

@end

@implementation ClickHelpCommand

-  (void) execute:(id)payload{
	UIViewController* helpController = [[HelpPageViewController alloc] init];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:helpController];
}

@end
