//
//  ClickOpenCommand.m
//  LogotacularIOS
//
//  Created by John on 01/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickOpenCommand.h"
#import "FilePageController.h"
#import "SymmNotifications.h"
#import "AppDelegate.h"

@interface ClickOpenCommand ()

@property UINavigationController* navigationController;

@end

@implementation ClickOpenCommand

- (void) execute:(id)payload{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController* presenter = [delegate navigationController];
	FilePageController* filesController = [[FilePageController alloc] init];
	[presenter pushViewController:filesController animated:YES];
}

@end
