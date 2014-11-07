//
//  AbstractAlertController.h
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"
#import "PLogoAlertDelegate.h"

@interface AbstractAlertController : BaseViewController

@property id<PLogoAlertDelegate> delegate;
@property id options;

@end
