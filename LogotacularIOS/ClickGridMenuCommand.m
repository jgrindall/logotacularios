//
//  ClickMenuCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickGridMenuCommand.h"
#import "PMenuModel.h"
#import <Objection/Objection.h>
#import "LogoErrorModel.h"

@implementation ClickGridMenuCommand

- (void) execute:(id) payload{
	id<PMenuModel> menuModel = [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
	[menuModel toggleBoolValForKey:GRID_MENU_SHOWN];
	[menuModel setVal:@NO forKey:MENU_SHOWN];
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

@end



