//
//  ChangePageCommand.m
//  LogotacularIOS
//
//  Created by John on 12/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ChangePageCommand.h"
#import "AppDelegate.h"

@implementation ChangePageCommand

- (void) execute:(id)payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_POPOVER withData:nil];
	UIViewController* controller = (UIViewController*)payload;
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController* presenter = [delegate navigationController];
	[presenter pushViewController:controller animated:YES];
}

@end
