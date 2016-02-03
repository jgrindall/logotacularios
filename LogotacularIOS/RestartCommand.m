//
//  StartCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "RestartCommand.h"
#import "PMenuModel.h"
#import "PLogoErrorModel.h"
#import "PTurtleModel.h"
#import "PDrawingModel.h"

@implementation RestartCommand

- (void) execute:(id)payload{
	[[self getMenuModel] setVal:@NO forKey:MENU_SHOWN];
	[[self getTurtleModel] reset];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_DISMISS_KEY withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESTART_QUEUE withData:nil];
}

- (id<PMenuModel>) getMenuModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
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