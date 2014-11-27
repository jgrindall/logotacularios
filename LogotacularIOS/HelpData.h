//
//  HelpData.h
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpData : NSObject

+ (NSDictionary*)getDictionary;

+ (NSString*) getHelpTop:(NSInteger)index;

+ (NSString*) getHelpContents:(NSInteger)index;

+ (NSString*) getHelpFile:(NSInteger)index;

+ (NSString*) getHelpMovie:(NSInteger)index;

+ (NSString*) getHelpMedia:(NSInteger)index;

+ (NSString*) getExampleData:(NSInteger)index;

+ (NSString*) getExampleFile:(NSInteger)index;

+ (NSString*) getExampleMedia:(NSInteger)index;

+ (NSString*) getRefData:(NSInteger)index;

+ (NSString*) getStyles;

@end
