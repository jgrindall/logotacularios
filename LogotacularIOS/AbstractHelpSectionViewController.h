//
//  AbstractHelpSectionViewController.h
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController.h"

@interface AbstractHelpSectionViewController : BaseViewController

@property NSInteger index;

- (void) exit;

- (instancetype) initWithIndex:(NSInteger)index;

@end
