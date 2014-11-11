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
	[[FileLoader sharedInstance] getFileNameAtIndex:[index integerValue] withCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSString* filename = (NSString*)data;
			id<PFileModel> fileModel = [self getFileModel];
			id<PLogoModel> logoModel = [self getLogoModel];
			[[FileLoader sharedInstance] openFileAtIndex:i withCallback:^(FileLoaderResults result, id data) {
				if(result == FileLoaderResultOk){
					NSString* currentName = [fileModel getVal:FILE_FILENAME];
					if([currentName isEqualToString:filename]){
						[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileOpenAlreadyMessage] withType:TSMessageNotificationTypeError];
					}
					else{
						NSString* logo = (NSString*)data;
						[fileModel setVal:filename forKey:FILE_FILENAME];
						[fileModel setVal:[NSNumber numberWithBool:NO] forKey:FILE_DIRTY];
						[fileModel setVal:[NSNumber numberWithBool:YES] forKey:FILE_REAL];
						[logoModel reset:logo];
						[[self getEventDispatcher] dispatch:SYMM_NOTIF_FILE_LOADED withData:nil];
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

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
