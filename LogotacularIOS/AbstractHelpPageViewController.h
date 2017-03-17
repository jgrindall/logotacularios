//
//  AbstractHelpPageViewController.h
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AContainerViewController_Protected.h"

@interface AbstractHelpPageViewController : AContainerViewController

- (instancetype)initWithChildClass:(Class) childClass andNumPages:(NSInteger)numPages andStartPage:(NSInteger)startPage;

@end
