//
//  ADeleteableController.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ImgController_Protected.h"
#import "ImgCell.h"
#import "Appearance.h"
#import <Objection/Objection.h>
#import "PImgListModel.h"
#import "PImgBrowserModel.h"
#import "ImgLayout.h"
#import "FileLoader.h"

@interface ImgController ()

@property NSString* cellIdent;
@property Class cellClass;
@property (nonatomic) NSArray* imgs;

@end

@implementation ImgController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class{
	self = [super initWithCollectionViewLayout:layout];
	if(self){
		self.cellIdent = ident;
		self.cellClass = class;
		[self layoutCollection];
		[[self getImgBrowserModel] addGlobalListener:@selector(selChanged) withTarget:self];
	}
	return self;
}

- (void) selChanged{
	[self.collectionView reloadData];
}

- (NSInteger) getSelected{
	NSNumber* n = (NSNumber*)[[self getImgBrowserModel] getVal:IMG_BROWSER_SELECTED_INDEX];
	return [n integerValue];
}

-(void)layoutCollection{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}

- (void) setImgs:(NSArray *)imgs{
	_imgs = imgs;
	[self.collectionView reloadData];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	[self.collectionView registerClass:[self cellClass] forCellWithReuseIdentifier:self.cellIdent];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_imgs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ImgCell* cell = (ImgCell*)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdent forIndexPath:indexPath];
	if(!cell) {
		cell = [[ImgCell alloc] init];
	}
	NSURL* url = self.imgs[indexPath.item];
	NSString* imagePath = [[FileLoader sharedInstance] getImagePathFromPath:url];
	cell.image = [UIImage imageWithContentsOfFile:imagePath];
	cell.filename = [[FileLoader sharedInstance] getFileNameFromPath:url];
	cell.isSelected = ([self getSelected] == indexPath.item);
	cell.clipsToBounds = YES;
	return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return IMG_LAYOUT_CELL_PADDING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return IMG_LAYOUT_CELL_PADDING;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(IMG_LAYOUT_CELL_WIDTH, IMG_LAYOUT_CELL_HEIGHT);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSNumber* index = @(indexPath.item);
	[[self getImgBrowserModel] setVal:index forKey:IMG_BROWSER_SELECTED_INDEX];
}

- (id<PImgBrowserModel>) getImgBrowserModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PImgBrowserModel)];
}

- (void) dealloc{
	self.cellIdent = nil;
	self.cellClass = nil;
	self.imgs = nil;
	[[self getImgBrowserModel] removeGlobalListener:@selector(selChanged) withTarget:self];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)ident withClass:(__unsafe_unretained Class)class{
	ImgCell* myCell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
	if(!myCell){
		myCell = [[class alloc] init];
	}
	return myCell;
}

@end
