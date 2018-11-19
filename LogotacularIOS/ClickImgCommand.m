//
//  ClickOpenCommand.m
//  LogotacularIOS
//
//  Created by John on 01/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickImgCommand.h"
#import "ImgPageController.h"
#import "SymmNotifications.h"
#import "AppDelegate.h"

@interface ClickImgCommand ()

@property UINavigationController* navigationController;

@end

@implementation ClickImgCommand

- (void) execute:(id)payload{
	ImgPageController* imgController = [[ImgPageController alloc] init];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CHANGE_PAGE withData:imgController];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_IMGS withData:nil];
}

@end
