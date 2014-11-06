//
//  FileLoaderResults.h
//  Symmetry
//
//  Created by John on 10/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLoaderUtils : NSObject

typedef enum  {
	FileLoaderResultOk = 0,
	FileLoaderResultAlreadyOpen,
	FileLoaderResultUnknownError,
	FileLoaderResultCheckSaveWanted
} FileLoaderResults;


@end
