//
//  DrawingDocument.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileDocument.h"

@interface FileDocument ()

@property NSURL* url;

@end


@implementation FileDocument

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
	NSData* data = contents;
	self.obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	return YES;
}

- (id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
	if(!self.obj){
		self.obj = [[FileObject alloc] init];
	}
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.obj];
	return data;
}

- (void) saveWithCallback:(void(^)(FileLoaderResults result))callback{
	[self saveToURL:self.url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
		if(success){
			self.dirty = NO;
			callback(FileLoaderResultOk);
		}
		else{
			callback(FileLoaderResultUnknownError);
		}
	}];
}

- (id)initWithFileURL:url{
	self = [super initWithFileURL:url];
	if(self){
		self.dirty = NO;
		self.url = url;
	}
	return self;
}

@end
