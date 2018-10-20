//
//  PerformOpenCommand.m
//  LogotacularIOS
//
//  Created by John on 05/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingFinishedCommand.h"
#import "PDrawingModel.h"
#import "SymmNotifications.h"

@implementation DrawingFinishedCommand

- (void) execute:(id) payload{
	[[self getDrawingModel] setVal:@NO forKey:DRAWING_ISDRAWING];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

@end
