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
#import "PGridModel.h"
#import "Colors.h"
#import "PBgModel.h"
#import "ImageUtils.h"
#import "PDrawingModel.h"
#import "AbstractModel.h"

@interface PaintViewController ()

@property PaintView* paintView;
@property NSMutableArray* constraints;
@property UIPanGestureRecognizer* pan;
@property UIPinchGestureRecognizer* pinch;
@property NSMutableArray* cmds;
@property CGAffineTransform currentTransform;
@property CGAffineTransform startTransform;

@end

@implementation PaintViewController

static float const maxAllowed = 2000000000.0;
static float const minAllowed = -2000000000.0;

NSString* const FD_KEYWORD				= @"fd";
NSString* const SETXY_KEYWORD			= @"setxy";
NSString* const LABEL_KEYWORD			= @"label";
NSString* const RT_KEYWORD				= @"rt";
NSString* const PENUP_KEYWORD			= @"penup";
NSString* const HOME_KEYWORD			= @"home";
NSString* const PENDOWN_KEYWORD			= @"pendown";
NSString* const BG_KEYWORD				= @"bg";
NSString* const COLOR_KEYWORD			= @"color";
NSString* const THICK_KEYWORD			= @"thick";

- (instancetype) init{
	self = [super init];
	if(self){
		_currentTransform = CGAffineTransformIdentity;
		_cmds = [NSMutableArray array];
		[[self getTurtleModel] reset];
		[self addListeners];
	}
	return self;
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutPaint];
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addPaint];
	[self addGestures];
	[self.paintView onViewDidLoad];
	[self changeGrid];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return NO;
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
	id<PDrawingModel> d = [self getDrawingModel];
	if([[d getVal:DRAWING_ISDRAWING] boolValue]){
		return;
	}
	float scale = recognizer.scale;
	NSInteger numTouches = [recognizer numberOfTouches];
	if(numTouches >= 2){
		CGPoint p0 = [recognizer locationOfTouch:0 inView:self.view];
		CGPoint p1 = [recognizer locationOfTouch:1 inView:self.view];
		CGPoint p = CGPointMake((p0.x + p1.x)/2.0, (p0.y + p1.y)/2.0);
		if(recognizer.state == UIGestureRecognizerStateBegan){
			self.startTransform = self.currentTransform;
		}
		float currentScale = (float)[self getScale:self.startTransform];
		scale = MAX(MIN(scale, 3.0f/currentScale), 0.2f/currentScale);
		CGPoint realPoint = [self getRealPoint:p];
		CGAffineTransform extraTransform = [PaintViewController getTransformForScale:scale andCentre:realPoint];
		self.currentTransform = CGAffineTransformConcat(self.startTransform, extraTransform);
		[self updateTransforms];
		[self checkEnded:recognizer.state];
	}
}

- (void) checkEnded:(UIGestureRecognizerState)state{
	if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateFailed || state == UIGestureRecognizerStateCancelled){
		[self flushTransforms];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESTART withData:nil];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_STOP withData:nil];
	}
}

- (void) flushTransforms{
	[self.paintView flushTransformsWith:self.currentTransform];
	self.currentTransform = CGAffineTransformIdentity;
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
	id<PDrawingModel> d = [self getDrawingModel];
	if([[d getVal:DRAWING_ISDRAWING] boolValue]){
		return;
	}
	CGPoint t = [recognizer translationInView:self.view];
	if(recognizer.state == UIGestureRecognizerStateBegan) {
		self.startTransform = self.currentTransform;
	}
	CGFloat scale = 1.0;
	CGAffineTransform trans = CGAffineTransformMakeTranslation(t.x/scale, t.y/scale);
	self.currentTransform = CGAffineTransformConcat(self.startTransform, trans);
	[self updateTransforms];
	[self checkEnded:recognizer.state];
}

- (CGFloat)getScale:(CGAffineTransform)t {
	return sqrt(t.a * t.a  +  t.c * t.c);
}

- (CGPoint) getTranslation:(CGAffineTransform)t{
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

- (id<PGridModel>) getGridModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PGridModel)];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
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
	[self.paintView setFlushedTransform:CGAffineTransformIdentity];
	[self updateTransforms];
}

- (void) reset{
	[self.paintView reset];
}

- (void)consume:(NSDictionary*) data{
	[self queueCommand:data];
}

- (void) addListeners{
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SCREENGRAB toFunction:@selector(grab) withContext:self];
	[[self getEventDispatcher] addListener: SYMM_NOTIF_RESET toFunction:@selector(reset) withContext:self];
	[[self getEventDispatcher] addListener: SYMM_NOTIF_RESET_ZOOM toFunction:@selector(resetZoom) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_RESTART_QUEUE toFunction:@selector(restart) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_CLEAR_QUEUE toFunction:@selector(clrQueue) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_TRI toFunction:@selector(onTri) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_HIDE_TRI toFunction:@selector(onHideTri) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_CLICK_TRI toFunction:@selector(onClickTri:) withContext:self];
	[[self getBgModel] addListener:@selector(changeBg) forKey:BG_COLOR withTarget:self];
	[[self getGridModel] addListener:@selector(changeGrid) forKey:GRID_TYPE withTarget:self];
}

- (void) removeListeners{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SCREENGRAB toFunction:@selector(grab) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET toFunction:@selector(reset) withContext:self];
	[[self getEventDispatcher] removeListener: SYMM_NOTIF_RESET_ZOOM toFunction:@selector(resetZoom) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_RESTART_QUEUE toFunction:@selector(restart) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_CLEAR_QUEUE toFunction:@selector(clrQueue) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_TRI toFunction:@selector(onTri) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_HIDE_TRI toFunction:@selector(onHideTri) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_CLICK_TRI toFunction:@selector(onClickTri:) withContext:self];
	[[self getBgModel] removeListener:@selector(changeBg) forKey:BG_COLOR withTarget:self];
	[[self getGridModel] removeListener:@selector(changeGrid) forKey:GRID_TYPE withTarget:self];
}

- (void) changeGrid{
	id val = [[self getGridModel] getVal:GRID_TYPE];
	int grid = (int)[val integerValue];
	[[self paintView] setGridType:grid];
}

- (void) onClickTri:(NSNotification*)notif{
	BOOL hideTri = [notif.object boolValue];
	[self.paintView clickTriangle:hideTri];
}

- (void) onHideTri{
	[self.paintView hideTriangle];
}

- (void) onTri{
	CGPoint p = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
	float heading = [[[self getTurtleModel] getVal:TURTLE_HEADING] floatValue];
	UIColor* clr = [[self getTurtleModel] getVal:TURTLE_COLOR];
	[self.paintView drawTriangleAt:p withHeading:heading withColor:clr];
	
	[self.paintView drawGrid];
}

- (void)clrQueue{
	[self.cmds removeAllObjects];
}

- (void) restart{
	for (NSDictionary* dic in self.cmds) {
		[self executeOneCommandAsDic:dic];
	}
}

- (void) changeBg{
	UIColor* clr = [Colors getColorForString:[[self getBgModel] getVal:BG_COLOR]];
	[self.paintView bg:clr];
}

- (void) turn:(NSNumber*) amount{
	if ([amount isKindOfClass:[NSNull class]]){
		[self numericalOverflow];
	}
	else{
		float f = [amount floatValue];
		if(f > maxAllowed || f < minAllowed){
			[self numericalOverflow];
		}
		else{
			[[self getTurtleModel] rotateBy:f];
		}
	}
}

- (void) bg:(NSDictionary*) dic{
	NSString* clrName;
	NSNumber* clrIndex;
	if ([dic objectForKey:@"colorname"]){
		clrName = (NSString*)dic[@"colorname"];
		[[self getBgModel] setVal:clrName forKey:BG_COLOR];
	}
	else if ([dic objectForKey:@"colorindex"]){
		clrIndex = (NSNumber*)dic[@"colorindex"];
		clrName = [Colors getColorNameForNumber:clrIndex];
		[[self getBgModel] setVal:clrName forKey:BG_COLOR];
	}
}

- (void) color:(NSDictionary*) dic{
	UIColor* clr;
	NSNumber* clrIndex;
	if ([dic objectForKey:@"colorname"]){
		NSString* clrName = (NSString*)dic[@"colorname"];
		clr = [Colors getColorForString:clrName];
		[[self getTurtleModel] setVal:clr forKey:TURTLE_COLOR];
	}
	else if ([dic objectForKey:@"colorindex"]){
		clrIndex = (NSNumber*)dic[@"colorindex"];
		clr = [Colors getColorForNumber:clrIndex];
		[[self getTurtleModel] setVal:clr forKey:TURTLE_COLOR];
	}
}

- (id<PBgModel>)getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
}

- (void) thick:(NSNumber*) amount{
	[[self getTurtleModel] setVal:amount forKey:TURTLE_PEN_THICK];
}

- (void) numericalOverflow{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_PLAY withData:nil];
	NSDictionary* error = @{@"message":@"An overflow occurred, one of your variables became too large."};
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_ERROR_HIT withData:error];
}

- (void) home{
	[[self getTurtleModel] home];
}

- (void) label:(NSString*) contents{
	CGPoint p0 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
	UIColor* clr = [[self getTurtleModel] getVal:TURTLE_COLOR];
	[self drawTextAt:p0 withColor:clr andString:contents];
}

- (void) setxyWithX:(NSNumber*) x andY:(NSNumber*) y{
	if ([x isKindOfClass:[NSNull class]] || [y isKindOfClass:[NSNull class]]){
		[self numericalOverflow];
	}
	else{
		float fx = [x floatValue];
		float fy = [y floatValue];
		if(fx > maxAllowed || fx < minAllowed || fy > maxAllowed || fy < minAllowed){
			[self numericalOverflow];
		}
		else{
			CGPoint p0 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
			[[self getTurtleModel] setxyWithX:fx andY:fy];
			if([[[self getTurtleModel] getVal:TURTLE_PEN_DOWN] boolValue]){
				CGPoint p1 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
				[self drawLineFrom:p0 to: p1];
			}
		}
	}
}

- (void) drawTextAt:(CGPoint)p withColor:(UIColor*) clr andString:(NSString*)s {
	[self.paintView drawTextAt:p withColor:clr andString:s];
}

- (void) drawLineFrom: (CGPoint)p0 to: (CGPoint)p1{
	NSNumber* thick = [[self getTurtleModel] getVal:TURTLE_PEN_THICK];
	UIColor* clr = [[self getTurtleModel] getVal:TURTLE_COLOR];
	[self.paintView drawLineFrom:p0 to:p1 withColor:clr andThickness:[thick integerValue]];
}

- (void) fd:(NSNumber*) amount{
	if ([amount isKindOfClass:[NSNull class]]){
		[self numericalOverflow];
	}
	else{
		float f = [amount floatValue];
		if(f > maxAllowed || f < minAllowed){
			[self numericalOverflow];
		}
		else{
			CGPoint p0 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
			[[self getTurtleModel] moveFdBy:f];
			if([[[self getTurtleModel] getVal:TURTLE_PEN_DOWN] boolValue]){
				CGPoint p1 = [[[self getTurtleModel] getVal:TURTLE_POS] CGPointValue];
				[self drawLineFrom:p0 to: p1];
			}
		}
	}
}

- (void) queueCommand:(NSDictionary*)data{
	[self.cmds addObject:data];
	[self executeCommand];
}

- (void) executeOneCommandAsDic:(NSDictionary*)dic{
	NSString* name = (NSString*)dic[@"name"];
	if([name isEqualToString:FD_KEYWORD]){
		[self fd:(NSNumber*)dic[@"amount"]];
	}
	else if([name isEqualToString:SETXY_KEYWORD]){
		[self setxyWithX:(NSNumber*)dic[@"amountX"] andY:(NSNumber*)dic[@"amountY"]];
	}
	else if([name isEqualToString:LABEL_KEYWORD]){
		[self label:(NSString*)dic[@"contents"]];
	}
	else if([name isEqualToString:RT_KEYWORD]){
		[self turn:(NSNumber*)dic[@"amount"]];
	}
	else if([name isEqualToString:BG_KEYWORD]){
		[self bg:dic];
	}
	else if([name isEqualToString:COLOR_KEYWORD]){
		[self color:dic];
	}
	else if([name isEqualToString:THICK_KEYWORD]){
		[self thick:(NSNumber*)dic[@"amount"]];
	}
	else if([name isEqualToString:PENUP_KEYWORD]){
		[[self getTurtleModel] setVal:[NSNumber numberWithBool:NO] forKey:TURTLE_PEN_DOWN];
	}
	else if([name isEqualToString:HOME_KEYWORD]){
		[self home];
	}
	else if([name isEqualToString:PENDOWN_KEYWORD]){
		[[self getTurtleModel] setVal:[NSNumber numberWithBool:YES] forKey:TURTLE_PEN_DOWN];
	}
}

- (void) executeCommand{
	NSDictionary* dic = self.cmds[self.cmds.count - 1]; // top one
	[self executeOneCommandAsDic:dic];
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
	self.constraints = nil;
	[self.paintView removeFromSuperview];
	self.paintView = nil;
	[self.view removeGestureRecognizer:self.pan];
	[self.view removeGestureRecognizer:self.pinch];
	self.pan.delegate = nil;
	self.pinch.delegate = nil;
	self.pinch = nil;
	self.pan = nil;
	self.cmds = nil;
}

@end

