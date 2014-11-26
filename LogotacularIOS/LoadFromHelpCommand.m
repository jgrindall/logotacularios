//
//  LoadFromHelpCommand.m
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LoadFromHelpCommand.h"

@implementation LoadFromHelpCommand

- (void) execute:(id)payload{
	NSString* logo = (NSString*)payload;
	NSLog(@"payload %@", logo);
	NSDictionary* dic = @{@"filename":[NSNull null], @"logo":logo};
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_FILE_SETUP withData:dic];
}

@end
