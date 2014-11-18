//
//  PaintViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"

@interface PaintViewController : BaseViewController

extern NSString* const FD_KEYWORD;
extern NSString* const RT_KEYWORD;
extern NSString* const PENUP_KEYWORD;
extern NSString* const PENDOWN_KEYWORD;
extern NSString* const BG_KEYWORD;
extern NSString* const COLOR_KEYWORD;
extern NSString* const THICK_KEYWORD;

- (void) reset;

- (void) executeCommand:(NSDictionary*)dic;

- (UIImage*)getImage;

@end
