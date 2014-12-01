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
@property NSInteger currentPage;
@property NSInteger targetPage;

@end

@implementation AbstractHelpViewController

- (instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options withChildClass:(Class)class andNumPages:(NSInteger)numPages{
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	if(self){
		self.dataSource = self;
		self.delegate = self;
		_childClass = class;
		_numPages = numPages;
		_currentPage = 0;
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
	return self.currentPage;
}

- (void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
	AbstractHelpSectionViewController* v = (AbstractHelpSectionViewController*)[pendingViewControllers lastObject];
	if(v){
		self.targetPage = v.index;
	}
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
	if(previousViewControllers.count == 1){
		if(completed){
			self.currentPage = self.targetPage;
		}
	}
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

- (void) dealloc{
	self.delegate = nil;
	self.childClass = nil;
}

@end
