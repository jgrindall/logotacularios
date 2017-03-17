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
#import "PHelpDelegate.h"

@interface AbstractHelpViewController ()

@property Class childClass;
@property NSInteger numPages;
@property NSInteger currentPage;
@property NSInteger targetPage;
@property id<PHelpDelegate> helpDelegate;
@end

@implementation AbstractHelpViewController

- (instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options withChildClass:(Class)class andNumPages:(NSInteger)numPages andStartPage:(NSInteger)startPage andDelegate:(id<PHelpDelegate>)del{
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	if(self){
		self.dataSource = self;
		self.delegate = self;
		_childClass = class;
		_numPages = numPages;
		_helpDelegate = del;
		_currentPage = startPage;
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
	[self reloadPos];
}

- (void) reloadPos{
	[self gotoPage:self.currentPage];
}

- (void) gotoPage:(int)index{
	AbstractHelpSectionViewController *viewController = [self viewControllerAtIndex:index];
	NSInteger oldPageIndex = self.currentPage;
	self.currentPage = index;
	UIPageViewControllerNavigationDirection direction = (self.currentPage <= index) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
	if(oldPageIndex < index){
		for (int i = 0; i <= index; i++){
			if (i == index) {
				[self setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
			}
			else{
				[self setViewControllers:@[[self viewControllerAtIndex:i]] direction:direction animated:NO completion:nil];
			}
		}
	}
	else{
		for (int i = oldPageIndex; i >= index; i--){
			if (i == index) {
				[self setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
			}
			else{
				[self setViewControllers:@[[self viewControllerAtIndex:i]] direction:direction animated:NO completion:nil];
				
			}
		}
	}
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
	if(self.helpDelegate != nil){
		[self.helpDelegate onUpdate:self.targetPage];
	}
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
	self.helpDelegate = nil;
}

@end
