//
//  FileManager.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileLoader.h"
#import "SymmNotifications.h"
#import "ImageUtils.h"

@interface FileLoader ()

@property NSFileManager* fileManager;
@property NSURL* savesFolder;
@property BOOL enabled;

@end

@implementation FileLoader

+ (id)sharedInstance {
    static FileLoader* loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (id)init {
	if (self = [super init]) {
		self.fileManager = [NSFileManager defaultManager];
		self.enabled = [self makeFolders];
	}
	return self;
}

- (BOOL) makeFolders{
	NSArray* array = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	if([array count] == 0){
		return NO;
	}
	NSURL* dir = array[0];
	NSError* error;
	NSString* bundle = [[NSBundle mainBundle] bundleIdentifier];
	NSURL* folder = [dir URLByAppendingPathComponent:bundle];
	BOOL folderExists = [self.fileManager fileExistsAtPath:[folder path]];
	if(!folderExists){
		[self.fileManager createDirectoryAtURL:folder withIntermediateDirectories:YES attributes:nil error:&error];
		if(error) {
			return NO;
		}
	}
	self.savesFolder = folder;
	return YES;
}

- (NSString*)getImagePathFromPath:(NSURL*)url{
	return [url.path stringByReplacingOccurrencesOfString:@".dat" withString:@".png"];
}

- (NSURL*) getAbsoluteURL:(NSString*) fileName{
	NSString* fullName = [NSString stringWithFormat:@"%@%@", fileName, @".dat"];
	return [self.savesFolder URLByAppendingPathComponent:fullName];
}

- (NSURL*) getAbsoluteImageURL:(NSString*) fileName{
	NSString* fullName = [NSString stringWithFormat:@"%@%@", fileName, @".png"];
	return [self.savesFolder URLByAppendingPathComponent:fullName];
}

- (void) saveFile:(NSString*) logo withFileName:(NSString*) fileName withImage:(UIImage*)img withCallback:(void(^)(FileLoaderResults result))callback{
	NSURL* fullPath = [self getAbsoluteURL: fileName];
	NSURL* fullImagePath = [self getAbsoluteImageURL: fileName];
	NSError* error;
	[logo writeToURL:fullPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	NSData *imageData = UIImagePNGRepresentation(img);
	[imageData writeToURL:fullImagePath atomically:YES];
	NSLog(@"save image to %@", fullImagePath);
	callback(FileLoaderResultOk);
}

- (void) deleteFileAtItem:(NSInteger) item withCallback:(void(^)(FileLoaderResults result))callback{
	[self getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		NSArray* files = (NSArray*)data;
		NSURL* url = [files objectAtIndex:item];
		NSError* error = nil;
		// check if it is the open file!
		[self.fileManager removeItemAtURL:url error:&error];
		if(error){
			callback(FileLoaderResultUnknownError);
		}
		else{
			callback(FileLoaderResultOk);
		}
	}];
}

- (void) openFile: (NSString*) fileName withCallback:(void(^)(FileLoaderResults result, id data))callback{
	NSURL* url = [self getAbsoluteURL: fileName];
	[self openFileAtURL:url withCallback:callback];
}

- (void) openFileAtURL:(NSURL*)url withCallback:(void(^)(FileLoaderResults result, id data))callback{
	NSError* error;
	NSString* contents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	callback(FileLoaderResultOk, contents);
}

- (void) openFileAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback{
	[self getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		NSArray* files = (NSArray*)data;
		NSURL* url = [files objectAtIndex:i];
		[self openFileAtURL:url withCallback:callback];
	}];
}

- (BOOL) filenameOk:(NSString*)name{
	return YES;
}

- (NSString*)getFileNameFromPath:(NSURL*)path{
	NSString* fileName = [[path lastPathComponent] stringByDeletingPathExtension];
	return fileName;
}

- (void) getFileNameAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback{
	[self getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		NSArray* files = (NSArray*)data;
		NSURL* url = (NSURL*)[files objectAtIndex:i];
		if(url){
			NSString* filename = [self getFileNameFromPath:url];
			callback(FileLoaderResultOk, filename);
		}
	}];
}

- (void) getYourFilesWithCallback:(void(^)(FileLoaderResults result, id data))callback{
	NSNumber* isDir;
	NSError* error;
	NSMutableArray* files = [NSMutableArray array];
	NSArray* keys = @[NSURLNameKey, NSURLFileSizeKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey];
	NSDirectoryEnumerator* enumerator = [self.fileManager enumeratorAtURL:self.savesFolder includingPropertiesForKeys:keys options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
		return YES;
	}];
	for(NSURL* url in enumerator){
		[url getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:&error];
		[url getResourceValue:&isDir forKey:NSURLContentModificationDateKey error:&error];
		if([url.pathExtension isEqualToString:@"dat"]){
			[files addObject:url];
		}
	}
	[files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSURL* url1 = (NSURL*) obj1;
		NSURL* url2 = (NSURL*) obj2;
		NSDate* d1 = nil;
		NSDate* d2 = nil;
		[url1 getResourceValue:&d1 forKey:NSURLContentModificationDateKey error:nil];
		[url2 getResourceValue:&d1 forKey:NSURLContentModificationDateKey error:nil];
		if([d1 laterDate:d2]){
			return NSOrderedAscending;
		}
		else if([d2 laterDate:d1]){
			return NSOrderedDescending;
		}
		else {
			return NSOrderedSame;
		}
	}];
	callback(FileLoaderResultOk, files);
}

- (void) dealloc{
	
}

@end
