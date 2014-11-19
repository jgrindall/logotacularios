//
//  FileCell.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UICollectionViewCell

@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* filename;
@property (nonatomic) BOOL isSelected;

@end
