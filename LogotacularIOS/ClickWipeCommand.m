//
//  ClickResetZoomCommand.m
//  LogotacularIOS
//
//  Created by John on 25/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickWipeCommand.h"

@implementation ClickWipeCommand

- (void) execute:(id)payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
}

@end
