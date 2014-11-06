//
//  FileManager.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileLoaderUtils.h"
#import "FileObject.h"

@interface FileLoader : NSObject

+ (FileLoader*) sharedInstance;

- (void) saveFile:(NSString*) logo withFileName:(NSString*) fileName withCallback:(void(^)(FileLoaderResults result))callback;
- (void) deleteFileAtItem:(NSInteger) item withCallback:(void(^)(FileLoaderResults result))callback;
- (void) openFile: (NSString*) fileName withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) openFileAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) getYourFilesWithCallback:(void(^)(FileLoaderResults result, id data))callback;
- (BOOL) filenameOk:(NSString*)name;
- (void) getFileNameAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (NSString*)getFileNameFromPath:(NSURL*)path;

@property (readonly) BOOL enabled;

@end

