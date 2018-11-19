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
		[TSMessage showNotificationInViewController:presenter title:title subtitle:subtitle image:nil type:type duration:3.0f callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
	}
}

+ (NSString*) getFileOpenAlreadyMessage{
	return @"File already open";
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

+ (NSString*) getFileDeleteCurrentFileErrorMessage{
	return @"You cannot delete an open file, please close it first";
}

+ (NSString*) getFileListLoadErrorMessage{
	return @"Failed to load your files";
}

+ (NSString*) getImgListLoadErrorMessage{
	return @"Failed to load your images";
}

+ (NSString*) getFileNameErrorMessage{
	return @"An error occurred while saving your file";
}

+ (NSString*) getCameraErrorMessage{
	return @"An error occurred while saving your screenshot";
}

+ (NSString*) getCameraSuccessMessage{
	return @"A screenshot has been saved to your device";
}

+ (NSString*) getFacebookSuccessMessage{
	return @"Thanks, your post was successful";
}

+ (NSString*) getNoFbErrorMessage{
	return @"Unable to post to Facebook, please check that you have the Facebook app and have registered an account on your device.";
}

+ (NSString*) getFbErrorMessage{
	return @"An error occured posting to Facebook, please try again.";
}

+ (NSString*) getTwitterSuccessMessage{
	return @"Thanks, your post was successful";
}
	
+ (NSString*) getNoTwitterErrorMessage{
	return @"Unable to post to Twitter, please check that you have the Twitter app and have registered an account on your device.";
}
		
+ (NSString*) getTwitterErrorMessage{
	return @"An error occured posting to Twitter, please try again.";
}

+ (NSString*) getParentalGateInvalidMessage{
	return @"Sorry that is incorrect.";
}

@end
