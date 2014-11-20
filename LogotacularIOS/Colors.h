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

+(NSDictionary*) dictionary;

+ (NSArray*) getDark;

+ (UIColor*) getRandomDark;

@end


