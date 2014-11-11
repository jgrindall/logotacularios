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
#import "AlertManager.h"
#import "SaveCurrentViewController.h"
#import "ToastUtils.h"

@interface DrawPageViewController ()

@property UIView* textContainer;
@property UIView* paintContainer;
@property UIView* webContainer;
@property UIView* menuContainer;
@property TextViewController* textViewController;
@property PaintViewController* paintViewController;
@property WebViewController* webViewController;
@property MenuViewController* menuViewController;
@property AbstractAlertController* alert;
@property UIBarButtonItem* playButton;
@property UIBarButtonItem* listButton;
@property UIBarButtonItem* undoButton;
@property UIBarButtonItem* redoButton;
@property UIBarButtonItem* clearButton;

@end

@implementation DrawPageViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self layoutAll];
	[self fileTitleChanged:nil];
	[self drawingChanged];
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addPaint];
	[self addText];
	[self addWeb];
	[self addMenu];
	[self addNavButtons];
	[self addListeners];
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
	[[self getEventDispatcher] addListener:SYMM_NOTIF_CHECK_SAVE toFunction:@selector(showCheckSave) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SHOW_POPOVER toFunction:@selector(addPopover:) withContext:self];
}

- (void) showCheckSave{
	NSArray* options = [NSArray arrayWithObjects:@"Yes", TICK_ICON, @"No", CLEAR_ICON, nil];
	self.alert = [AlertManager addAlert:[SaveCurrentViewController class] intoController:self withDelegate:self withOptions:options];
}

- (void) showFilename{
	NSArray* options = [NSArray arrayWithObjects:@"Ok", TICK_ICON, @"Cancel", CLEAR_ICON, nil];
	self.alert = [AlertManager addAlert:[FilenameViewController class] intoController:self withDelegate:self withOptions:options];
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

- (void) addPopover:(NSNotification*)notif{
	UIView* exclam = (UIView*)notif.object;
	CGRect rect = exclam.frame;
	CGRect globalFrame = [self.view convertRect:rect fromView:exclam.superview];
	FilenameViewController* pop = [[FilenameViewController alloc] init];
	UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:pop];
	[popover presentPopoverFromRect:globalFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
	self.menuContainer = [[UIView alloc] initWithFrame:self.view.frame];
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
	self.textContainer = [[UIView alloc] initWithFrame:self.view.frame];
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

- (void) filenameClosed:(NSInteger)i withPayload:(id)payload{
	if(i == 0){
		NSString* name = (NSString*)payload;
		[[FileLoader sharedInstance] filenameOk:name withCallback:^(FileLoaderResults result, id data) {
			if(result == FileLoaderResultOk){
				BOOL ok = [data boolValue];
				if(ok){
					[AlertManager removeAlert];
					[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_SAVE withData:name];
				}
				else{
					[(FilenameViewController*)self.alert fileNameUsedError];
				}
			}
			else{
				[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileNameErrorMessage] withType:TSMessageNotificationTypeError];
			}
		}];
	}
	else if(i == 1){
		[AlertManager removeAlert];
	}
}

- (void) checkSaveClosed:(NSInteger)i withPayload:(id)payload{
	[AlertManager removeAlert];
	if(i == 0){
		[[self getEventDispatcher] addListener:SYMM_NOTIF_SAVED toFunction:@selector(onSaved) withContext:self];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_CLICK_SAVE withData:nil];
	}
	else if(i == 1){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_NEW withData:nil];
	}
};

- (void) onSaved{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SAVED toFunction:@selector(onSaved) withContext:self];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_NEW withData:nil];
}

- (void) clickButtonAt:(NSInteger)i withPayload:(id)payload{
	if([self.alert class] == [FilenameViewController class]){
		[self filenameClosed:i withPayload:payload];
	}
	else if([self.alert class] == [SaveCurrentViewController class]){
		[self checkSaveClosed:i withPayload:payload];
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

- (void) layoutText{
	int p = 7;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeRight multiplier:0.667 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
}

- (void) removeListeners{
	[[self getFileModel] removeGlobalListener:@selector(setTitle:) withTarget:self];
	[[self getDrawingModel] removeListener:@selector(drawingChanged) forKey:DRAWING_ISDRAWING withTarget:self];
	[[self getLogoModel] removeGlobalListener:@selector(logoChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SHOW_FILENAME toFunction:@selector(showFilename) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_CHECK_SAVE toFunction:@selector(showCheckSave) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SHOW_POPOVER toFunction:@selector(addPopover:) withContext:self];
}

- (void) dealloc{
	[self removeListeners];
}

@end
