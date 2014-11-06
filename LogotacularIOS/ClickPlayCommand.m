//
//  PlayCommand.m
//  LogotacularIOS
//
//  Created by John on 28/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickPlayCommand.h"
#import "SymmNotifications.h"
#import "PDrawingModel.h"
#import "PMenuModel.h"

@implementation ClickPlayCommand

- (void) execute:(id) payload{
	id<PDrawingModel> drawingModel = [self getDrawingModel];
	BOOL drawing = [[drawingModel getVal:DRAWING_ISDRAWING] boolValue];
	[drawingModel toggleBoolValForKey:DRAWING_ISDRAWING];
	if(drawing){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_STOP withData:nil];
	}
	else{
		[[self getMenuModel] setVal:[NSNumber numberWithBool:NO] forKey:MENU_SHOWN];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_START withData:nil];
	}
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

- (id<PMenuModel>) getMenuModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
}

@end
