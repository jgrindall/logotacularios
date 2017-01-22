//
//  MenuViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PColorPickerDelegate.h"

@interface ColorPopupController : UIViewController

- (void) setColor:(UIColor*)c;

@property id<PColorPickerDelegate> delegate;

@end
