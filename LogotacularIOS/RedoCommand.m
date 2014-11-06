//
//  RedoCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "RedoCommand.h"
#import "PLogoModel.h"

@implementation RedoCommand

- (void) execute:(id) payload{
	[[self getLogoModel] redo];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

@end
