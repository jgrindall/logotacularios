//
//  StartCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ShareCommand.h"
#import "FacebookService.h"
#import "ToastUtils.h"

@implementation ShareCommand

- (void) execute:(id)payload{
	NSString* type = (NSString*)payload;
	if([type isEqual: @"facebook"]){
		[self postToFacebook];
	}
	else if([type isEqual: @"twitter"]){
		[self postToTwitter];
	}
	if([type isEqual: @"email"]){
		[self email];
	}
}

- (void) postToFacebook{
	UIImage* screengrab = [[FacebookService sharedInstance] getScreenshot];
	if(screengrab){
		[[FacebookService sharedInstance] postImageToFacebook:screengrab withCallback:^(FacebookResults result) {
			if(result == FacebookResultOk){
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getFacebookSuccessMessage] withType:TSMessageNotificationTypeSuccess];
			}
			else if(result == FacebookResultCancelled){
				// nothing
			}
			else if(result == FacebookResultNoFacebook){
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getNoFbErrorMessage] withType:TSMessageNotificationTypeWarning];
			}
			else{
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getFbErrorMessage] withType:TSMessageNotificationTypeWarning];
			}
		}];
	}
}

- (void) postToTwitter{
	UIImage* screengrab = [[FacebookService sharedInstance] getScreenshot];
	if(screengrab){
		[[FacebookService sharedInstance] postImageToTwitter:screengrab withCallback:^(FacebookResults result) {
			if(result == FacebookResultOk){
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getTwitterSuccessMessage] withType:TSMessageNotificationTypeSuccess];
			}
			else if(result == FacebookResultCancelled){
				// noithing
			}
			else if(result == FacebookResultNoFacebook){
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getNoTwitterErrorMessage] withType:TSMessageNotificationTypeWarning];
			}
			else{
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getTwitterErrorMessage] withType:TSMessageNotificationTypeWarning];
			}
		}];
	}
}

- (void) email{
	UIImage* screengrab = [[FacebookService sharedInstance] getScreenshot];
	if(screengrab){
		[[FacebookService sharedInstance] email:screengrab];
	}
}

@end

