//
//  ImageUtils.m
//  Symmetry
//
//  Created by John on 10/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ImageUtils.h"
#import "Appearance.h"
#import "SKBounceAnimation.h"

@interface ImageUtils()

@end

@implementation ImageUtils

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
	return cornerRadius * 2 + 1;
}

+ (BOOL) createContextWithSize:(CGSize)size{
	if(size.width <= 0 || size.height <= 0){
		NSLog(@">>>>>>> NO! %f %f", size.width, size.height);
		return NO;
	}
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	return YES;
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
	CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIImage* image;
	UIImage* resized;
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
	BOOL c = [ImageUtils createContextWithSize:rect.size];
	if(c){
		CGContextRef buffer = UIGraphicsGetCurrentContext();
		if(buffer){
			CGContextSetFillColorWithColor(buffer, color.CGColor);
			CGContextAddPath(buffer, roundedRect.CGPath);
			CGContextFillPath(buffer);
		}
		image = UIGraphicsGetImageFromCurrentImageContext();
		resized = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
		UIGraphicsEndImageContext();
	}
    return resized;
}

+ (UIImage *)imageWithOverlayColor:(UIImage*)src withColor:(UIColor *)color{
	CGRect rect = CGRectMake(0.0f, 0.0f, src.size.width, src.size.height);
	UIImage *image;
	BOOL c = [ImageUtils createContextWithSize:src.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		[src drawAtPoint:CGPointZero];
		CGContextSetBlendMode(context, kCGBlendModeSourceIn);
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, rect);
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return image;
}

+ (void) bounceAnimateView:(UIView*) view from:(float) fromPos to:(float) toPos withKeyPath:(NSString*) keyPath withKey:(NSString*) key withDelegate:(id)delegate withDuration:(float)duration withImmediate:(BOOL)immediate{
	[view.layer removeAllAnimations];
	NSNumber* finalValue = [NSNumber numberWithFloat:toPos];
	if(!immediate){
		SKBounceAnimation* bounceAnimation = [SKBounceAnimation animationWithKeyPath:keyPath];
		bounceAnimation.delegate = delegate;
		bounceAnimation.fromValue = [NSNumber numberWithFloat:fromPos];
		bounceAnimation.toValue = finalValue;
		bounceAnimation.duration = duration;
		bounceAnimation.numberOfBounces = 3;
		bounceAnimation.stiffness = SKBounceAnimationStiffnessLight;
		bounceAnimation.shouldOvershoot = YES;
		[view.layer addAnimation:bounceAnimation forKey:key];
	}
	[view.layer setValue:finalValue forKeyPath:keyPath];
}


@end
