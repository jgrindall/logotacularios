//
//  FilePageController.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ImgPageController.h"
#import "Assets.h"
#import "Appearance.h"
#import "ImgCell.h"
#import "ImgLayout.h"
#import "PImgListModel.h"
#import "PImgBrowserModel.h"
#import "ImgController.h"
#import "SymmNotifications.h"

@interface ImgPageController ()

@property UIView* imgsContainer;
@property ImgController* imgsController;
@property UIBarButtonItem* openButton;
@property UIBarButtonItem* delButton;
@property UIBarButtonItem* addButton;
@property UILabel* emptyLabel;
@property NSArray* constraints;
@property UIPopoverController* popController;

@end

@interface UIImagePickerController(Nonrotating)
- (BOOL)shouldAutorotate;
@end

@implementation UIImagePickerController(Nonrotating)

- (BOOL)shouldAutorotate {
	return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskLandscape;
}

@end

@implementation ImgPageController

- (instancetype) init{
	self = [super init];
	if(self){
		[[self getImgListModel] addListener:@selector(imgsChanged) forKey:IMG_LIST_LIST withTarget:self];
		[[self getImgBrowserModel] addGlobalListener:@selector(selChanged) withTarget:self];
		[[self getEventDispatcher] addListener:SYMM_NOTIF_IMG_LOADED toFunction:@selector(imgLoaded) withContext:self];
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

- (id<PImgListModel>) getImgListModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PImgListModel)];
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

-(void)layoutLabel{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:500.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil				attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50.0]];
}

-(void)layoutImgs{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgsContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide				attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgsContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgsContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgsContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

- (void) addRightBarButtons{
	self.openButton = [self getBarButtonItem:WASTE_ICON withAction:@selector(onClickDelete)];
	self.delButton = [self getBarButtonItem:TICK_ICON withAction:@selector(onClickOpen)];
	self.addButton = [self getBarButtonItem:ADD_ICON withAction:@selector(onClickAdd)];
	self.navigationItem.rightBarButtonItems = @[self.addButton, self.openButton, self.delButton];
}

- (NSInteger) getSelected{
	NSNumber* n = (NSNumber*)[[self getImgBrowserModel] getVal:IMG_BROWSER_SELECTED_INDEX];
	return [n integerValue];
}

- (id<PImgBrowserModel>) getImgBrowserModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PImgBrowserModel)];
}

-(void)onClickDelete{
	NSNumber* n = @([self getSelected]);
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_DEL_IMG withData:n];
}

-(void)onClickOpen{
	NSNumber* n = @([self getSelected]);
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_OPEN_IMG withData:n];
}

-(void)onClickAdd{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_ADD_IMG withData:nil];
	UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
	self.popController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
	[self.popController presentPopoverFromBarButtonItem:self.addButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = info[UIImagePickerControllerOriginalImage];
	// Do something with picked image
	NSLog(@"picked");
}

- (void) imgLoaded{
	//[self.navigationController popViewControllerAnimated:YES];
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

- (void) addCollection{
	self.imgsContainer = [[UIView alloc] initWithFrame:self.view.frame];
	self.imgsContainer.backgroundColor = [UIColor clearColor];
	self.imgsContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.view.backgroundColor = [Colors getColorForString:[Colors getDark:@"images"]];
	[self.view addSubview:self.imgsContainer];
	UICollectionViewFlowLayout* aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[aFlowLayout setItemSize:CGSizeMake(IMG_LAYOUT_CELL_WIDTH, IMG_LAYOUT_CELL_HEIGHT)];
	[aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	aFlowLayout.sectionInset = UIEdgeInsetsMake(IMG_LAYOUT_CELL_PADDING, IMG_LAYOUT_CELL_PADDING, IMG_LAYOUT_CELL_PADDING, IMG_LAYOUT_CELL_PADDING);
	self.imgsController = [[ImgController alloc] initWithCollectionViewLayout:aFlowLayout withCellIdent:@"ImgCell" withCellClass:[ImgCell class]];
	[self addChildInto:self.imgsContainer withController:self.imgsController];
	[self layoutImgs];
}

- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[self getImgBrowserModel] reset];
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addCollection];
	[self addLabel];
	[self addRightBarButtons];
	[self.imgsContainer setHidden:YES];
	[self.emptyLabel setHidden:YES];
	[self imgsChanged];
	[self selChanged];
}

- (void) imgsChanged{
	NSArray* imgs = (NSArray*)[[self getImgListModel] getVal:IMG_LIST_LIST];
	BOOL hideLabel = ([imgs count] >= 1);
	[self.emptyLabel setHidden:hideLabel];
	[self.imgsContainer setHidden:!hideLabel];
	[self.imgsController setImgs:imgs];
}

- (void) dealloc{
	[[self getImgListModel] removeListener:@selector(imgsChanged) forKey:IMG_LIST_LIST withTarget:self];
	[[self getImgBrowserModel] removeGlobalListener:@selector(selChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_IMG_LOADED toFunction:@selector(imgLoaded) withContext:self];
	[self removeChildFrom:self.imgsContainer withController:self.imgsController];
	[self.imgsContainer removeFromSuperview];
	self.imgsContainer = nil;
	self.imgsController = nil;
	self.navigationItem.leftBarButtonItems = @[];
	self.navigationItem.rightBarButtonItems = @[];
}

@end

