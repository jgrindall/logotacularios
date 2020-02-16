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
@property NSURL* saveImgsFolder;
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

- (instancetype)init {
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
	NSURL* imgsFolder = [folder URLByAppendingPathComponent:@"imgs"];
	BOOL folderExists = [self.fileManager fileExistsAtPath:[folder path]];
	if(!folderExists){
		[self.fileManager createDirectoryAtURL:folder withIntermediateDirectories:YES attributes:nil error:&error];
		if(error) {
			return NO;
		}
	}
	BOOL imgsFolderExists = [self.fileManager fileExistsAtPath:[imgsFolder path]];
	if(!imgsFolderExists){
		[self.fileManager createDirectoryAtURL:imgsFolder withIntermediateDirectories:YES attributes:nil error:&error];
		if(error) {
			return NO;
		}
	}
	self.savesFolder = folder;
	self.saveImgsFolder = imgsFolder;
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
	NSData *imageData = UIImagePNGRepresentation([FileLoader scaledImage:img]);
	[imageData writeToURL:fullImagePath atomically:YES];
	callback(FileLoaderResultOk);
}

+ (UIImage*) scaledImage:(UIImage*)imageIn{
	UIImage* scaledImage;
	CGSize imageSize = CGSizeMake(256, 192);
	if([ImageUtils createContextWithSize:imageSize]){
		[imageIn drawInRect:CGRectMake(0,0,imageSize.width, imageSize.height)];
		scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return scaledImage;
}

- (void) deleteFileAtItem:(NSInteger) item withCallback:(void(^)(FileLoaderResults result))callback{
	[self getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSArray* files = (NSArray*)data;
			NSURL* url = files[item];
			NSError* error = nil;
			// check if it is the open file!
			[self.fileManager removeItemAtURL:url error:&error];
			if(error){
				callback(FileLoaderResultError);
			}
			else{
				callback(FileLoaderResultOk);
			}
		}
		else{
			callback(FileLoaderResultError);
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
		if(result == FileLoaderResultOk){
			NSArray* files = (NSArray*)data;
			NSURL* url = files[i];
			[self openFileAtURL:url withCallback:callback];
		}
		else{
			callback(FileLoaderResultError, nil);
		}
	}];
}

- (void) filenameOk:(NSString*)name withCallback:(void(^)(FileLoaderResults result, id data))callback{
	[self getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSNumber* ok = @YES;
			NSArray* files = (NSArray*)data;
			for(NSURL* url in files){
				if(url){
					NSString* filename = [self getFileNameFromPath:url];
					if([filename isEqualToString:name]){
						ok = @NO;
						break;
					}
				}
			}
			callback(FileLoaderResultOk, ok);
		}
		else{
			callback(FileLoaderResultError, nil);
		}
	}];
}

- (NSString*)getFileNameFromPath:(NSURL*)path{
	NSString* fileName = [[path lastPathComponent] stringByDeletingPathExtension];
	return fileName;
}

- (void) getFileNameAtIndex:(NSInteger)i withCallback:(void(^)(FileLoaderResults result, id data))callback{
	[self getYourFilesWithCallback:^(FileLoaderResults result, id data) {
		if(result == FileLoaderResultOk){
			NSArray* files = (NSArray*)data;
			NSURL* url = (NSURL*)files[i];
			if(url){
				NSString* filename = [self getFileNameFromPath:url];
				callback(FileLoaderResultOk, filename);
			}
		}
		else{
			callback(FileLoaderResultError, nil);
		}
	}];
}

- (UIImage*) getBgWithName{
	return [UIImage imageNamed:@"123.png"];
}

- (void) getImgsWithCallback:(NSURL*)folder withCallback: (void (^)(FileLoaderResults, id))callback{
	NSNumber* isDir;
	NSError* error;
	NSMutableArray* files = [NSMutableArray array];
	NSArray* keys = @[NSURLNameKey, NSURLFileSizeKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey];
	NSDirectoryEnumerator* enumerator = [self.fileManager enumeratorAtURL:self.saveImgsFolder includingPropertiesForKeys:keys options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
		return YES;
	}];
	for(NSURL* url in enumerator){
		[url getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:&error];
		[url getResourceValue:&isDir forKey:NSURLContentModificationDateKey error:&error];
		if([url.pathExtension isEqualToString:@"png"] || [url.pathExtension isEqualToString:@"jpg"]){
			[files addObject:url];
		}
	}
	[files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSURL* url1 = (NSURL*) obj1;
		NSURL* url2 = (NSURL*) obj2;
		NSString* name1 = [[url1 lastPathComponent] stringByDeletingPathExtension];
		NSString* name2 = [[url2 lastPathComponent] stringByDeletingPathExtension];
		return [name1 compare:name2];
	}];
	callback(FileLoaderResultOk, files);
}

- (void) getYourImgsWithCallback:(void(^)(FileLoaderResults result, id data))callback{
	[self getImgsWithCallback:self.saveImgsFolder withCallback:callback];
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
