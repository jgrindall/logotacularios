//
//  HideMenuCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HideGridMenuCommand.h"
#import "PMenuModel.h"
#import <Objection/Objection.h>

@implementation HideGridMenuCommand

- (void) execute:(id) payload{
	id<PMenuModel> menuModel = [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
	BOOL shown = [[menuModel getVal:GRID_MENU_SHOWN] boolValue];
	if(shown){
		[menuModel toggleBoolValForKey:GRID_MENU_SHOWN];
	}
}

@end
