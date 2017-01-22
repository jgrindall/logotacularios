//
//  MenuViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"
#import "PLogoAlertDelegate.h"
#import "AContainerViewController_Protected.h"
#import "PColorPickerDelegate.h"

@interface GridMenuViewController : AContainerViewController <PLogoAlertDelegate, UIPopoverPresentationControllerDelegate, PColorPickerDelegate>

- (void) show;

- (void) hide;

@end
