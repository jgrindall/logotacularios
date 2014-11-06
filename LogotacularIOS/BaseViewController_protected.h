//
//  BaseViewController_protected.h
//  
//
//  Created by John on 28/10/2014.
//
//

#import "BaseViewController.h"
#import "PLogger.h"
#import "PEventDispatcher.h"

@interface BaseViewController ()

- (id<PLogger>) getLogger;

- (id<PEventDispatcher>) getEventDispatcher;

- (void) bubbleSelector:(NSString*) selector withObject:(id) obj;

@end
