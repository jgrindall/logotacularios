//
//  LoadFilesCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LoadImgsCommand.h"
#import "FileLoader.h"
#import "PImgListModel.h"
#import "SymmNotifications.h"
#import "ToastUtils.h"

@implementation LoadImgsCommand

- (void) execute:(id) payload{
	[[FileLoader sharedInstance] getYourImgsWithCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSArray* imgs = (NSArray*)data;
			[[self getImgListModel] setVal:imgs forKey:IMG_LIST_LIST];
		}
		else{
			[ToastUtils showToastInController:nil withMessage:[ToastUtils getImgListLoadErrorMessage] withType:TSMessageNotificationTypeError];
		}
	}];
}

- (id<PImgListModel>) getImgListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PImgListModel)];
}

@end
