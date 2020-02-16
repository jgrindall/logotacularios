//
//  PerformOpenCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformOpenImgCommand.h"
#import "FileLoader.h"
#import "PFileModel.h"
#import "PLogoModel.h"
#import "SymmNotifications.h"
#import "ToastUtils.h"
#import "PBgModel.h"
#import "PImgListModel.h"

@implementation PerformOpenImgCommand

- (void) execute:(id) payload{
	NSNumber* index = (NSNumber*)payload;
	NSInteger i = [index integerValue];
	NSArray* imgs = (NSArray*)[[self getImgListModel] getVal:IMG_LIST_LIST];
	NSURL* img = imgs[i];
	[[self getBgModel] setVal:img forKey:BG_IMAGE];
	
}

- (id<PImgListModel>) getImgListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PImgListModel)];
}

- (id<PBgModel>)getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
}


@end
