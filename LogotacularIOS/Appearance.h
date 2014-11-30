//
//  Appearance.h
//  Symmetry
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Colors.h"
#import <UIKit/UIKit.h>

@interface Appearance : NSObject

typedef NS_ENUM(NSInteger, SymmFontSizes)  {
	SYMM_FONT_SIZE_LOGO =		21,
	SYMM_FONT_SIZE_MED =		24,
	SYMM_FONT_SIZE_NAV =		27,
	SYMM_FONT_SIZE_LARGE =		54
};

+ (void) applyStylesInWindow:(UIWindow*) window;
+ (void) flatToolbar:(UIToolbar*) toolbar;
+ (void) styleCollectionView:(UICollectionView*) collectionView;
+ (NSDictionary*) navTextAttributes;
+ (UIFont*) monospaceFontOfSize:(SymmFontSizes)s;
+ (UIFont*) fontOfSize:(SymmFontSizes)s;
+ (UIBarButtonItem*) getBarButton:(NSString*) imageUrl withLabel:(NSString*)label;
+ (UIBarButtonItem*) getBarButton:(NSString*) imageUrl withLabel:(NSString*)label andOffsetX:(NSInteger) offset;
+ (UIColor*) bgColor;
+ (UIColor*) grayColor;

@end
