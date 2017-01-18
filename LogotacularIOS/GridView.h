//
//  PaintView.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView

- (void) onViewDidLoad;
- (void) redraw;

@property CGAffineTransform flushedTransform;

@end
