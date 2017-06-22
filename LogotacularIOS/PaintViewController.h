//
//  PaintViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"
#import "PCommandConsumer.h"

@interface PaintViewController : BaseViewController <UIGestureRecognizerDelegate, PCommandConsumer>

extern NSString* const FD_KEYWORD;
extern NSString* const ARC_KEYWORD;
extern NSString* const ARCRT_KEYWORD;
extern NSString* const ARCLT_KEYWORD;
extern NSString* const RT_KEYWORD;
extern NSString* const PENUP_KEYWORD;
extern NSString* const HOME_KEYWORD;
extern NSString* const PENDOWN_KEYWORD;
extern NSString* const BG_KEYWORD;
extern NSString* const COLOR_KEYWORD;
extern NSString* const THICK_KEYWORD;

- (void) reset;

- (void) queueCommand:(NSDictionary*)dic;

- (UIImage*)getImage;

- (void)consume:(NSDictionary*) data;

@end
