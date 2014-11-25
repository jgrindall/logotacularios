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
#import "PBgModel.h"

@implementation PerformNewCommand

- (void) execute:(id) payload{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET_ZOOM withData:nil];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_RESET withData:nil];
	[[self getLogoModel] reset:@""];
	[[self getBgModel] reset];
	[[self getFileModel] reset];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PBgModel>) getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

@end
