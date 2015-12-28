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

@implementation ClickTutCommand

- (void) execute:(id) payload{
	UIViewController* tutController = [[TutPageViewController alloc] init];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:tutController];
}


@end



