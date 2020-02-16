//
//  PerformDelCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformDelImgCommand.h"
#import "FileLoader.h"
#import "PFileModel.h"
#import "PBgModel.h"
#import "PImgListModel.h"
#import "SymmNotifications.h"
#import "PFileBrowserModel.h"
#import "ToastUtils.h"

@implementation PerformDelImgCommand

- (void) execute:(id) payload{
	NSNumber* index = (NSNumber*)payload;
	NSInteger i = [index integerValue];
	id<PImgListModel> model = [self getImgListModel];
	NSURL* currentImg = [[self getBgModel] getVal:BG_IMAGE];
	NSArray* imgs = [model getVal:IMG_LIST_LIST];
	NSURL* img = imgs[i];
	if(currentImg != nil && [[img absoluteString] isEqualToString:[currentImg absoluteString]]){
		[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileDeleteCurrentImgErrorMessage] withType:TSMessageNotificationTypeError];
	}
	else{
		[[FileLoader sharedInstance] deleteImg:img withCallback:^(FileLoaderResults result) {
			if(result == FileLoaderResultOk){
				// remove it from the array
				NSMutableArray* array = [[NSMutableArray alloc]initWithArray:imgs];
				[array removeObjectAtIndex:i];
				[model setVal:array forKey:IMG_LIST_LIST];
			}
			else{
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileDeleteErrorMessage] withType:TSMessageNotificationTypeError];
			}
		}];
	}
}

- (id<PBgModel>) getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
}

- (id<PImgListModel>) getImgListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PImgListModel)];
}

@end
