//
//  PerformDelCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformDelCommand.h"
#import "FileLoader.h"
#import "PFileModel.h"
#import "SymmNotifications.h"
#import "PFileBrowserModel.h"
#import "ToastUtils.h"

@implementation PerformDelCommand

- (void) execute:(id) payload{
	NSNumber* index = (NSNumber*)payload;
	NSInteger i = [index integerValue];
	id<PFileModel> model = [self getFileModel];
	NSString* currentName = [model getVal:FILE_FILENAME];
	[[FileLoader sharedInstance] getFileNameAtIndex:i withCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSString* fileNameAtI = (NSString*)data;
			if([fileNameAtI isEqualToString:currentName]){
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeSuccess];
			}
			else{
				[[FileLoader sharedInstance] deleteFileAtItem:i withCallback:^(FileLoaderResults result) {
					if(result == FileLoaderResultOk){
						NSLog(@"ok, deleted");
						[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_FILES withData:nil];
						[[self getFileBrowserModel] reset];
					}
				}];
			}
		}
	}];
}

- (id<PFileModel>)getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

- (id<PFileBrowserModel>)getFileBrowserModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileBrowserModel)];
}

@end
