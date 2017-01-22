//
//  ClickSaveAsCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "EditGridClrCommand.h"
#import "SymmNotifications.h"
#import "POptionsModel.h"

@implementation EditGridClrCommand

- (void) execute:(id) payload{
	NSLog(@"change %@", payload);
	[[self getOptionsModel] setVal:(UIColor*)payload forKey:GRID_CLR];
}

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
}

@end
