//
//  ExamplesPageViewController.h
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractHelpPageViewController_protected.h"

@interface TutPageViewController : AbstractHelpPageViewController

- (id) initWithStart:(NSInteger) startPage;

- (void) setListener:(void (^)(NSInteger))callbackBlock;

@end
