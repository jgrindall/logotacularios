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
#import <QuartzCore/QuartzCore.h>

@interface ImageUtils()

@end

@implementation ImageUtils

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
	return cornerRadius * 2 + 1;
}

+(UIImage*) drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point{
	UIFont *font = [UIFont boldSystemFontOfSize:12];
	UIGraphicsBeginImageContext(image.size);
	[image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
	CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
	[[UIColor whiteColor] set];
	NSDictionary *att = @{NSFontAttributeName:font};
	[text drawInRect:CGRectIntegral(rect) withAttributes:att];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (CGRect) getRectForRatio:(float)ratio inSize:(CGSize)containerSize{
	float w = containerSize.width;
	float h = containerSize.height;
	float containerRatio = w/h;
	if(containerRatio > ratio){
		return CGRectMake((w - ratio*h)/2.0, 0.0, ratio*h, h);
	}
	else{
		return CGRectMake(0.0, (h - (w/ratio))/2.0, w, w/ratio);
	}
}

+ (BOOL) createContextWithSize:(CGSize)size{
	if(size.width <= 0 || size.height <= 0){
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

+ (void) bounceAnimateView:(UIView*) view from:(float) fromPos to:(float) toPos withKeyPath:(NSString*) keyPath withKey:(NSString*) key withDelegate:(id)delegate withDuration:(float)duration withImmediate:(BOOL)immediate withHide:(BOOL)hide{
	[view.layer removeAllAnimations];
	NSNumber* finalValue = @(toPos);
	if(!immediate){
		SKBounceAnimation* bounceAnimation = [SKBounceAnimation animationWithKeyPath:keyPath];
		bounceAnimation.delegate = delegate;
		bounceAnimation.fromValue = @(fromPos);
		bounceAnimation.toValue = finalValue;
		bounceAnimation.duration = duration;
		bounceAnimation.numberOfBounces = 3;
		bounceAnimation.stiffness = SKBounceAnimationStiffnessLight;
		bounceAnimation.shouldOvershoot = YES;
		[view.layer addAnimation:bounceAnimation forKey:key];
	}
	[view.layer setValue:finalValue forKeyPath:keyPath];
}

+ (UIImage*) shadowImage:(CGSize)size withCurlX:(int)cx withCurlY:(int)cy{
	UIImage* shadow;
	BOOL c = [ImageUtils createContextWithSize:size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			CGMutablePathRef ref = CGPathCreateMutable();
			CGPathMoveToPoint(ref, NULL, 0, size.height - cy);
			CGPathAddLineToPoint(ref, NULL, cx, size.height);
			CGPathAddQuadCurveToPoint(ref, NULL, size.width/2, size.height - 2*cy, size.width - cx, size.height);
			CGPathAddLineToPoint(ref, NULL, size.width, size.height - cy);
			CGPathCloseSubpath(ref);
			CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
			CGContextAddPath(context, ref);
			CGContextFillPath(context);
			shadow = UIGraphicsGetImageFromCurrentImageContext();
			CGPathRelease(ref);
		}
		UIGraphicsEndImageContext();
	}
	return [ImageUtils blur:shadow];
}

+ (UIImage*) blur:(UIImage*)src {
	if(!src){
		return nil;
	}
	UIImage* result = src;
	int num = 1;
	for(int i = 1; i<= num; i++){
		result = [ImageUtils imageWithGaussianBlur9:result];
	}
	return result;
}

+ (void)shakeView:(UIView*)view{
	CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
	[shake setDuration:0.1];
	[shake setRepeatCount:2];
	[shake setAutoreverses:YES];
	[shake setFromValue:[NSValue valueWithCGPoint: CGPointMake(view.center.x - 5, view.center.y)]];
	[shake setToValue:[NSValue valueWithCGPoint: CGPointMake(view.center.x + 5, view.center.y)]];
	[view.layer addAnimation:shake forKey:@"position"];
}

+ (UIImage*)imageWithGaussianBlur9:(UIImage*)src {
	if(!src){
		return nil;
	}
	float weight[5] = {0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162};
	UIImage *horizBlurredImage;
	UIImage *blurredImage;
	BOOL c = [ImageUtils createContextWithSize:src.size];
	if(c){
		[src drawInRect:CGRectMake(0, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
		for (int x = 1; x < 5; ++x) {
			[src drawInRect:CGRectMake(x, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
			[src drawInRect:CGRectMake(-x, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
		}
		horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	c = [ImageUtils createContextWithSize:src.size];
	if(c){
		[horizBlurredImage drawInRect:CGRectMake(0, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
		for (int y = 1; y < 5; ++y) {
			[horizBlurredImage drawInRect:CGRectMake(0, y, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
			[horizBlurredImage drawInRect:CGRectMake(0, -y, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
		}
		blurredImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return blurredImage;
}

@end
