//
//  ClickSaveCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickSaveCommand.h"
#import "PFileModel.h"
#import "SymmNotifications.h"

@implementation ClickSaveCommand

- (void) execute:(id) payload{
	BOOL isReal = [[[self getFileModel] getVal:FILE_REAL] boolValue];
	if(!isReal){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_SHOW_FILENAME withData:nil];
	}
	else{
		// has a real filename
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_SAVE withData:[[self getFileModel] getVal:FILE_FILENAME]];
	}
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
