//
//  FilePageController.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FilePageController.h"
#import "FileLoader.h"
#import "FileCell.h"
#import "FileLoader.h"
#import "FilesController.h"
#import "PFileListModel.h"
#import "Assets.h"
#import "Appearance.h"
#import "FileBrowserModel.h"
#import "SymmNotifications.h"
#import "FileLayout.h"

@interface FilePageController ()

@property UIView* filesContainer;
@property FilesController* filesController;
@property UILabel* emptyLabel;
@property UIBarButtonItem* openButton;
@property UIBarButtonItem* delButton;

@end

@implementation FilePageController

- (instancetype) init{
	self = [super init];
	if(self){
		[[self getFileListModel] addListener:@selector(filesChanged) forKey:FILE_LIST_LIST withTarget:self];
		[[self getFileBrowserModel] addGlobalListener:@selector(selChanged) withTarget:self];
		[[self getEventDispatcher] addListener:SYMM_NOTIF_FILE_LOADED toFunction:@selector(fileLoaded) withContext:self];
	}
	return self;
}

- (void) selChanged{
	BOOL allowOpenDelete = NO;
	NSInteger index = [self getSelected];
	if(index >= 0){
		allowOpenDelete = YES;
	}
	[self.openButton setEnabled:allowOpenDelete];
	[self.delButton setEnabled:allowOpenDelete];
	[[self.openButton customView] setHidden:!allowOpenDelete];
	[[self.delButton customView] setHidden:!allowOpenDelete];
}

- (NSInteger) getSelected{
	NSNumber* n = (NSNumber*)[[self getFileBrowserModel] getVal:BROWSER_SELECTED_INDEX];
	return [n integerValue];
}

- (id<PFileBrowserModel>) getFileBrowserModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileBrowserModel)];
}

- (void) filesChanged{
	NSArray* files = (NSArray*)[[self getFileListModel] getVal:FILE_LIST_LIST];
	BOOL hideLabel = ([files count] >= 1);
	[self.emptyLabel setHidden:hideLabel];
	[self.filesContainer setHidden:!hideLabel];
	[self.filesController setFiles:files];
}

- (id<PFileListModel>) getFileListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileListModel)];
}

-(void)layoutFiles{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

-(void)layoutLabel{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:500.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil				attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

- (void) addRightBarButtons{
	self.openButton = [self getBarButtonItem:WASTE_ICON withAction:@selector(onClickDelete)];
	self.delButton = [self getBarButtonItem:TICK_ICON withAction:@selector(onClickOpen)];
	self.navigationItem.rightBarButtonItems = @[self.openButton, self.delButton];
}

-(void)onClickDelete{
	NSNumber* n = @([self getSelected]);
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_DEL withData:n];
}

-(void)onClickOpen{
	NSNumber* n = @([self getSelected]);
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_OPEN withData:n];
}

- (void) fileLoaded{
	[self.navigationController popViewControllerAnimated:YES];
}

-(UIButton*)getBarButton: (UIBarButtonItem*) item{
	return item.customView.subviews[0];
}

-(UIBarButtonItem*)getBarButtonItem: (NSString*) imageUrl withAction:(SEL)action{
	UIBarButtonItem* item = [Appearance getBarButton:imageUrl withLabel:nil];
	UIButton* btn = [self getBarButton:item];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return item;
}

- (void) addLabel{
	self.emptyLabel = [[UILabel alloc] initWithFrame:self.view.frame];
	[self.emptyLabel setText:@"No files found"];
	self.emptyLabel.font = [Appearance fontOfSize:SYMM_FONT_SIZE_LARGE];
	self.emptyLabel.textColor = [UIColor whiteColor];
	self.emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.emptyLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.emptyLabel];
	[self layoutLabel];
}

- (void) addCollection{
	self.filesContainer = [[UIView alloc] initWithFrame:self.view.frame];
	self.filesContainer.backgroundColor = [UIColor clearColor];
	self.filesContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.view.backgroundColor = [Colors getColorForString:[Colors getDark:1]];
	[self.view addSubview:self.filesContainer];
	UICollectionViewFlowLayout* aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[aFlowLayout setItemSize:CGSizeMake(FILE_LAYOUT_CELL_WIDTH, FILE_LAYOUT_CELL_HEIGHT)];
	[aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	aFlowLayout.sectionInset = UIEdgeInsetsMake(FILE_LAYOUT_CELL_PADDING, FILE_LAYOUT_CELL_PADDING, FILE_LAYOUT_CELL_PADDING, FILE_LAYOUT_CELL_PADDING);
	self.filesController = [[FilesController alloc] initWithCollectionViewLayout:aFlowLayout withCellIdent:@"FileCell" withCellClass:[FileCell class]];
	[self addChildInto:self.filesContainer withController:self.filesController];
	[self layoutFiles];
}

- (void) viewWillDisappear:(BOOL)animated{
	[[self getFileBrowserModel] reset];
}

- (void) viewDidLoad{
	[self addCollection];
	[self addLabel];
	[self addRightBarButtons];
	[self.filesContainer setHidden:YES];
	[self.emptyLabel setHidden:YES];
	[self filesChanged];
	[self selChanged];
}

- (void) dealloc{
	[[self getFileListModel] removeListener:@selector(filesChanged) forKey:FILE_LIST_LIST withTarget:self];
	[[self getFileBrowserModel] removeGlobalListener:@selector(selChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_FILE_LOADED toFunction:@selector(fileLoaded) withContext:self];
}

@end

