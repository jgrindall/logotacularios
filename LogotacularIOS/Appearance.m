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

+ (UIColor*) bgColor{
	float r;
	float g;
	float b;
	
	//r = 230.0;
	//g = 126.0;
	//b = 34.0;
	
	//r = 155;
	//g = 89;
	//b = 182;
	
	//r = 52;
	//g = 152;
	//b = 219;
	
	r = 231;
	g = 76;
	b = 60;
	
	
	return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1];
}

+ (UIColor*) grayColor{
	return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
}

+ (NSDictionary*) navTextAttributes{
	UIColor* textColor = [UIColor whiteColor];
	UIFont* textFont = [Appearance fontOfSize:SYMM_FONT_SIZE_NAV];
	NSDictionary* dic = @{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor};
	return  dic;
}

+ (void) applyNavBarStyleInWindow:(UIWindow*) window{
	UIColor* g = [Appearance grayColor];
	UINavigationController* navigationController = (UINavigationController*) (window.rootViewController);
	UINavigationBar* bar = navigationController.navigationBar;
	bar.titleTextAttributes = [Appearance navTextAttributes];
    [bar setBackgroundImage:[ImageUtils imageWithColor:g cornerRadius:0] forBarMetrics:UIBarMetricsDefault & UIBarMetricsCompact];
	if ([bar respondsToSelector:@selector(setShadowImage:)]) {
        [bar setShadowImage:[ImageUtils imageWithColor:g cornerRadius:0]];
    }
}

+ (UIBarButtonItem*) getBarButton:(NSString*) imageUrl withLabel:(NSString*)label andOffsetX:(NSInteger)offset{
	float w = 80;
	float h = 30;
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.bounds = CGRectMake(0, 0, w, h);
	btn.frame = CGRectMake(-offset, 0, w, h);
	if(label){
		[btn setTitle:[NSString stringWithFormat:@" %@", label] forState:UIControlStateNormal];
	}
	[btn setImage:img forState:UIControlStateNormal];
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
	[container addSubview:btn];
	UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
	return buttonItem;
}

+ (UIBarButtonItem*) getBarButton:(NSString*) imageUrl withLabel:(NSString*)label{
	return [self getBarButton:imageUrl withLabel:label];
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
	NSDictionary* dic = @{NSFontAttributeName:[Appearance fontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
	[[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:dic forState:UIControlStateNormal];
}

+ (void) flatToolbar:(UIToolbar*) toolbar{
	toolbar.translucent = NO;
	toolbar.barTintColor = [UIColor whiteColor];
	toolbar.layer.borderWidth = 0;
	toolbar.layer.borderColor = [[UIColor clearColor] CGColor];
	[toolbar setClipsToBounds:YES];
}

+ (UIFont*) fontOfSize:(SymmFontSizes)s{
	return [UIFont fontWithName:@"Lato-Regular" size:s];
}

+ (UIFont*) monospaceFontOfSize:(SymmFontSizes)s{
	return [UIFont fontWithName:@"DroidSansMono" size:s];
}

@end
