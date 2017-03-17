//
//  ClickTutCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickTutCommand.h"
#import <Objection/Objection.h>
#import "TutPageViewController.h"
#import "POptionsModel.h"

@implementation ClickTutCommand

- (void) execute:(id) payload{
	NSInteger helpPage = [[[self getOptionsModel] getVal:HELP_PAGE] integerValue];
	UIViewController* tutController = [[TutPageViewController alloc] initWithStart:helpPage];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:tutController];
}

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
}

@end



