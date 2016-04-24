//
//  ClickNewCommand.m
//  LogotacularIOS
//
//  Created by John on 06/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickCameraCommand.h"
#import "SymmNotifications.h"
#import "ToastUtils.h"
#import "FacebookService.h"

@implementation ClickCameraCommand

- (void) execute:(id) payload{
	UIImage* screengrab = [[FacebookService sharedInstance] getScreenshot];
	if(screengrab){
		UIImageWriteToSavedPhotosAlbum(screengrab, self, @selector(savedImage:withError:usingContextInfo:), NULL);
	}
}

- (void)savedImage:(UIImage *)image withError:(NSError *)error usingContextInfo:(void*)ctxInfo{
	NSString* msg;
	if (error) {
		msg = [ToastUtils getCameraErrorMessage];
		[ToastUtils showToastInController:nil withMessage:msg withType:TSMessageNotificationTypeError];
	}
	else {
		msg = [ToastUtils getCameraSuccessMessage];
		[ToastUtils showToastInController:nil withMessage:msg withType:TSMessageNotificationTypeSuccess];
	}
}

@end
