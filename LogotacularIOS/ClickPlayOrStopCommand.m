//
//  PlayCommand.m
//  LogotacularIOS
//
//  Created by John on 28/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickPlayOrStopCommand.h"
#import "SymmNotifications.h"
#import "PProcessingModel.h"
#import "PDrawingModel.h"

@implementation ClickPlayOrStopCommand

- (void) execute:(id) payload{
	id<PDrawingModel> drawingModel = [self getDrawingModel];
	BOOL drawing = [[drawingModel getVal:DRAWING_ISDRAWING] boolValue];
	[drawingModel toggleBoolValForKey:DRAWING_ISDRAWING];
	if(drawing){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_STOP withData:nil];
	}
	else{
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_START withData:nil];
	}
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

@end


