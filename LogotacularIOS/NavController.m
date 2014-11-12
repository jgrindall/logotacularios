//
//  NavController.m
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "NavController.h"
#import "SymmNotifications.h"
#import "SpinnerView.h"
#import "AppDelegate.h"
#import "PEventDispatcher.h"
#import "PLogger.h"

@interface NavController ()

typedef NS_ENUM(NSInteger, SpinnerStatus)  {
	SpinnerStatusNone = 0,
	SpinnerStatusShown
};

@property SpinnerStatus spinnerShown;
@property UIView* spinnerView;
@property NSArray* spinnerConstraints;
@property id<PEventDispatcher> eventDispatcher;
@property id<PLogger> logger;

@end

@implementation NavController

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController{
	self = [super initWithRootViewController:rootViewController];
	if(self){
		[self setup];
	}
	return self;
}

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

- (void)setup{
	self.spinnerShown = SpinnerStatusNone;
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SHOW_SPINNER toFunction:@selector(showSpinner) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_HIDE_SPINNER toFunction:@selector(hideSpinner) withContext:self];
}

- (void) alert:(NSNotification*) notification{
	NSString* val = (NSString*)[((NSDictionary*)notification.userInfo) valueForKey:@"message"];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"No!" message:val delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alertView show];
}

- (void) showSpinner{
	self.spinnerView = [[SpinnerView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.spinnerView];
	[self layoutSpinner];
	self.spinnerShown = SpinnerStatusShown;
}

- (void) layoutSpinner{
	self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	self.spinnerConstraints = @[c1, c2, c3, c4];
	[self.view addConstraints:self.spinnerConstraints];
}

- (void) hideSpinner{
	[self.view removeConstraints:self.spinnerConstraints];
	[self.spinnerView removeFromSuperview];
	self.spinnerView = nil;
	self.spinnerShown = SpinnerStatusNone;
}

- (void) dealloc{
	[self hideSpinner];
	self.spinnerConstraints = nil;
	[self.eventDispatcher removeListener:SYMM_NOTIF_SHOW_SPINNER toFunction:@selector(showSpinner) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_HIDE_SPINNER toFunction:@selector(hideSpinner) withContext:self];
}

@end

