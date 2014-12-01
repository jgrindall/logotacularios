//
//  AbstractOverlayController.h
//  LogotacularIOS
//
//  Created by John on 01/12/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController.h"
#import "PLogoAlertDelegate.h"

@interface AbstractOverlayController : BaseViewController

@property id<PLogoAlertDelegate> delegate;
@property id options;

@end
