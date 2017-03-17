//
//  ClickNewCommand.m
//  LogotacularIOS
//
//  Created by John on 06/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "InsertCharCommand.h"
#import "SymmNotifications.h"

@implementation InsertCharCommand

- (void) execute:(id) payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DO_INSERT_CHAR withData:payload];
}

@end
