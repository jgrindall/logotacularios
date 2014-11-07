//
//  PerformNewCommand.m
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PerformNewCommand.h"
#import "PLogoModel.h"
#import "PFileModel.h"
#import <Objection/Objection.h>

@implementation PerformNewCommand

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
