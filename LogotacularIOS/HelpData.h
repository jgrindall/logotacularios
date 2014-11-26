//
//  HelpData.h
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpData : NSObject

+ (NSString*) getTop:(NSInteger)index;

+ (NSString*) getContents:(NSInteger)index;

+ (NSDictionary*)getDictionary;

+ (NSString*) getMedia:(NSInteger)index;

+ (NSString*) getButtonPos:(NSInteger)index;

+ (NSString*) getExampleData:(NSInteger)index;

extern NSString* const STYLES;

@end
