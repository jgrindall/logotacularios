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

@implementation PerformSaveCommand

- (void) execute:(id) payload{
	NSString* filename = (NSString*)payload;
	NSString* logo = [[self getLogoModel] get];
	[[FileLoader sharedInstance] saveFile:logo withFileName:filename withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			[[self getFileModel] setVal:filename forKey:FILE_FILENAME];
			[[self getFileModel] setVal:[NSNumber numberWithBool:NO] forKey:FILE_DIRTY];
			[[self getFileModel] setVal:[NSNumber numberWithBool:YES] forKey:FILE_REAL];
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
