//
//  AbstractHelpViewController.m
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractHelpViewController.h"
#import "AbstractHelpSectionViewController.h"
#import "HelpSectionViewController.h"

@interface AbstractHelpViewController ()

@property Class childClass;
@property NSInteger numPages;
@end

@implementation AbstractHelpViewController

- (instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options withChildClass:(Class)class andNumPages:(NSInteger)numPages{
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	if(self){
		self.dataSource = self;
		self.delegate = self;
		_childClass = class;
		_numPages = numPages;
	}
	return self;
}

- (AbstractHelpSectionViewController *)viewControllerAtIndex:(NSUInteger)index {
	AbstractHelpSectionViewController* childViewController = (AbstractHelpSectionViewController*)[[self.childClass alloc] initWithIndex:index];
	return childViewController;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self removeTap];
	[self initPage0];
}

- (void) removeTap{
	UIGestureRecognizer* tapRecognizer = nil;
	for(UIGestureRecognizer* recognizer in self.gestureRecognizers){
		if([recognizer isKindOfClass:[UITapGestureRecognizer class]]){
			tapRecognizer = recognizer;
			break;
		}
	}
	NSLog(@"tap is %@", tapRecognizer);
	if (tapRecognizer){
		[self.view removeGestureRecognizer:tapRecognizer];
	}
}

- (void) initPage0{
	AbstractHelpSectionViewController* initialViewController = [self viewControllerAtIndex:0];
	NSArray *viewControllers = @[initialViewController];
	[self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
	return self.numPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
	return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSUInteger index = [(AbstractHelpSectionViewController *)viewController index];
	if (index == 0) {
		return nil;
	}
	index--;
	return [self viewControllerAtIndex:index];
	
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSUInteger index = [(AbstractHelpSectionViewController *)viewController index];
	index++;
	if (index == self.numPages) {
		return nil;
	}
	return [self viewControllerAtIndex:index];
}

@end
