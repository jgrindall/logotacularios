//
//  ToastUtils.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ToastUtils.h"
#import "AppDelegate.h"

@implementation ToastUtils

+ (void) showToastInController:(UIViewController*)controller withMessage:(NSString*)subtitle withType:(TSMessageNotificationType)type{
	NSString* title = @"";
	if(type == TSMessageNotificationTypeSuccess){
		title = @"SUCCESS";
	}
	else if(type == TSMessageNotificationTypeError){
		title = @"ERROR";
	}
	UIViewController* presenter;
	if(controller){
		presenter = [controller navigationController];
		if(!presenter){
			presenter = controller;
		}
	}
	else{
		AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		presenter = [delegate navigationController];
	}
	if(presenter){
		[TSMessage showNotificationInViewController:presenter title:title subtitle:subtitle type:type duration:3.0f canBeDismissedByUser:YES];
	}
}
+ (NSString*) getFileOpenErrorMessage{
	return @"An error occurred while opening your file";
}

+ (NSString*) getFileSaveSuccessMessage{
	return @"Your file has been saved";
}

+ (NSString*) getFileSaveErrorMessage{
	return @"An error occurred while saving your file";
}

+ (NSString*) getFileDeleteSuccessMessage{
	return @"Your file has been deleted";
}

+ (NSString*) getFileDeleteErrorMessage{
	return @"An error occurred while deleting your file";
}

+ (NSString*) getFileNameInvalidMessage{
	return @"Please choose a valid filename";
}

+ (NSString*) getFileNameTakenMessage{
	return @"That filename is already taken";
}

@end
