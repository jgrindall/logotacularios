//
//  ClickMenuCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickMenuCommand.h"
#import "PMenuModel.h"
#import <Objection/Objection.h>

@implementation ClickMenuCommand

- (void) execute:(id) payload{
	id<PMenuModel> menuModel = [[JSObjection defaultInjector] getObject:@protocol(PMenuModel)];
	[menuModel toggleBoolValForKey:MENU_SHOWN];
}

@end
