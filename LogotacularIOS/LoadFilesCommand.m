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
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SHOW_SPINNER withData:nil];
	[[FileLoader sharedInstance] getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSArray* files = (NSArray*)data;
			NSLog(@"files loaded %@", files);
			[[self getFileListModel] setVal:files forKey:FILE_LIST_LIST];
			[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_SPINNER withData:nil];
		}
	}];
}

- (id<PFileListModel>) getFileListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileListModel)];
}

@end
