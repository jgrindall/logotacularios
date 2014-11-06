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
#import "PDrawingModel.h"

@implementation ClearCommand

- (void) execute:(id) payload{
	BOOL drawing = [[[self getDrawingModel] getVal:DRAWING_ISDRAWING] boolValue];
	if(drawing){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_PLAY withData:nil];
	}
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
	id<PLogoModel> logoModel = [self getLogoModel];
	[logoModel add:@""];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

@end
