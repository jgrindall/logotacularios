//
//  ToastUtils.h
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
///Users/john/Documents/ios/Symmetry/Symmetry.xcodeproj

#import <Foundation/Foundation.h>
#import <TSMessages/TSMessage.h>

@interface ToastUtils : NSObject

+ (void) showToastInController:(UIViewController*)controller withMessage:(NSString*) subtitle withType:(TSMessageNotificationType)type;

+ (NSString*) getOpenFileErrorMessage;
+ (NSString*) getFileSaveSuccessMessage;
+ (NSString*) getFileSaveErrorMessage;
+ (NSString*) getFileDeleteSuccessMessage;
+ (NSString*) getFileDeleteErrorMessage;
+ (NSString*) getStartFileErrorMessage;
+ (NSString*) getNoFbErrorMessage;
+ (NSString*) getFbErrorMessage;
+ (NSString*) getNoTwitterErrorMessage;
+ (NSString*) getTwitterErrorMessage;
+ (NSString*) getCameraRollSuccessMessage;
+ (NSString*) getGalleryViewNoInternetMessage;
+ (NSString*) getGalleryViewInsuffFilesMessage;
+ (NSString*) getGalleryViewErrorMessage;
+ (NSString*) getGallerySubmitNoInternetMessage;
+ (NSString*) getGallerySubmitErrorMessage;
+ (NSString*) getGallerySubmitSuccessMessage;
+ (NSString*) getFacebookSuccessMessage;
+ (NSString*) getTwitterSuccessMessage;

@end
