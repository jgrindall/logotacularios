//
//  BaseViewController.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"
#import "AppDelegate.h"
#import "PLogger.h"
#import "PEventDispatcher.h"

@interface BaseViewController ()

@property id<PLogger> logger;
@property id<PEventDispatcher> eventDispatcher;

@end

@implementation BaseViewController

- (id<PLogger>) getLogger{
	if(!self.logger){
		self.logger = [[JSObjection defaultInjector] getObject:@protocol(PLogger)];
	}
	return self.logger;
}

- (id<PEventDispatcher>) getEventDispatcher{
	if(!self.eventDispatcher){
		self.eventDispatcher = [[JSObjection defaultInjector] getObject:@protocol(PEventDispatcher)];
	}
	return self.eventDispatcher;
}

- (void) bubbleSelector:(NSString*) selector withObject:(id) obj{
	SEL sel = NSSelectorFromString(selector);
	UIViewController* responder = self;
	while (responder.parentViewController != nil){
		responder = responder.parentViewController;
		if(responder && [responder respondsToSelector:sel]){
			IMP imp = [responder methodForSelector:sel];
			void (*func)(id, SEL, id) = (void*)imp;
			func(responder, sel, obj);
		}
	}
}

- (void)dealloc{
	
}

@end

