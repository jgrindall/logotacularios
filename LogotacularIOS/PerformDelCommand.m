//
//  PerformDelCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformDelCommand.h"
#import "FileLoader.h"

@implementation PerformDelCommand

- (void) execute:(id) payload{
	//NSNumber* index = (NSNumber*)payload;
	//NSInteger i = [index integerValue];
	//id<PFileModel> model = [self getFileModel];
	[[FileLoader sharedInstance] deleteFileAtItem:0 withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			
		}
	}];
}

@end
