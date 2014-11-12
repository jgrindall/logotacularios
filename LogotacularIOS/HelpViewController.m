//
//  HelpViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpSectionViewController.h"

@implementation HelpViewController

- (instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options{
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	if(self){
		self.dataSource = self;
		self.delegate = self;
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self initPage0];
}

- (void) initPage0{
	HelpSectionViewController* initialViewController = [self viewControllerAtIndex:0];
	NSArray *viewControllers = @[initialViewController];
	[self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (HelpSectionViewController *)viewControllerAtIndex:(NSUInteger)index {
	HelpSectionViewController *childViewController = [[HelpSectionViewController alloc] init];
	childViewController.index = index;
	return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSUInteger index = [(HelpSectionViewController *)viewController index];
	if (index == 0) {
		return nil;
	}
	index--;
	return [self viewControllerAtIndex:index];
	
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
	return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
	return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSUInteger index = [(HelpSectionViewController *)viewController index];
	index++;
	if (index == 5) {
		return nil;
	}
	return [self viewControllerAtIndex:index];
}

@end

