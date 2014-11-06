//
//  HideMenuCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HideMenuCommand.h"
#import "PMenuModel.h"
#import <Objection/Objection.h>

@implementation HideMenuCommand

- (void) execute:(id) payload{
	id<PMenuModel> menuModel = [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
	BOOL shown = [[menuModel getVal:MENU_SHOWN] boolValue];
	if(shown){
		[menuModel toggleBoolValForKey:MENU_SHOWN];
	}
}

@end
