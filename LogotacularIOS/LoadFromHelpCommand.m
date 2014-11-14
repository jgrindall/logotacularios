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
	NSInteger index = [(NSNumber*)payload integerValue];
	NSString* logo = [NSString stringWithFormat:@"Here is the logo for file, %i", index];
	NSDictionary* dic = @{@"filename":[NSNull null], @"logo":logo};
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_FILE_SETUP withData:dic];
}

@end
