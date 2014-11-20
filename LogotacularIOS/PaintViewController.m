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
#import "PTurtleModel.h"
#import "Colors.h"

@interface PaintViewController ()

@property PaintView* paintView;
@property NSMutableArray* constraints;
@property UIPanGestureRecognizer* pan;
@property UIPinchGestureRecognizer* pinch;
@property CGPoint currentTrans;
@property float currentScale;
@property CGPoint startTrans;
@property float startScale;

@end

@implementation PaintViewController

NSString* const FD_KEYWORD				= @"fd";
NSString* const RT_KEYWORD				= @"rt";
NSString* const PENUP_KEYWORD			= @"penup";
NSString* const PENDOWN_KEYWORD			= @"pendown";
NSString* const BG_KEYWORD				= @"bg";
NSString* const COLOR_KEYWORD			= @"color";
NSString* const THICK_KEYWORD			= @"thick";

- (instancetype) init{
	self = [super init];
	if(self){
		_currentTrans = CGPointMake(0.0, 0.0);
		_currentScale = 1.0;
		[self addListeners];
	}
	return self;
}

- (void) viewWillAppear:(BOOL)animated{
	[self layoutPaint];
}

- (void) viewDidLoad{
	[self addPaint];
	[self addGestures];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void) addGestures{
	self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
	self.pan.delegate = self;
	[self.view addGestureRecognizer:self.pan];
	self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
	self.pinch.delegate = self;
	[self.view addGestureRecognizer:self.pinch];
}

- (void)onPinch:(UIPinchGestureRecognizer*)recognizer{
	float scale = recognizer.scale;
	if(recognizer.state == UIGestureRecognizerStateBegan){
		self.startScale = self.currentScale;
	}
	else if(recognizer.state == UIGestureRecognizerStateEnded){
		// end
	}
	self.currentScale = self.startScale * scale;
	[self updateTransforms];
}

- (void)onPan:(UIPanGestureRecognizer*)recognizer{
	CGPoint translation = [recognizer translationInView:self.view];
	if(recognizer.state == UIGestureRecognizerStateBegan){
		self.startTrans = CGPointMake(self.currentTrans.x, self.currentTrans.y);
	}
	else if(recognizer.state == UIGestureRecognizerStateEnded){
		// end
	}
	self.currentTrans = CGPointMake(self.startTrans.x + translation.x * self.currentScale, self.startTrans.y + translation.y * self.currentScale);
	[self updateTransforms];
}

- (void)updateTransforms{
	[self.paintView transformWithScale:self.currentScale andTrans:self.currentTrans];
}

- (void) addPaint{
	self.paintView = [[PaintView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.paintView];
	self.paintView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (id<PScreenGrabModel>) getScreenGrabModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PScreenGrabModel)];
}

- (id<PTurtleModel>) getTurtleModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PTurtleModel)];
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

- (void) resetZoom{
	self.currentScale = 1.0;
	self.currentTrans = CGPointMake(0, 0);
	[self updateTransforms];
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
	[[self getEventDispatcher] addListener: SYMM_NOTIF_RESET_ZOOM toFunction:@selector(resetZoom) withContext:self];
}

- (void) removeListeners{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SCREENGRAB toFunction:@selector(grab) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_CMD_RECEIVED toFunction:@selector(executeCommand:) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET toFunction:@selector(reset) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET_ZOOM toFunction:@selector(resetZoom) withContext:self];
}

- (void) stop{
	
}

- (void) turn:(NSNumber*) amount{
	[[self getTurtleModel] rotateBy:[amount floatValue]];
}

- (void) bg:(NSString*) clrName{
	[self.paintView bg:[Colors getColorForString:clrName]];
}

- (void) color:(NSString*) clrName{
	UIColor* clr = [Colors getColorForString:clrName];
	[[self getTurtleModel] setVal:clr forKey:TURTLE_COLOR];
}

- (void) thick:(NSNumber*) amount{
	[[self getTurtleModel] setVal:amount forKey:TURTLE_PEN_THICK];
}

- (void) fd:(NSNumber*) amount{
	CGPoint p0 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
	[[self getTurtleModel] moveFdBy:[amount floatValue]];
	if([[[self getTurtleModel] getVal:TURTLE_PEN_DOWN] boolValue]){
		CGPoint p1 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
		NSNumber* thick = [[self getTurtleModel] getVal:TURTLE_PEN_THICK];
		UIColor* clr = [[self getTurtleModel] getVal:TURTLE_COLOR];
		[self.paintView drawLineFrom:p0 to:p1 withColor:clr andThickness:[thick integerValue]];
	}
}

- (void) executeCommand:(NSNotification*)notif{
	NSDictionary* dic = notif.object;
	NSString* name = (NSString*)dic[@"name"];
	if([name isEqualToString:FD_KEYWORD]){
		[self fd:(NSNumber*)dic[@"amount"]];
	}
	else if([name isEqualToString:RT_KEYWORD]){
		[self turn:(NSNumber*)dic[@"amount"]];
	}
	else if([name isEqualToString:BG_KEYWORD]){
		[self bg:(NSString*)dic[@"color"]];
	}
	else if([name isEqualToString:COLOR_KEYWORD]){
		[self color:(NSString*)dic[@"color"]];
	}
	else if([name isEqualToString:THICK_KEYWORD]){
		[self thick:(NSNumber*)dic[@"amount"]];
	}
	else if([name isEqualToString:PENUP_KEYWORD]){
		[[self getTurtleModel] setVal:[NSNumber numberWithBool:NO] forKey:TURTLE_PEN_DOWN];
	}
	else if([name isEqualToString:PENDOWN_KEYWORD]){
		[[self getTurtleModel] setVal:[NSNumber numberWithBool:YES] forKey:TURTLE_PEN_DOWN];
	}
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

