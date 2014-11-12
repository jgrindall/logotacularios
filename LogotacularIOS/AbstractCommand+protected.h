//
//  BaseViewController_protected.h
//
//
//  Created by John on 28/10/2014.
//
//

#import "AbstractCommand.h"
#import "PEventDispatcher.h"
#import <Objection/Objection.h>
#import "SymmNotifications.h"
#import <UIKit/UIKit.h>

@interface AbstractCommand ()

- (id<PEventDispatcher>) getEventDispatcher;

@end
