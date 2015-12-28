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

+ (NSString*) getHelpData:(NSInteger)index;

+ (NSString*) getHelpMedia:(NSInteger)index;

+ (NSString*) getHelpBg:(NSInteger)index;

+ (NSString*) getRefBg:(NSInteger)index;

+ (NSString*) getTutData:(NSInteger)index;

+ (NSString*) getTutBg:(NSInteger)index;

+ (NSString*) getTutFile:(NSInteger)index;

+ (NSString*) getTutMedia:(NSInteger)index;

+ (NSString*) getRefData:(NSInteger)index;

+ (NSString*) getStyles;

@end
