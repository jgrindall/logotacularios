//
//  ClickSaveAsCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "EditGridTypeCommand.h"
#import "SymmNotifications.h"
#import "POptionsModel.h"

@implementation EditGridTypeCommand

- (void) execute:(id) payload{
	[[self getOptionsModel] setVal:(NSNumber*)payload forKey:GRID_TYPE];
}

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
}

@end
