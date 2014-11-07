//
//  ClickNewCommand.m
//  LogotacularIOS
//
//  Created by John on 06/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickNewCommand.h"
#import "PFileModel.h"
#import "PLogoModel.h"
#import "SymmNotifications.h"

@implementation ClickNewCommand

- (void) execute:(id) payload{
	BOOL isReal = [[[self getFileModel] getVal:FILE_REAL] boolValue];
	BOOL isDirty = [[[self getFileModel] getVal:FILE_DIRTY] boolValue];
	if(isDirty && isReal){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHECK_SAVE withData:nil];
	}
	else{
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_NEW withData:nil];
	}
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
