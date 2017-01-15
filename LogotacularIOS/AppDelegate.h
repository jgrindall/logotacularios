//
//  AppDelegate.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Objection/Objection.h>
#import "DrawPageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow*		window;
@property UINavigationController*			navigationController;
@property AContainerViewController*			rootViewController;

@end

