//
//  TextViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"

@interface TextViewController : BaseViewController <UIGestureRecognizerDelegate, UITextViewDelegate>

- (void) show;

- (void) hide;

- (NSString*) getText;

- (void) setText:(NSString*) text;

@end
