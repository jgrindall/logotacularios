//
//  Appearance.m
//  Symmetry
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Appearance.h"
#import "Colors.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "ImageUtils.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation Appearance

+ (void)applyStylesInWindow:(UIWindow*) window{
	[Appearance applyNavBarStyleInWindow:window];
	[Appearance applyToolBarStyleInWindow:window];
	[Appearance applyViewStyleInWindow:window];
	[[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
}

+ (NSDictionary*) navTextAttributes{
	UIColor* textColor = [UIColor whiteColor];
	UIFont* textFont = [Appearance fontOfSize:24];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName,  textColor, NSForegroundColorAttributeName, nil];
	return  dic;
}

+ (void) applyNavBarStyleInWindow:(UIWindow*) window{
	float c = 0.6;
	UIColor* g = [UIColor colorWithRed:c green:c blue:c alpha:0.25];
	UINavigationController* navigationController = (UINavigationController*) (window.rootViewController);
	UINavigationBar* bar = navigationController.navigationBar;
	bar.titleTextAttributes = [Appearance navTextAttributes];
    [bar setBackgroundImage:[ImageUtils imageWithColor:g cornerRadius:0] forBarMetrics:UIBarMetricsDefault & UIBarMetricsCompact];
	if ([bar respondsToSelector:@selector(setShadowImage:)]) {
        [bar setShadowImage:[ImageUtils imageWithColor:g cornerRadius:0]];
    }
}

+ (void) applyToolBarStyleInWindow:(UIWindow*) window{
	[[UIToolbar appearance] setBackgroundColor:[UIColor whiteColor]];
}

+ (void) styleCollectionView:(UICollectionView*) collectionView{
	UIView *bgView = [[UIView alloc] init];
	bgView.backgroundColor = [UIColor whiteColor];
	[collectionView.backgroundView removeFromSuperview];
	collectionView.backgroundView = bgView;
}

+ (void) applyViewStyleInWindow:(UIWindow*) window{
	[[UILabel appearance] setBackgroundColor:[UIColor clearColor]];
	[[UITextView appearance] setBackgroundColor:[UIColor clearColor]];
	[[UICollectionView appearance] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[UICollectionView class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[UICollectionViewController class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIImageView appearance] setBackgroundColor:[UIColor clearColor]];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[Appearance fontOfSize:16], NSFontAttributeName,  [UIColor orangeColor], NSForegroundColorAttributeName, nil];
	NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[Appearance fontOfSize:16], NSFontAttributeName, [UIColor purpleColor], NSForegroundColorAttributeName, nil];
	[[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:dic1 forState:UIControlStateNormal];
}

+ (void) flatToolbar:(UIToolbar*) toolbar{
	toolbar.translucent = NO;
	toolbar.barTintColor = [UIColor whiteColor];
	toolbar.layer.borderWidth = 0;
	toolbar.layer.borderColor = [[UIColor clearColor] CGColor];
	[toolbar setClipsToBounds:YES];
}

+ (UIFont*) fontOfSize:(SymmFontSizes)s{
	static dispatch_once_t onceToken0;
	NSString* fontName = @"Lato-Regular";
	NSURL* url = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf" subdirectory:@"assets/fonts"];
	if(url){
		dispatch_once(&onceToken0, ^{
			CFErrorRef error;
			if(!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error)){
				NSLog(@"failed to register 0 %@", error);
			}
		});
	}
	else{
		NSLog(@"failed to register 0 url");
	}
	return [UIFont fontWithName:fontName size:s];
}

+ (UIFont*) monospaceFontOfSize:(SymmFontSizes)s{
	static dispatch_once_t onceToken1;
	NSString* fontName = @"Inconsolata-Regular";
	NSURL* url = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf" subdirectory:@"assets/fonts"];
	if(url){
		dispatch_once(&onceToken1, ^{
			CFErrorRef error;
			if(!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error)){
				NSLog(@"failed to register 1 %@", error);
			}
		});
	}
	else{
		NSLog(@"failed to register 1 url");
	}
	return [UIFont fontWithName:fontName size:s];
}

@end
