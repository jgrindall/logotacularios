//
//  ViewController.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawPageViewController.h"
#import "ImageUtils.h"
#import "Appearance.h"
#import "SymmNotifications.h"
#import "Assets.h"
#import "PFileModel.h"
#import "PMenuModel.h"
#import "TextViewController.h"
#import "PaintViewController.h"
#import "WebViewController.h"
#import "MenuViewController.h"
#import "PDrawingModel.h"
#import "PLogoModel.h"
#import "FilenameViewController.h"
#import "FileLoader.h"

@interface DrawPageViewController ()

@property UIView* textContainer;
@property UIView* paintContainer;
@property UIView* webContainer;
@property UIView* menuContainer;
@property UIView* filenameContainer;
@property TextViewController* textViewController;
@property PaintViewController* paintViewController;
@property WebViewController* webViewController;
@property MenuViewController* menuViewController;
@property FilenameViewController* filenameViewController;
@property UIBarButtonItem* playButton;
@property UIBarButtonItem* listButton;
@property UIBarButtonItem* undoButton;
@property UIBarButtonItem* redoButton;
@property UIBarButtonItem* clearButton;

@end

@implementation DrawPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addPaint];
	[self addText];
	[self addWeb];
	[self addMenu];
	[self layoutAll];
	[self addNavButtons];
	[self addListeners];
	[self fileTitleChanged:nil];
	[self drawingChanged];
}

- (void) fileTitleChanged:(id)data{
	NSString* name = [[self getFileModel] getVal:FILE_FILENAME];
	BOOL dirty = [[[self getFileModel] getVal:FILE_DIRTY] boolValue];
	BOOL real = [[[self getFileModel] getVal:FILE_REAL] boolValue];
	if(!real){
		name = @"Unsaved file *";
	}
	else if(dirty){
		name = [NSString stringWithFormat:@"%@%@", name, @" *"];
	}
	self.title = name;
}

- (void) addListeners{
	[[self getFileModel] addGlobalListener:@selector(fileTitleChanged:) withTarget:self];
	[[self getLogoModel] addGlobalListener:@selector(logoChanged) withTarget:self];
	[[self getDrawingModel] addListener:@selector(drawingChanged) forKey:DRAWING_ISDRAWING withTarget:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SHOW_FILENAME toFunction:@selector(showFilename) withContext:self];
}

- (void) showFilename{
	self.filenameContainer = [[UIView alloc] initWithFrame:self.view.frame];
	self.filenameViewController = [[FilenameViewController alloc] init];
	[self.view addSubview:self.filenameContainer];
	[self addChildInto:self.filenameContainer withController:self.filenameViewController];
	[self layoutFilename];
}

- (void) hideFilename{
	[self removeChildFrom:self.filenameContainer withController:self.filenameViewController];
	[self.filenameContainer removeFromSuperview];
	self.filenameContainer = nil;
	self.filenameViewController = nil;
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (void) logoChanged{
	[self updateUndoRedo];
}

- (void) drawingChanged{
	BOOL drawing = [[[self getDrawingModel] getVal:DRAWING_ISDRAWING] boolValue];
	if(drawing){
		[[self getBarButton:self.playButton] setImage:[UIImage imageNamed:STOP_ICON] forState:UIControlStateNormal];
	}
	else{
		[[self getBarButton:self.playButton] setImage:[UIImage imageNamed:PLAY_ICON] forState:UIControlStateNormal];
	}
	[[self getBarButton:self.listButton] setEnabled:!drawing];
	[self updateUndoRedo];
}

- (void) updateUndoRedo{
	BOOL drawing = [[[self getDrawingModel] getVal:DRAWING_ISDRAWING] boolValue];
	[[self getBarButton:self.undoButton] setEnabled:(!drawing && [self undoEnabled])];
	[[self getBarButton:self.redoButton] setEnabled:(!drawing && [self redoEnabled])];
}

- (BOOL) undoEnabled{
	return [[self getLogoModel] undoEnabled];
}

- (BOOL) redoEnabled{
	return [[self getLogoModel] redoEnabled];
}

-(UIButton*)getBarButton: (UIBarButtonItem*) item{
	return [[item.customView subviews] objectAtIndex:0];
}

-(UIBarButtonItem*)getBarButtonItem: (NSString*) imageUrl withAction:(SEL)action{
	UIBarButtonItem* item = [Appearance getBarButton:imageUrl];
	UIButton* btn = [self getBarButton:item];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return item;
}

-(void)addNavButtons{
	self.listButton = [self getBarButtonItem:LIST_ICON withAction:@selector(onClickList)];
	self.clearButton = [self getBarButtonItem:CLEAR_ICON withAction:@selector(onClickClear)];
	self.redoButton = [self getBarButtonItem:REDO_ICON withAction:@selector(onClickRedo)];
	self.undoButton = [self getBarButtonItem:UNDO_ICON withAction:@selector(onClickUndo)];
	self.playButton = [self getBarButtonItem:PLAY_ICON withAction:@selector(onClickPlay)];
	self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.listButton, nil];
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.clearButton, self.redoButton, self.undoButton, self.playButton, nil];
}

- (void) addWeb{
	self.webContainer = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:self.webContainer];
	self.webViewController = [[WebViewController alloc] init];
	[self addChildInto:self.webContainer withController:self.webViewController];
}

- (void) addMenu{
	self.menuContainer = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:self.menuContainer];
	self.menuContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.menuViewController = [[MenuViewController alloc] init];
	[self addChildInto:self.menuContainer withController:self.menuViewController];
}

-(void) addPaint{
	self.paintContainer = [[UIView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.paintContainer];
	self.paintContainer.translatesAutoresizingMaskIntoConstraints = NO;
	[self layoutPaint];
	self.paintViewController = [[PaintViewController alloc] init];
	[self addChildInto:self.paintContainer withController:self.paintViewController];
}

- (void) addText{
	self.textContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	self.textContainer.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.textContainer];
	[self layoutText];
	self.textViewController = [[TextViewController alloc] init];
	[self addChildInto:self.textContainer withController:self.textViewController];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	int dx = self.view.frame.size.width - location.x;
	if(abs(dx < 80)){
		[self.textViewController show];
	}
	else{
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_MENU withData:nil];
	}
}

-(void)fileCancel{
	[self hideFilename];
}

-(void)fileOk:(id)obj{
	NSString* name = (NSString*)obj;
	if([[FileLoader sharedInstance] filenameOk:name]){
		[self hideFilename];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_SAVE withData:name];
	}
	else{
		[self.filenameViewController error];
	}
}

-(void)onClickList{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_MENU withData:nil];
}

-(void)onClickUndo{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_UNDO withData:nil];
}

-(void)onClickRedo{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_REDO withData:nil];
}

-(void)onClickClear{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLEAR withData:nil];
}

-(void)onClickPlay{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_PLAY withData:nil];
}

- (void) layoutAll{
	[self layoutMenu];
	[self layoutPaint];
	[self layoutText];
}

-(void)layoutMenu{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil							attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:250.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil							attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:250.0]];
}

-(void)layoutPaint{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

-(void)layoutFilename{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filenameContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filenameContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filenameContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filenameContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) layoutText{
	int padding = 7;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:0.6667 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide		attribute:NSLayoutAttributeTop multiplier:1.0 constant:-3*padding]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) removeListeners{
	[[self getFileModel] removeGlobalListener:@selector(setTitle:) withTarget:self];
	[[self getDrawingModel] removeListener:@selector(drawingChanged) forKey:DRAWING_ISDRAWING withTarget:self];
	[[self getLogoModel] removeGlobalListener:@selector(logoChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SHOW_FILENAME toFunction:@selector(showFilename) withContext:self];
}

- (void) dealloc{
	[self removeListeners];
}

@end
