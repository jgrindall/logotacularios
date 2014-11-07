//
//  PaintViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"

@interface PaintViewController : BaseViewController

- (void) reset;

- (void) executeCommand:(NSDictionary*)dic;

- (UIImage*)getImage;

@end
