//
//  AContainerViewController.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AContainerViewController_Protected.h"

@interface AContainerViewController ()

@end

@implementation AContainerViewController

- (void) addChildInto:(UIView*) container withController:(UIViewController*) controller{
	[container addSubview:controller.view];
	controller.view.frame = container.frame;
	[self addChildViewController:controller];
	[controller viewWillAppear:NO];
	[controller willMoveToParentViewController:self];
	[controller didMoveToParentViewController:self];
	[controller viewDidAppear:NO];
}

- (void) removeChildFrom:(UIView*) container withController:(UIViewController*) controller{
	if(container && container.subviews.count >= 1 && controller){
		[controller willMoveToParentViewController:nil];
		UIView* currentChild = container.subviews[0];
		[controller viewWillDisappear:NO];
		[currentChild removeFromSuperview];
		[controller removeFromParentViewController];
		[controller viewWillDisappear:NO];
	}
}

@end
