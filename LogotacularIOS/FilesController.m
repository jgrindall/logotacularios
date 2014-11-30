//
//  ADeleteableController.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FilesController_Protected.h"
#import "FileCell.h"
#import "Appearance.h"
#import "PFileBrowserModel.h"
#import <Objection/Objection.h>
#import "PFileListModel.h"
#import "FileLoader.h"
#import "FileLayout.h"

@interface FilesController ()

@property NSString* cellIdent;
@property Class cellClass;
@property (nonatomic) NSArray* files;

@end

@implementation FilesController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class{
	self = [super initWithCollectionViewLayout:layout];
	if(self){
		self.cellIdent = ident;
		self.cellClass = class;
		[self layoutCollection];
		[[self getFileBrowserModel] addGlobalListener:@selector(selChanged) withTarget:self];
	}
	return self;
}

- (void) selChanged{
	[self.collectionView reloadData];
}

-(void)layoutCollection{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView	attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}

- (void) setFiles:(NSArray *)files{
	_files = files;
	[self.collectionView reloadData];
}

- (void)viewDidLoad{
	self.view.backgroundColor = [UIColor clearColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	[self.collectionView registerClass:[self cellClass] forCellWithReuseIdentifier:self.cellIdent];
}

- (id<PFileBrowserModel>) getFileBrowserModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileBrowserModel)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_files count];
}

- (NSInteger) getSelected{
	NSNumber* n = (NSNumber*)[[self getFileBrowserModel] getVal:BROWSER_SELECTED_INDEX];
	return [n integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FileCell* cell = (FileCell*)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdent forIndexPath:indexPath];
	if(!cell) {
		cell = [[FileCell alloc] init];
	}
	NSURL* url = self.files[indexPath.item];
	NSString* imagePath = [[FileLoader sharedInstance] getImagePathFromPath:url];
	cell.image = [UIImage imageWithContentsOfFile:imagePath];
	cell.filename = [[FileLoader sharedInstance] getFileNameFromPath:url];
	cell.isSelected = ([self getSelected] == indexPath.item);
	cell.clipsToBounds = YES;
	return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return FILE_LAYOUT_CELL_PADDING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return FILE_LAYOUT_CELL_PADDING;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(FILE_LAYOUT_CELL_WIDTH, FILE_LAYOUT_CELL_HEIGHT);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSNumber* index = @(indexPath.item);
	[[self getFileBrowserModel] setVal:index forKey:BROWSER_SELECTED_INDEX];
}

- (void) dealloc{
	self.cellIdent = nil;
	self.cellClass = nil;
	self.files = nil;
	[[self getFileBrowserModel] removeGlobalListener:@selector(selChanged) withTarget:self];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)ident withClass:(__unsafe_unretained Class)class{
	FileCell* myCell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
	if(!myCell){
		myCell = [[class alloc] init];
	}
	return myCell;
}

@end
