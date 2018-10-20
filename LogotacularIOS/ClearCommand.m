//
//  ClearCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClearCommand.h"
#import "SymmNotifications.h"
#import "PLogoModel.h"
#import "PProcessingModel.h"
#import "LogoErrorModel.h"
#import "PBgModel.h"

@implementation ClearCommand

- (void) execute:(id) payload{
	BOOL drawing = [[[self getProcessingModel] getVal:PROCESSING_ISPROCESSING] boolValue];
	if(drawing){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_PLAY withData:nil];
	}
	[[self getBgModel] reset];
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET_ZOOM withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_TEXT_EDITED withData:@""];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_TRI withData:nil];
}

- (id<PBgModel>) getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (id<PProcessingModel>) getProcessingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PProcessingModel)];
}

@end

