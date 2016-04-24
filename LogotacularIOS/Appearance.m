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
#import <Objection/Objection.h>
#import "PBgModel.h"

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
	id<PBgModel> model = [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
	UIColor* clr = [Colors getColorForString:[model getVal:BG_COLOR]];
	return clr;
}

+ (UIColor*) grayColor{
	return [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.45];
}

+ (NSDictionary*) navTextAttributes{
	UIColor* textColor = [UIColor whiteColor];
	UIFont* textFont = [Appearance fontOfSize:SYMM_FONT_SIZE_NAV];
	NSLog (@"%@", textFont);
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
	float w = 50;
	float h = 30;
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	if(label){
		w += 50;
		[btn setTitle:[NSString stringWithFormat:@" %@", label] forState:UIControlStateNormal];
	}
	btn.bounds = CGRectMake(0, 0, w, h);
	btn.frame = CGRectMake(-offset, 0, w, h);
	[btn setImage:img forState:UIControlStateNormal];
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
	[container addSubview:btn];
	UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
	return buttonItem;
}

+ (UIBarButtonItem*) getBarButton:(NSString*) imageUrl withLabel:(NSString*)label{
	return [self getBarButton:imageUrl withLabel:label andOffsetX:0];
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
	UIPageControl *pageControl = [UIPageControl appearance];
	pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.75];
	pageControl.currentPageIndicatorTintColor = [Appearance grayColor];
}

+ (UIFont*) fontOfSize:(SymmFontSizes)s{
	return [UIFont fontWithName:@"Lato-Light" size:s];
}

+ (UIFont*) monospaceFontOfSize:(SymmFontSizes)s{
	return [UIFont fontWithName:@"DroidSansMono" size:s];
}

+ (void)popupNavigationControllerClosed{
	[[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
}

+ (void)popupNavigationControllerOpened{
	UIColor* blue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
	[[UIApplication sharedApplication] keyWindow].tintColor = blue;
}

@end
