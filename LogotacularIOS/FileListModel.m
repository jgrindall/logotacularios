//
//  FileListModel.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileListModel.h"

@implementation FileListModel

NSString* const FILE_LIST_LIST = @"filelist";

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:FILE_LIST_LIST, nil];
}

@end
