//
//  TextViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"

@interface TextViewController : BaseViewController <UIGestureRecognizerDelegate, UITextViewDelegate>

extern int const TEXT_PADDING;
extern int const HORIZ_PADDING;
extern int const EXCLAM_SIZE;

- (void) show;
- (void) hide;

@end
