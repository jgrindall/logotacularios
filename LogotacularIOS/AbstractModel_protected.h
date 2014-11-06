//
//  AbstractModel_protected.h
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractModel.h"

@interface AbstractModel ()

@property NSMutableDictionary* propHash;
@property NSMutableArray* listeners;
@property NSMutableArray* globalListeners;
@property NSMutableArray* globalTargets;
@property NSMutableArray* keys;
@property NSMutableArray* targets;

- (void) setDefaults;

@end
