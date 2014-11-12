//
//  PerformOpenCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformOpenCommand.h"
#import "FileLoader.h"
#import "PFileModel.h"
#import "PLogoModel.h"
#import "SymmNotifications.h"
#import "ToastUtils.h"

@implementation PerformOpenCommand

- (void) execute:(id) payload{
	NSNumber* index = (NSNumber*)payload;
	NSInteger i = [index integerValue];
	id<PFileModel> fileModel = [self getFileModel];
	[[FileLoader sharedInstance] getFileNameAtIndex:[index integerValue] withCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSString* filename = (NSString*)data;
			[[FileLoader sharedInstance] openFileAtIndex:i withCallback:^(FileLoaderResults result, id data) {
				if(result == FileLoaderResultOk){
					NSString* currentName = [fileModel getVal:FILE_FILENAME];
					if([currentName isEqualToString:filename]){
						[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileOpenAlreadyMessage] withType:TSMessageNotificationTypeError];
					}
					else{
						NSString* logo = (NSString*)data;
						[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_FILE_SETUP withData:@{@"filename":filename, @"logo":logo}];
					}
				}
				else{
					[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileOpenErrorMessage] withType:TSMessageNotificationTypeError];
				}
			}];
		}
		else{
			[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileOpenErrorMessage] withType:TSMessageNotificationTypeError];
		}
	}];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
