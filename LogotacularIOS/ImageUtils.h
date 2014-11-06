//
//  ImageUtils.h
//  Symmetry
//
//  Created by John on 10/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

+ (UIImage*) imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
+ (BOOL) createContextWithSize:(CGSize)size;
+ (UIImage *)imageWithOverlayColor:(UIImage*)src withColor:(UIColor *)color;
+ (void) bounceAnimateView:(UIView*) view from:(float) fromPos to:(float) toPos withKeyPath:(NSString*) keyPath withKey:(NSString*) key withDelegate:(id)delegate withDuration:(float)duration withImmediate:(BOOL)immediate;
+ (UIImage*) shadowImage:(CGSize)size withCurlX:(int)cx withCurlY:(int)cy;
+ (void)shakeView:(UIView*)view;

@end
