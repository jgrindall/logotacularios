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

+ (NSString*) getFileOpenErrorMessage;
+ (NSString*) getFileSaveSuccessMessage;
+ (NSString*) getFileSaveErrorMessage;
+ (NSString*) getFileDeleteSuccessMessage;
+ (NSString*) getFileDeleteErrorMessage;
+ (NSString*) getFileNameInvalidMessage;
+ (NSString*) getFileNameTakenMessage;

@end
