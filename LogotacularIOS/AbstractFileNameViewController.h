//
//  AbstractFileNameViewController.h
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractAlertController_protected.h"

@interface AbstractFileNameViewController : AbstractAlertController <UITextFieldDelegate>

- (void) fileNameUsedError;

@end
