//
//  PLogoModel.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAbstractModel.h"

@protocol PLogoModel <PAbstractModel>

extern NSString* const LOGO_POINTER;
extern NSString* const LOGO_HISTORY;

- (BOOL) undoEnabled;

- (BOOL) redoEnabled;

- (void) undo;

- (void) redo;

- (void) add:(NSString*) val;

- (void) reset:(NSString*) val;

- (NSString*) get;

@end
