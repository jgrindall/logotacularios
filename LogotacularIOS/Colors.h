//
//  Colors.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Colors : NSObject

+ (UIColor*) getColorForString:(NSString*)name;

+ (NSDictionary*) dictionary;

+ (NSString*) getDark:(NSString*)s;

+ (UIColor*) darken:(UIColor*)c;

+ (UIColor*) darken:(UIColor*)c withAmount:(float) less;

+ (NSString*) getColorNameForNumber:(NSNumber*)num;

+ (UIColor*) getColorForNumber:(NSNumber*)num;

+ (UIColor*)stringToClr:(NSString*) value;

+ (NSString*)clrToString:(UIColor*)value;

@end


