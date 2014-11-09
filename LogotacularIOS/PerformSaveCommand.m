//
//  PerformSaveCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformSaveCommand.h"
#import "FileLoader.h"
#import "PLogoModel.h"
#import "PFileModel.h"
#import "SymmNotifications.h"
#import "PScreenGrabModel.h"
#import <UIKit/UIKit.h>
#import "ToastUtils.h"

@implementation PerformSaveCommand

- (void) execute:(id) payload{
	NSString* filename = (NSString*)payload;
	NSString* logo = [[self getLogoModel] get];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SCREENGRAB withData:nil];
	UIImage* img = [[self getScreenGrabModel] getVal:SCREEN_GRAB];
	[[FileLoader sharedInstance] saveFile:logo withFileName:filename withImage:img withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeSuccess];
			[[self getFileModel] setVal:filename forKey:FILE_FILENAME];
			[[self getFileModel] setVal:[NSNumber numberWithBool:NO] forKey:FILE_DIRTY];
			[[self getFileModel] setVal:[NSNumber numberWithBool:YES] forKey:FILE_REAL];
			[[self getEventDispatcher] dispatch:SYMM_NOTIF_SAVED withData:nil];
		}
		else{
			[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileSaveErrorMessage] withType:TSMessageNotificationTypeError];
		}
	}];
}

- (id<PScreenGrabModel>) getScreenGrabModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PScreenGrabModel)];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
