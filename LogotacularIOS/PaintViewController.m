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
#import "PBgModel.h"
#import "ImageUtils.h"

@interface PaintViewController ()

@property PaintView* paintView;
@property NSMutableArray* constraints;
@property UIPanGestureRecognizer* pan;
@property UIPinchGestureRecognizer* pinch;

@property CGAffineTransform currentTransform;
@property CGAffineTransform startTransform;
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
		_currentTransform = CGAffineTransformIdentity;
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
	//[self addMotion];
}

- (void) addMotion{
	UIInterpolatingMotionEffect *verticalMotionEffect =	[[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffect.minimumRelativeValue = @(-10);
	verticalMotionEffect.maximumRelativeValue = @(10);
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontalMotionEffect.minimumRelativeValue = @(-10);
	horizontalMotionEffect.maximumRelativeValue = @(10);
	UIMotionEffectGroup *group = [UIMotionEffectGroup new];
	group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
	[self.view addMotionEffect:group];
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
	CGPoint p0 = [recognizer locationOfTouch:0 inView:self.view];
	CGPoint p1 = [recognizer locationOfTouch:1 inView:self.view];
	CGPoint p = CGPointMake((p0.x + p1.x)/2.0, (p0.y + p1.y)/2.0);
	if(recognizer.state == UIGestureRecognizerStateBegan){
		self.startTransform = self.currentTransform;
	}
	else if(recognizer.state == UIGestureRecognizerStateEnded){
		// end
	}
	CGPoint realPoint = [self getRealPoint:p];
	CGAffineTransform extraTransform = [PaintViewController getTransformForScale:scale andCentre:realPoint];
	self.currentTransform = CGAffineTransformConcat(self.startTransform, extraTransform);
	[self updateTransforms];
}

+ (CGAffineTransform)getTransformForScale:(float)f andCentre:(CGPoint) p{
	CGAffineTransform move = CGAffineTransformMakeTranslation(p.x, p.y);
	CGAffineTransform moveBack = CGAffineTransformMakeTranslation(-p.x, -p.y);
	CGAffineTransform scale = CGAffineTransformMakeScale(f, f);
	return CGAffineTransformConcat(CGAffineTransformConcat(moveBack, scale), move);
}

- (CGPoint)getRealPoint:(CGPoint)p{
	CGPoint p1 = CGPointMake(p.x - self.view.frame.size.width/2.0, p.y - self.view.frame.size.height/2.0);
	return CGPointApplyAffineTransform(p1, CGAffineTransformInvert(self.startTransform));
}

- (void)onPan:(UIPanGestureRecognizer*)recognizer{
	CGPoint t = [recognizer translationInView:self.view];
	if(recognizer.state == UIGestureRecognizerStateBegan) {
		self.startTransform = self.currentTransform;
	}
	float scale = [self getScale];
	scale = 1;
	CGAffineTransform trans = CGAffineTransformMakeTranslation(t.x/scale, t.y/scale);
	self.currentTransform = CGAffineTransformConcat(self.startTransform, trans);
	[self updateTransforms];
}

- (CGFloat)getScale {
	CGAffineTransform t = self.startTransform;
	return sqrt(t.a * t.a  +  t.c * t.c);
}

- (CGPoint) getTranslation{
	CGAffineTransform t = self.startTransform;
	return CGPointMake(t.tx, t.ty);
}

- (void)updateTransforms{
	[self.paintView transformWith:self.currentTransform];
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
	UIImage* image;
	if([ImageUtils createContextWithSize:self.view.bounds.size]){
		[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return image;
}

- (void) resetZoom{
	self.currentTransform = CGAffineTransformIdentity;
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
	[[self getBgModel] addListener:@selector(changeBg) forKey:BG_COLOR withTarget:self];
}

- (void) removeListeners{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SCREENGRAB toFunction:@selector(grab) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_CMD_RECEIVED toFunction:@selector(executeCommand:) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET toFunction:@selector(reset) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET_ZOOM toFunction:@selector(resetZoom) withContext:self];
	[[self getBgModel] removeListener:@selector(changeBg) forKey:BG_COLOR withTarget:self];
}

- (void) changeBg{
	UIColor* clr = [Colors getColorForString:[[self getBgModel] getVal:BG_COLOR]];
	[self.paintView bg:clr];
}

- (void) stop{
	
}

- (void) turn:(NSNumber*) amount{
	[[self getTurtleModel] rotateBy:[amount floatValue]];
}

- (void) bg:(NSString*) clrName{
	[[self getBgModel] setVal:clrName forKey:BG_COLOR];
}

- (id<PBgModel>)getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
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

