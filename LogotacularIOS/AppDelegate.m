//
//  AppDelegate.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AppDelegate.h"
#import "DrawPageViewController.h"
#import "NavController.h"
#import "Appearance.h"
#import "InjectionModule.h"
#import "PCommandMap.h"
#import "SymmNotifications.h"
#import "Commands.h"
#import "FilesController.h"
#import "FileCell.h"

@interface AppDelegate ()

@property id<PCommandMap> commandMap;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self startInjection];
	[self start];
	return YES;
}

- (void) start{
	[self startCommands];
	[self setupWindow];
	[self applyStyles];
}

- (void) startCommands{
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_PLAY toCommandClass:[ClickPlayCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_MENU toCommandClass:[ClickMenuCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_HIDE_MENU toCommandClass:[HideMenuCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_UNDO toCommandClass:[UndoCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_REDO toCommandClass:[RedoCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLEAR toCommandClass:[ClearCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_OPEN toCommandClass:[ClickOpenCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_LOAD_FILES toCommandClass:[LoadFilesCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_PERFORM_OPEN toCommandClass:[PerformOpenCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_SAVE toCommandClass:[ClickSaveCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_PERFORM_DEL toCommandClass:[PerformDelCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_PERFORM_SAVE toCommandClass:[PerformSaveCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_PERFORM_SAVE_AS toCommandClass:[PerformSaveAsCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_TEXT_EDITED toCommandClass:[TextEditedCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_NEW toCommandClass:[ClickNewCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_PERFORM_NEW toCommandClass:[PerformNewCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_ERROR_HIT toCommandClass:[ErrorHitCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_HELP toCommandClass:[ClickHelpCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_TUT toCommandClass:[ClickTutCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_SYNTAX_ERROR toCommandClass:[SyntaxErrorCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CHANGE_PAGE toCommandClass:[ChangePageCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_PERFORM_FILE_SETUP toCommandClass:[PerformFileSetupCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_START toCommandClass:[StartCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_SAVE_AS toCommandClass:[ClickSaveAsCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_REF toCommandClass:[ClickRefCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_CLICK_RESET_ZOOM toCommandClass:[ClickResetZoomCommand class]];
	[[self getCommandMap] mapEventName:SYMM_NOTIF_LOAD_FROM_HELP toCommandClass:[LoadFromHelpCommand class]];
}

- (id<PCommandMap>)getCommandMap{
	if(!self.commandMap){
		self.commandMap = [[JSObjection defaultInjector] getObject:@protocol(PCommandMap)];
	}
	return self.commandMap;
}

- (void) startInjection{
	 JSObjectionModule* module = [[InjectionModule alloc] init];
	 JSObjectionInjector* injector = [JSObjection createInjector:module];
	 [JSObjection setDefaultInjector:injector];
}

- (UIViewController*) getRoot{
	return [[DrawPageViewController alloc] init];
}

- (void) setupWindow{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController* rootViewController = [self getRoot];
	self.navigationController = [[NavController alloc] initWithRootViewController:rootViewController];
	[self.window setRootViewController:self.navigationController];
	[self.window addSubview:self.navigationController.view];
	[self.window makeKeyAndVisible];
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


