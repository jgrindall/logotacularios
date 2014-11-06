//
//  ClickNewCommand.m
//  LogotacularIOS
//
//  Created by John on 06/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickNewCommand.h"
#import "PFileModel.h"
#import "PLogoModel.h"

@implementation ClickNewCommand

- (void) execute:(id) payload{
	[[self getLogoModel] reset:@""];
	[[self getFileModel] reset];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
