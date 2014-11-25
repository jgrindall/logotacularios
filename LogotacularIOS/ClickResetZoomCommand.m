//
//  ClickResetZoomCommand.m
//  LogotacularIOS
//
//  Created by John on 25/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickResetZoomCommand.h"

@implementation ClickResetZoomCommand

- (void) execute:(id)payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET_ZOOM withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_PLAY withData:nil];
}

@end
