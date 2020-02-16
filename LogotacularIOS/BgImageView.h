//
//  PaintView.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BgImageView : UIView

- (void) reset;
- (void) setImg:(NSURL*) bgImg;
- (void) setTransformWith:(CGAffineTransform)transform;

@property CGAffineTransform flushedTransform;

@end
