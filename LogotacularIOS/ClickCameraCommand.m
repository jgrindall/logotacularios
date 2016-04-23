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

@implementation ClickCameraCommand

- (void) execute:(id) payload{
	UIImage *screengrab;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	[window.layer renderInContext:ctx];
	screengrab = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(screengrab, self, @selector(savedImage:withError:usingContextInfo:), NULL);
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

