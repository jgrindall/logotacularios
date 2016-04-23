//
//  PaintView.h
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriView : UIView

extern float const TRI_RADIUS;

- (void) drawWithSize: (float)s withHeading:(float) h withColor:(UIColor*)clr;

@end
