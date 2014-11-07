//
//  PaintViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PaintViewController.h"
#import "PaintView.h"
#import "SymmNotifications.h"
#import "PScreenGrabModel.h"

@interface PaintViewController ()

@property PaintView* paintView;
@property NSMutableArray* constraints;

@end

@implementation PaintViewController

- (id) init{
	self = [super init];
	if(self){
		[self addListeners];
	}
	return self;
}

- (void) viewDidLoad{
	self.paintView = [[PaintView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.paintView];
	self.paintView.translatesAutoresizingMaskIntoConstraints = NO;
	[self layoutPaint];
	
}

- (id<PScreenGrabModel>) getScreenGrabModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PScreenGrabModel)];
}

- (void) grab{
	UIImage* img = [self getImage];
	[[self getScreenGrabModel] setVal:img forKey:SCREEN_GRAB];
}

- (UIImage*)getImage{
	UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (void) reset{
	[self stop];
	[self.paintView reset];
}

- (void) addListeners{
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SCREENGRAB toFunction:@selector(grab) withContext:self];
	[[self getEventDispatcher] addListener: SYMM_NOTIF_CMD_RECEIVED toFunction:@selector(executeCommand:) withContext:self];
	[[self getEventDispatcher] addListener: SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
	[[self getEventDispatcher] addListener: SYMM_NOTIF_RESET toFunction:@selector(reset) withContext:self];
}

- (void) removeListeners{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SCREENGRAB toFunction:@selector(grab) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_CMD_RECEIVED toFunction:@selector(executeCommand:) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET toFunction:@selector(reset) withContext:self];
}

- (void) stop{
	
}

- (void) executeCommand:(NSNotification*)notif{
	NSDictionary* dic = notif.object;
	[self.paintView execute:dic];
}

- (void) layoutPaint{
	NSLayoutConstraint* c0 = [NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
	[self.view addConstraint:c0];
	[self.view addConstraint:c1];
	[self.view addConstraint:c2];
	[self.view addConstraint:c3];
	[self.view addConstraint:c3];
	self.constraints = [NSMutableArray arrayWithObjects:c0, c1, c2, c3, nil];
}

- (void) dealloc{
	[self removeListeners];
	[self.view removeConstraints:self.constraints];
	[self.constraints removeAllObjects];
}

@end

