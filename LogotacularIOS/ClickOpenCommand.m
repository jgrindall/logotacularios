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
	FilePageController* filesController = [[FilePageController alloc] init];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:filesController];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_FILES withData:nil];
}

@end
