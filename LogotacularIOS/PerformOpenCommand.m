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
					NSString* logo = (NSString*)data;
					[fileModel setVal:filename forKey:FILE_FILENAME];
					[fileModel setVal:[NSNumber numberWithBool:NO] forKey:FILE_DIRTY];
					[fileModel setVal:[NSNumber numberWithBool:YES] forKey:FILE_REAL];
					[logoModel reset:logo];
				}
			}];
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
