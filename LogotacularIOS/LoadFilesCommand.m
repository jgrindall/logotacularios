//
//  LoadFilesCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LoadFilesCommand.h"
#import "FileLoader.h"
#import "PFileListModel.h"
#import "SymmNotifications.h"

@implementation LoadFilesCommand

- (void) execute:(id) payload{
	[[FileLoader sharedInstance] getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSArray* files = (NSArray*)data;
			NSLog(@"files loaded %@", files);
			[[self getFileListModel] setVal:files forKey:FILE_LIST_LIST];
		}
	}];
}

- (id<PFileListModel>) getFileListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileListModel)];
}

@end
