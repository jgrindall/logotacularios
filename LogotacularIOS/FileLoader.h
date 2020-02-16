//
//  FileManager.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileLoaderUtils.h"
#import <UIKit/UIKit.h>

@interface FileLoader : NSObject

+ (FileLoader*) sharedInstance;

- (void) saveFile:(NSString*) logo withBg:(NSString*) bg withFileName:(NSString*) fileName withImage:(UIImage*)img withCallback:(void(^)(FileLoaderResults result))callback;
- (void) saveImg:(NSString*) fileName withImage:(UIImage*)img withCallback:(void(^)(FileLoaderResults result))callback;
- (void) deleteFileAtItem:(NSInteger) item withCallback:(void(^)(FileLoaderResults result))callback;
- (void) openFile: (NSString*) fileName withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) openFileAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) getYourFilesWithCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) getYourImgsWithCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) filenameOk:(NSString*)name withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) getFileNameAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback;
- (void) deleteImg:(NSURL*)url withCallback:(void(^)(FileLoaderResults result))callback;
+ (NSString*) getDatContents: (NSString*) logo withBg:(NSString*) bg;
+ (NSString*) getNilImgName;
- (NSURL*) getAbsoluteBgImageURL:(NSString*) fileName;
+ (NSString*) getImgName:(NSURL*) bg;
+ (NSDictionary*) parseDatContents: (NSString*) data;
- (NSString*)getFileNameFromPath:(NSURL*)path;
- (NSString*)getImagePathFromPath:(NSURL*)path;

@property (readonly) BOOL enabled;

@end

