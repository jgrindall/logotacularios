//
//  StartCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "StartCommand.h"
#import "PMenuModel.h"
#import "PLogoErrorModel.h"
#import "PTurtleModel.h"
#import "PDrawingModel.h"
#import "PProcessingModel.h"

@implementation StartCommand

- (void) execute:(id)payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLEAR_QUEUE withData:nil];
	[[self getMenuModel] setVal:@NO forKey:MENU_SHOWN];
	[[self getTurtleModel] reset];
	[[self getProcessingModel] setVal:@YES forKey:PROCESSING_ISPROCESSING];
	[[self getDrawingModel] setVal:@YES forKey:DRAWING_ISDRAWING];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_TRI withData:nil];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1), dispatch_get_main_queue(), ^{
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_PARSE withData:nil];
	});
}

- (id<PMenuModel>) getMenuModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
}

- (id<PProcessingModel>) getProcessingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PProcessingModel)];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

- (id<PTurtleModel>) getTurtleModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PTurtleModel)];
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

@end
