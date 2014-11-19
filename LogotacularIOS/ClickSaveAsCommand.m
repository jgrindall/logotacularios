//
//  ClickSaveAsCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickSaveAsCommand.h"
#import "SymmNotifications.h"

@implementation ClickSaveAsCommand

- (void) execute:(id) payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SHOW_FILENAME_AS withData:nil];
}

@end
