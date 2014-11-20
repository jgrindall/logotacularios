//
//  ClickExamplesCommand.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickExamplesCommand.h"
#import "ExamplesPageViewController.h"

@implementation ClickExamplesCommand

-  (void) execute:(id)payload{
	UIViewController* helpController = [[ExamplesPageViewController alloc] init];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:helpController];
}

@end
