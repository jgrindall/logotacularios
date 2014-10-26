//
//  AppDelegate.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AppDelegate.h"
#import "DrawViewController.h"
#import "NavController.h"
#import "Appearance.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController* rootViewController = [[DrawViewController alloc] init];
	self.navigationController = [[NavController alloc] initWithRootViewController:rootViewController];
	[self.window setRootViewController:self.navigationController];
	[self.window addSubview:self.navigationController.view];
	[self.window makeKeyAndVisible];
	[self applyStyles];
	return YES;
}

- (void) applyStyles{
	[Appearance applyStylesInWindow:self.window];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application{
	//[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_STOP_ANIM object:nil userInfo:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
	//[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_STOP_ANIM object:nil userInfo:nil];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application{
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
}

@end


