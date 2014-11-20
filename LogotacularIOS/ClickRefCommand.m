//
//  ClickRefCommand.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickRefCommand.h"
#import "ReferencePageViewController.h"

@implementation ClickRefCommand

-  (void) execute:(id)payload{
	UIViewController* helpController = [[ReferencePageViewController alloc] init];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:helpController];
}

@end
