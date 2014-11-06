//
//  AbstractCommand.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractCommand+protected.h"
#import <Objection/Objection.h>

@implementation AbstractCommand

- (void) execute:(id) payload{
	NSLog(@"ex %@", payload);
}

- (id<PEventDispatcher>) getEventDispatcher{
	return [[JSObjection defaultInjector] getObject:@protocol(PEventDispatcher)];
}

@end
