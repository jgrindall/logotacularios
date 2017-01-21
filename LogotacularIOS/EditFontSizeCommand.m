//
//  ClickSaveAsCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "EditFontSizeCommand.h"
#import "SymmNotifications.h"
#import "POptionsModel.h"

@implementation EditFontSizeCommand

- (void) execute:(id) payload{
	[[self getOptionsModel] setVal:(NSNumber*)payload forKey:FONT_SIZE];
}

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
}

@end
