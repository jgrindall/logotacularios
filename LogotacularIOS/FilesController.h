//
//  ADeleteableController.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesController : UICollectionViewController <UIGestureRecognizerDelegate>

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class NS_DESIGNATED_INITIALIZER;

- (void) setFiles:(NSArray*) files;

@end
