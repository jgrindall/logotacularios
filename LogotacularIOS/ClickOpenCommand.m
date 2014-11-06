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

@interface ClickOpenCommand ()

@property UINavigationController* navigationController;

@end

@implementation ClickOpenCommand

- (void) execute:(id)payload{
	//TODO - change this!
	self.navigationController = (UINavigationController*) payload;
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_FILES withData:nil];
	[self goToFiles];
}

- (void) goToFiles{
	FilePageController* filesController = [[FilePageController alloc] init];
	[self.navigationController pushViewController:filesController animated:YES];
}

@end
