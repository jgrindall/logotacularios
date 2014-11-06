//
//  UndoCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "UndoCommand.h"
#import "PLogoModel.h"

@implementation UndoCommand

- (void) execute:(id) payload{
	[[self getLogoModel] undo];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

@end
