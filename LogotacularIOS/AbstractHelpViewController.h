//
//  AbstractHelpViewController.h
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractHelpViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

- (instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options withChildClass:(Class)class andNumPages:(NSInteger)numPages;

@end
