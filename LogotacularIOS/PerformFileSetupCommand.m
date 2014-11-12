//
//  PerformFileSetupCommand.m
//  LogotacularIOS
//
//  Created by John on 12/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformFileSetupCommand.h"
#import "PLogoModel.h"
#import "PFileModel.h"

@implementation PerformFileSetupCommand

- (void) execute:(id)payload{
	NSDictionary* dic = (NSDictionary*)payload;
	NSString* filename = nil;
	NSString* logo = dic[@"logo"];
	BOOL dirty = YES;
	BOOL real = NO;
	id<PLogoModel> logoModel = [self getLogoModel];
	id<PFileModel> fileModel = [self getFileModel];
	if(dic[@"filename"] != [NSNull null]){
		filename = dic[@"filename"];
		dirty = NO;
		real = YES;
	}
	[fileModel setVal:filename forKey:FILE_FILENAME];
	[fileModel setVal:@(dirty) forKey:FILE_DIRTY];
	[fileModel setVal:@(real) forKey:FILE_REAL];
	[logoModel reset:logo];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_FILE_LOADED withData:nil];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

@end
