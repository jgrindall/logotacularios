//
//  FileManager.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PLogoAlertDelegate.h"

@interface FacebookService : NSObject <MFMailComposeViewControllerDelegate, PLogoAlertDelegate>

typedef enum  {
	FacebookResultOk = 0,
	FacebookResultNoFacebook,
	FacebookResultError,
	FacebookResultCancelled
} FacebookResults;


+ (FacebookService*) sharedInstance;

- (void) postImageToFacebook:(UIImage*)img withCallback:(void(^)(FacebookResults result))callback;
- (void) postImageToTwitter:(UIImage*)img withCallback:(void(^)(FacebookResults result))callback;
- (void) email:(UIImage*)img;
- (void) getScreenshotWithCompletion:(void(^)(UIImage*))completion;

@end

